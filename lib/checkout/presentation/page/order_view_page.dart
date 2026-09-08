import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:soccer_sport/checkout/domain/entities/order.dart';
import 'package:soccer_sport/checkout/presentation/widget/order_view_listtile.dart';
import 'package:soccer_sport/products/domain/entities/cart_product.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/constant/constants.dart';
import '../../../customer/domain/entities/billing.dart';

class OrderViewPage extends StatefulWidget {
  final OrderDetails order;

  OrderViewPage({required this.order});

  @override
  State<OrderViewPage> createState() => _OrderViewPageState();
}

class _OrderViewPageState extends State<OrderViewPage> {
  late OrderDetails order;
  late Billing shipping;
  late List<CartProduct> items;
  String statusLine1 = '';
  String statusLine2 = '';
  String orderDate = '';
  String orderComplete = '';
  @override
  void initState() {
    order = widget.order;
    shipping = order.shipping;
    items = order.lineItems;
    orderDate = DateFormat('yyyy-MM-dd HH:mm').format(order.orderDate!);
    if (order.orderComplete != null)
      orderComplete =
          DateFormat('yyyy-MM-dd HH:mm').format(order.orderComplete!);
    statusLine1 = order.status == 'processing'
        ? 'Order still in progress'
        : 'Order completed';
    statusLine2 = order.status == 'processing'
        ? 'It will takes a few days to ship your order'
        : 'Order has been delivered';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Constant.color1,
        // automaticallyImplyLeading: true,
        title: Text(
          'Orders Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: Color.fromARGB(255, 12, 149, 67),
            padding: EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            statusLine1,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          AutoSizeText(
                            statusLine2,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                ),
                if (order.status == 'processing')
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Icon(
                          Icons.timelapse,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (order.status == 'completed')
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Icon(
                          FontAwesomeIcons.clipboardCheck,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.location_on, color: Constant.color1),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shipping Address',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Text(shipping.firstName +
                      ' ' +
                      shipping.lastName +
                      ' | ' +
                      shipping.phone),
                  Text(shipping.address1),
                  Text(shipping.address2),
                  Text(shipping.city +
                      ', ' +
                      shipping.state +
                      ', ' +
                      shipping.postcode)
                ],
              ),
            ]),
          ),
          Card(
            elevation: 2,
            color: Constant.backgroundColor,
            shadowColor: Colors.white,

            // color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(children: [
                Column(
                  children: items
                      .map((e) => OrderViewListtile(
                            item: e,
                          ))
                      .toList(),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText((items.map((e) => e.quantity).sum).toString() +
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
                            (items
                                    .map((e) => double.parse(e.total!).round())
                                    .sum)
                                .toString()),
                      ],
                    )
                  ],
                ),
              ]),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order ID: '),
                    Text('#' + order.orderID.toString()),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Order date: '), Text(orderDate)],
                ),
                if (order.status == 'completed')
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                if (order.status == 'completed')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Order complete: '), Text(orderComplete)],
                  ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
