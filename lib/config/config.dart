class Api {
  static const _bucketbase = "https://9coin.s3.ap-southeast-1.amazonaws.com";
  static const _base = "http://9coinapi.ap-southeast-1.elasticbeanstalk.com";
  static const _api = "/api";
  static const _register = "/register";
  static const _login = "/login";
  static const _getPdf = "/get_pdf";
  static const _luckyDraw = "/lucky_draw";
  static const _luckyDrawn = "/check_participants?participant_id";
  static const _news = "/news";
  static const _partcipants = "/add_participants";
  static const _couponlist = "/coupon_list";
  static const _getcoupondetail = "/getcoupondetail";
  static const _purchasecoupon = "/purchase_coupon";
  static const _purchasecouponlist = "/showpurchasedCoupon";
  static const _forgetPassword = "/forget_password";
  static const _changePassword = "/change_password";
  static const _TermAndCondition = "/TermAndCondition";
  static const _MerchantList = "/MerchantList";
  static const _MerchantDetail = "/MerchantDetail";
  static const _MerchantproductImage = "/MerchantProductImg/";
  static const _GetMerchant = "/MerchantList";
  static const _GetTransaction = "/transactionlist";
  static const _GetProductList = "/redeemProuct_list";
  static const _GetProductDetail = "/redeemproductdetail";
  static const _Newslist = "/newslist";
  static const _NewsDetaillist = "/newsdetail";
  static const _Luckydrawpartcipants = "/getluckydrawlist";
  static const _LuckydrawpartcipantsList = "/getluckydrawlists";
  static const _Buyluckydraw = "/buyluckydraw";
  static const _LuckydrawInfo = "/getluckydrawinfo";
  static const _LuckydrawInfos = "/getluckydrawinfos";
  static const _UpdateLuckyDrawRedeem = "/updateluckdrawredeem";
  static const _purchaseproduct = "/purchase_product";
  static const _showpurchasedproduct = "/showpurchasedproduct";
  static const _showpurchasedproductdetail = "/showpurchasedproductdetail";
  static const _getluckydrawwinner = "/getluckydrawwinner";
  static const _forgetpassword = "/forget_password";
  static const _getuserdata = "/userinfo";
  static const _getcategory = "/categorylist";
  static const _getcategoryrandom = "/categorylistrandom";
  static const _getpointpackage = "/pointpackage";
  static const _notification = "/notifications";
  static const _buypointpackage = "/buypointpackage";
  static const _banner = "/banner";
  static const _searchmerchant = "/SearchMerchant";
  static const _verification = "/verification";
  static const _luckydrawtnc = "/luckydrawtnc";
  static const _pointpackagetnc = "/pointpackagetnc";
  static const _topuptransactionlist = "/topuptransactionlist";
  static const _returnPointsHistory = "/returnpointshistory";
  static const _GetCouponTransaction = "/coupontransactionlist";
  static const _GetCashBackTransaction = "/cashbacktransactionlist";
  static const _GetProductTransaction = "/producttransactionlist";
  static const _editUser = "/edit";
  static const _uploadimage = "/upload_pic";
  static const _getuserimage = "/profile_pic";
  static const _fileDownloadPath = "/download-file/:type/:id";
  static const _accountDelete = "/deleteAccount";

  static String baseUrl = "$_base$_api";
  static String login = "$_base$_api$_login";
  static String verification = "$_base$_api$_verification";
  static String register = "$_base$_api$_register";
  static String getPdf = "$_base$_api$_getPdf";
  static String getLuckyDraw = "$_base$_api$_luckyDraw";
  static String getLuckyDrawn = "$_base$_api$_luckyDrawn";
  static String getNews = "$_base$_api$_news";
  static String updatePartcipants = "$_base$_api$_partcipants";
  static String couponlist = "$_base$_api$_couponlist";
  static String getcoupondetail = "$_base$_api$_getcoupondetail";
  static String purchasecoupon = "$_base$_api$_purchasecoupon";
  static String purchasecouponlist = "$_base$_api$_purchasecouponlist";
  static String termandcondition = "$_base$_api$_TermAndCondition";
  static String merchant = "$_base$_api$_MerchantList";
  static String merchantdetail = "$_base$_api$_MerchantDetail";
  static String bucketurl = "$_bucketbase$_MerchantproductImage";
  static String getmerchant = "$_base$_api$_GetMerchant";
  static String gettransaction = "$_base$_api$_GetTransaction";
  static String getcoupontranction = "$_base$_api$_GetCouponTransaction";
  static String getproductredeemtranction =
      "$_base$_api$_GetProductTransaction";
  static String getcashbacktransaction = "$_base$_api$_GetCashBackTransaction";
  static String redeemproductlist = "$_base$_api$_GetProductList";
  static String redeemproductdetail = "$_base$_api$_GetProductDetail";
  static String newslist = "$_base$_api$_Newslist";
  static String newsdetail = "$_base$_api$_NewsDetaillist";
  static String getluckydrawlist = "$_base$_api$_Luckydrawpartcipants";
  static String getluckydrawlists = "$_base$_api$_LuckydrawpartcipantsList";
  static String getluckydrawinfo = "$_base$_api$_LuckydrawInfo";
  static String getluckydrawinfos = "$_base$_api$_LuckydrawInfos";
  static String updateluckydrawredeem = "$_base$_api$_UpdateLuckyDrawRedeem";
  static String purchaseproduct = "$_base$_api$_purchaseproduct";
  static String showpurchasedproduct = "$_base$_api$_showpurchasedproduct";
  static String buyluckydraw = "$_base$_api$_Buyluckydraw";
  static String getluckydrawwinner = "$_base$_api$_getluckydrawwinner";
  static String forgetpassword = "$_base$_api$_forgetpassword";
  static String getuserdata = "$_base$_api$_getuserdata";
  static String getcategory = "$_base$_api$_getcategory";
  static String getcategoryrandom = "$_base$_api$_getcategoryrandom";
  static String forgetPassword = "$_base$_api$_forgetPassword";
  static String changePassword = "$_base$_api$_changePassword";
  static String notification = "$_base$_api$_notification";
  static String getpointpackage = "$_base$_api$_getpointpackage";
  static String buypointpackage = "$_base$_api$_buypointpackage";
  static String banner = "$_base$_api$_banner";
  static String searchmerchant = "$_base$_api$_searchmerchant";
  static String luckydrawtnc = "$_base$_api$_luckydrawtnc";
  static String pointpackagetnc = "$_base$_api$_pointpackagetnc";
  static String topuptransactionlist = "$_base$_api$_topuptransactionlist";
  static String edituser = "$_base$_api$_editUser";
  static String showpurchasedproductdetail =
      "$_base$_api$_showpurchasedproductdetail";
  static String uploadimage = "$_base$_api$_uploadimage";
  static String getuserimage = "$_base$_api$_getuserimage";
  static String returnPointsHistory = "$_base$_api$_returnPointsHistory";
  static String fileDownloadUrl = "$_base$_api$_fileDownloadPath";
  static String accountDelete = "$_base$_api$_accountDelete";
}
