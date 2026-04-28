# IDOR Vulnerability - Minimal Backend Fix Guide

**Date:** 2026-04-28
**Severity:** CRITICAL
**Type:** Broken Object Level Authorization (BOLA / IDOR)
**Status:** Frontend temp-hardened, backend fix required

## The Problem

All API endpoints accept a user ID in the URL path and execute the action for that user without verifying that the caller owns that ID. Any authenticated user can perform actions on behalf of any other user by changing the ID in the request.

**Example attack:**
```
# Legitimate request from user 42
GET /api/purchase_coupon/42/15

# Attacker changes 42 to 99 — buys coupon using user 99's points
GET /api/purchase_coupon/99/15
```

## Vulnerable Endpoints

### CRITICAL — Financial / Write Operations

| Endpoint | Method | Risk |
|----------|--------|------|
| `/api/purchase_coupon/{userId}/{couponId}` | GET | Purchase coupons charged to another user's points |
| `/api/purchase_product/{userId}/{productId}` | GET | Redeem products using another user's points |
| `/api/buyluckydraw/{userId}/{drawId}/{amount}` | GET | Buy lucky draw tickets using another user's points |
| `/api/buypointpackage/{userId}/{packageId}` | GET | Trigger payment for point packages on another user's account |
| `/api/edit/{userId}` | POST | Modify another user's profile (name, phone, address) |
| `/api/upload_pic` | POST | Potentially overwrite another user's profile picture |
| `/api/deleteAccount` | POST/DELETE | Delete another user's account |

### HIGH — Data Exposure / Read Operations

| Endpoint | Method | Risk |
|----------|--------|------|
| `/api/transactionlist/{userId}` | GET | View another user's transaction history |
| `/api/coupontransactionlist/{userId}` | GET | View another user's coupon transactions |
| `/api/producttransactionlist/{userId}` | GET | View another user's product redemption history |
| `/api/cashbacktransactionlist/{userId}` | GET | View another user's cashback history |
| `/api/topuptransactionlist/{userId}` | GET | View another user's top-up history |
| `/api/returnpointshistory/{userId}` | GET | View another user's return points history |
| `/api/showpurchasedCoupon/{userId}` | GET | View another user's purchased coupons |
| `/api/showpurchasedproduct/{userId}` | GET | View another user's redeemed products |
| `/api/getluckydrawlist/{userId}` | GET | View another user's lucky draw entries |
| `/api/getluckydrawwinner/{userId}` | GET | View another user's winning status |
| `/api/userinfo` | POST | Potentially access another user's profile data |

## Minimal Backend Fix

The fix is a single middleware/guard that runs on every authenticated endpoint. It extracts the user ID from the JWT token and compares it to the user ID in the URL.

### Step 1: Auth Middleware (add to all routes)

The app already sends a JWT token via `Authorization: Bearer <token>` header (login stores it, frontend now sends it on critical endpoints). The backend just needs to validate it.

**Pseudocode (adapt to your backend framework):**

```python
# Example: Express.js / Node.js
def auth_middleware(req, res, next):
    token = req.headers.get("Authorization", "").replace("Bearer ", "")
    if not token:
        return res.status(401).json({"error": "No token provided"})

    try:
        payload = jwt.decode(token, SECRET_KEY)
        req.authenticated_user_id = payload["user_id"]
    except:
        return res.status(401).json({"error": "Invalid token"})

    next()
```

```python
# Example: Laravel (PHP)
// In middleware:
$user = auth()->user();  // From JWT
if (!$user) {
    return response()->json(['error' => 'Unauthorized'], 401);
}
$request->merge(['authenticated_user_id' => $user->id]);
```

### Step 2: Owner Validation (add to each endpoint handler)

For every endpoint that takes `{userId}` in the URL, verify it matches the token:

```python
# Before executing any business logic:
url_user_id = req.params.get("userId")
token_user_id = req.authenticated_user_id

if str(url_user_id) != str(token_user_id):
    return res.status(403).json({"error": "Forbidden: user ID mismatch"})
```

```python
# Laravel example:
$urlUserId = $request->route('userId');
$tokenUserId = $request->authenticated_user_id;

if ($urlUserId != $tokenUserId) {
    return response()->json(['error' => 'Forbidden'], 403);
}
```

### Step 3: Ideal Long-term Refactor

Remove user ID from URLs entirely. Derive it from the JWT token server-side:

```
# Current (vulnerable):
GET /api/purchase_coupon/{userId}/{couponId}

# Fixed (user derived from token):
POST /api/purchase_coupon
Authorization: Bearer <jwt>
Body: { "coupon_id": 15 }

# Server extracts user_id from JWT, never trusts the client
```

This eliminates the attack surface completely — there is no user ID to tamper with.

## What the Frontend Already Does (temp fix)

As of 2026-04-28, the Flutter app has been hardened:

1. **Critical write endpoints** (`PurchaseCoupon`, `buyproduct`, `buyluckydraw`, `buypointpackage`) now fetch the user ID internally from SharedPreferences instead of accepting it as a parameter
2. **JWT Bearer token** is sent in the `Authorization` header on these endpoints
3. Helper `getAuthHeaders()` added in `lib/config/helper/common/get_user_info.dart`

**This does NOT prevent proxy-based attacks.** An attacker using Burp Suite, mitmproxy, or similar tools can intercept and modify requests after they leave the app. The backend fix above is required to fully close the vulnerability.

## Priority Order for Backend Implementation

1. **IMMEDIATE** — Add auth middleware + owner check to all CRITICAL (write) endpoints
2. **NEXT** — Add auth middleware + owner check to all HIGH (read) endpoints
3. **LATER** — Refactor to remove user ID from URLs entirely (derive from token)

## Testing the Fix

After implementing the backend middleware, verify with these tests:

```bash
# 1. Get a valid token for user 42
TOKEN=$(curl -s -X POST /api/login -d '{"email":"user42@test.com","password":"..."}' | jq -r '.access_token')

# 2. Legitimate request — should succeed (200)
curl -H "Authorization: Bearer $TOKEN" /api/purchase_coupon/42/15
# Expected: 200 OK

# 3. IDOR attempt — should fail (403)
curl -H "Authorization: Bearer $TOKEN" /api/purchase_coupon/99/15
# Expected: 403 Forbidden {"error": "Forbidden: user ID mismatch"}

# 4. No token — should fail (401)
curl /api/purchase_coupon/42/15
# Expected: 401 Unauthorized

# 5. Repeat for each critical endpoint
```
