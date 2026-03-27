import 'package:flutter/material.dart';
import 'package:soccer_sport/checkout/presentation/page/checkout_base.dart';
import 'package:soccer_sport/checkout/presentation/widget/checkout_list_tile.dart';
import 'package:soccer_sport/core/constant/constants.dart';

import '../../../customer/domain/entities/shipping.dart';
import '../../../products/domain/entities/cart_item.dart';

class PaymentPage extends CheckoutPage {
  final List<CartItem> selectedList;
  final Shipping shipping;
  PaymentPage({required this.selectedList, required this.shipping});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends CheckoutPageState<PaymentPage> {
  late Shipping shipping;
  void initState() {
    this.currentPage = 1;
    shipping = widget.shipping;
    super.initState();
  }

  @override
  Widget pageUI() {
    return Column(
      children: [
        Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Shipping Address',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ]),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                    color: Colors.grey[400]!,
                  ),
                  bottom: BorderSide(
                    color: Colors.grey[400]!,
                  ))),
          height: MediaQuery.of(context).size.height * 0.1,
          width: double.infinity,
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.location_on, color: Constant.color1),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
            )
          ]),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView.builder(
            itemCount: widget.selectedList.length,
            itemBuilder: ((context, index) {
              return CheckoutListile(
                cartItem: widget.selectedList[index],
              );
            }),
          ),
        )
      ],
    );
  }
}
