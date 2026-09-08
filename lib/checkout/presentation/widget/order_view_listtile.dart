import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/products/domain/entities/cart_product.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/constant/constants.dart';
import '../../domain/entities/order.dart';

class OrderViewListtile extends StatelessWidget {
  final CartProduct item;
  const OrderViewListtile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Constant.backgroundColor,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
      width: double.infinity,
      padding: EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height * 0.15,
      child: Row(
        children: [
          Image.network(item.image!),
          Expanded(
            child: Column(
              children: [
                Expanded(
                    child: Container(
                  width: double.infinity,
                  child: AutoSizeText(
                    item.name!,
                    maxFontSize: 28,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    AutoSizeText(
                      'x ' + item.quantity.toString(),
                      maxFontSize: 28,
                    ),
                  ]),
                ),
                Expanded(
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image:
                              'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                          imageErrorBuilder: (e, o, c) {
                            return Container();
                          }),
                    ),
                    AutoSizeText(
                      Constant.points +
                          (item.price.toString() != '0'
                              ? item.price.toString()
                              : (int.parse(item.total!) / item.quantity)
                                  .toString()),
                      maxFontSize: 28,
                    ),
                  ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
