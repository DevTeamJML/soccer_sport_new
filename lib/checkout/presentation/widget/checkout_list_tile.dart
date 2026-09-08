import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../products/domain/entities/cart_item.dart';

class CheckoutListile extends StatelessWidget {
  final CartItem cartItem;
  const CheckoutListile({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    String cartAttributes = '';
    if (cartItem.cartAttributes != null) {
      cartAttributes = (cartItem.cartAttributes!.size != null
              ? cartItem.cartAttributes!.size! + ' '
              : '') +
          (cartItem.cartAttributes!.color != null
              ? cartItem.cartAttributes!.color! + ' '
              : '') +
          (cartItem.cartAttributes!.option != null
              ? cartItem.cartAttributes!.option! + ' '
              : '');
    }
    return Container(
      key: Key(cartItem.productId.toString()),
      padding: EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height * 0.15,
      width: double.infinity,
      child: Card(
        color: Constant.backgroundColor,
        shadowColor: Colors.white,
        child: Row(children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.2,
              child: Image.network(cartItem.thumbnail!)),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(top: 8, left: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(cartItem.productName! + ' ' + cartAttributes,
                      style: TextStyle(color: Colors.white)),
                  Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.03,
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image:
                                'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                            imageErrorBuilder: (e, o, c) {
                              return Container();
                            }),
                      ),
                      AutoSizeText(
                          (cartItem.price != null
                              ? cartItem.price!
                              : (cartItem.lineTotal! / cartItem.quantity!)
                                  .toString()),
                          style: TextStyle(color: Colors.white)),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.only(right: 8),
              child: Text(' X ' + cartItem.quantity.toString(),
                  style: TextStyle(color: Colors.white))),
        ]),
      ),
    );
  }
}
