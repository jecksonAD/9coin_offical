import 'package:flutter/material.dart';
import 'package:ninecoin/assets/assets.dart';

import '../ui/active_coupon_details.dart';

class DiscountCouponCard extends StatefulWidget {
  final String imageUrl;
  final String maxredeemper;
  final String title;
  final String originalpoint;
  final String promopoint;
  final String period;
  final dynamic data;
  final String page;
  final Function()? onTap;
  const DiscountCouponCard(
      {Key? key,
      required this.imageUrl,
      required this.maxredeemper,
      required this.title,
      required this.originalpoint,
      required this.promopoint,
      required this.period,
      required this.data,
      required this.page,
      this.onTap})
      : super(key: key);

  @override
  State<DiscountCouponCard> createState() => _DiscountCouponCardState();
}

class _DiscountCouponCardState extends State<DiscountCouponCard> {
  late double font1;
  late double font2;
  late double font3;
  late double font4;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double rate = 100 -
        double.parse(widget.promopoint) /
            double.parse(widget.originalpoint) *
            100;
    font1 = size.width * 0.042;
    font2 = size.width * 0.021;
    font3 = size.width * 0.023;
    font4 = size.width * 0.036;
    return InkWell(
      onTap: widget.onTap,
      child: Stack(children: [
        Row(
          children: [
            Container(
              height: size.height * 0.15,
              width: size.width * 0.55,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                      image: NetworkImage(widget.imageUrl), fit: BoxFit.cover),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )),
            ),
            Container(
              height: size.height * 0.15,
              width: size.width * 0.35,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: (BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: font1,
                            color: Color(0xff70bea4),
                            fontWeight: FontWeight.bold),
                      ),*/
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          const Text(
                            'RM:',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xff70bea4),
                            ),
                          ),
                          Text(
                            widget.promopoint,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff70bea4),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'RM: ' + widget.originalpoint,
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.red,
                          fontSize: 15,
                          color: Color(0xff70bea4),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 30),
                        child: Container(
                          width: 80,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff70bea4),
                            ),
                            onPressed: () {
                              widget.onTap!();
                              /* Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ActiveCouponDetails(
                                        widget.data!['id'],
                                      )));
                              print(widget.data);*/
                            },
                            child: Text(
                              widget.page,
                              style: TextStyle(
                                  fontSize: font1 * 0.85,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /*  Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'SAVE',
                              style: TextStyle(
                                  fontSize: font3,
                                  color: Color(0xff70bea4),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                          ),
                          Text(
                            '20%',
                            style: TextStyle(
                              fontSize: font4,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff70bea4),
                            ),
                          ),*/
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
        /* Positioned(
            left: size.width * 0.525,
            child: Container(
              height: 11,
              width: 20,
              decoration: const BoxDecoration(
                  color: Color(0xff2c2c2c),
                  borderRadius: (BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ))),
            )),
        Positioned(
            left: size.width * 0.525,
            top: size.height * 0.14,
            child: Container(
              height: 12,
              width: 20,
              decoration: const BoxDecoration(
                  color: Color(0xff2c2c2c),
                  borderRadius: (BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ))),
            )),
        Positioned(
            bottom: 8,
            child: Container(
              height: 30,
              width: 130,
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Limited ' + widget.maxredeemper + ' Only',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text(
                      widget.period,
                      style: TextStyle(fontSize: font2, color: Colors.white),
                    ),
                  ],
                ),
              ),
            )),*/
      ]),
    );
  }
}


// class MyClipper extends CustomClipper<Path>{
//   @override
//   Path getClip(Size size) {
//      var path =  new Path();
//      path.lineTo(0, size.height);
//           path.lineTo(size.width, size.height);

//      path.close();
//      return new Path();
//        }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;




// }