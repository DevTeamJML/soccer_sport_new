import 'package:auto_size_text/auto_size_text.dart';
import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/cart_item.dart';

class AddToCartListTile extends StatefulWidget {
  final CartItem cartItem;
  final Function(bool?) checkBoxFunction;
  final Function(int) counterFunction;
  final bool checked;
  AddToCartListTile(
      {required this.cartItem,
      required this.checkBoxFunction,
      required this.counterFunction,
      required this.checked});

  @override
  State<AddToCartListTile> createState() => _AddToCartListTileState();
}

class _AddToCartListTileState extends State<AddToCartListTile> {
  late CartItem cartItem;
  late int _counterValue;

  @override
  void initState() {
    cartItem = widget.cartItem;
    _counterValue = widget.cartItem.quantity!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(widget.cartItem.productId.toString()),
      padding: EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height * 0.15,
      width: double.infinity,
      child: Card(
        child: Row(children: [
          Checkbox(value: widget.checked, onChanged: widget.checkBoxFunction),
          Image.network(cartItem.thumbnail!),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(top: 8, left: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(children: [
                    AutoSizeText(
                      cartItem.productName!,
                    ),
                  ]),
                  Row(
                    children: [
                      AutoSizeText('💎 ' + cartItem.productRegularPrice!),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 8),
            width: MediaQuery.of(context).size.width * 0.18,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: CounterButton(
                loading: false,
                onChange: (value) {
                  widget.counterFunction(value);
                  if (value >= 0) {
                    setState(() {
                      _counterValue = value;
                    });
                  }
                },
                count: _counterValue,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
