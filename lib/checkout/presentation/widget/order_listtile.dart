import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/checkout/presentation/page/order_view_page.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/constant/constants.dart';
import '../../domain/entities/order.dart';

class OrderListtile extends StatelessWidget {
  final OrderDetails order;
  const OrderListtile({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderViewPage(
                    order: order,
                  )),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        color: Constant.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Card(
            color: Constant.backgroundColor,
            shadowColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.event_note_sharp,
                        color: Constant.color1,
                      ),
                      Text(' Order ID: #' + order.orderID!.toString()),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Image.network(order.lineItems[0].image!),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(children: [
                                AutoSizeText(
                                  order.lineItems[0].name!,
                                  maxFontSize: 28,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ]),
                            ),
                            Expanded(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AutoSizeText(
                                      'x ' +
                                          order.lineItems[0].quantity
                                              .toString(),
                                      maxFontSize: 28,
                                    ),
                                  ]),
                            ),
                            Expanded(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
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
                                          (order.lineItems[0].price
                                                          .toString() !=
                                                      ''
                                                  ? order.lineItems[0].price
                                                      .toString()
                                                  : (int.parse(order
                                                          .lineItems[0]
                                                          .total!) /
                                                      order.lineItems[0]
                                                          .quantity))
                                              .toString(),
                                      maxFontSize: 28,
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText((order.lineItems.map((e) => e.quantity).sum)
                              .toString() +
                          ' item'),
                      Row(
                        children: [
                          AutoSizeText('Total : '),
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
                          AutoSizeText(Constant.points +
                              (order.lineItems
                                      .map(
                                          (e) => double.parse(e.total!).round())
                                      .sum)
                                  .toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
