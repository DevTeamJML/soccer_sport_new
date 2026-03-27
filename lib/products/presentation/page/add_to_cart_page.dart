import 'dart:io';

import 'package:advance_notification/advance_notification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:counter_button/counter_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/authentication/presentation/widget/login_loading_dialog.dart';
import 'package:soccer_sport/checkout/domain/entities/order.dart';
import 'package:soccer_sport/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';
import 'package:ticket_material/ticket_material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../checkout/presentation/page/checkout_page.dart';
import '../../../core/constant/constants.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../injection_container.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_product.dart';
import '../bloc/product_bloc.dart';
import '../widget/add_to_cart_list_tile.dart';
import 'package:collection/collection.dart';

class AddToCartPage extends StatefulWidget {
  AddToCartPage({Key? key}) : super(key: key);

  @override
  State<AddToCartPage> createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  // final http.Client client;
  final _formKey = GlobalKey<FormState>();

  final ProductBloc _productBloc = serviceLocator<ProductBloc>();
  // final CheckoutBloc _checkoutBloc = serviceLocator<CheckoutBloc>();

  List<CartItem> cartItems = [];
  List<CartItem> selectedList = [];
  List<OrderDetails> orders = [];

  final _couponController = TextEditingController();
  Coupon? coupon;
  bool couponValid = false;
  int? discountValue;
  bool notApplyingCoupon = true;
  void initState() {
    // TODO: implement initState
    // BlocProvider.of<AuthenticationBloc>(context)
    //                                 .add(LoggedOut());
    // _productBloc.add(GetCartItemsRequest(userId: 2));
    _productBloc.add(GetCartItemsRequest(userId: Constant.auth!.id));
    super.initState();
  }

  @override
  void dispose() {
    _productBloc.close();
    super.dispose();
  }

  void testing(List<CartItem> items) {
    setState(() {
      cartItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text('Cart'),
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<ProductBloc>(
              create: (context) => _productBloc,
            ),
            // BlocProvider(
            //   create: (context) => _checkoutBloc,
            // ),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is CartItemsLoaded) {
                    setState(() {
                      cartItems = state.products;
                      Constant.cartItems = cartItems;
                      // _checkoutBloc.add(GetOrdersRequest(userID: Constant.auth!.id));
                    });
                  }

                  if (state is CartAdded) {
                    setState(() {
                      cartItems = state.products;
                      Constant.cartItems = state.products;
                    });
                  }

                  if (state is CouponApplied) {
                    setState(() {
                      Navigator.of(context).pop();

                      if (state.coupon.amount != "0" &&
                          selectedList
                                  .where((element) =>
                                      element.productId ==
                                      state.coupon.product_ids![0])
                                  .toList()
                                  .length >
                              0 &&
                          (state.coupon.used_by!.length <
                              state.coupon.usage_limit!)) {
                        couponValid = true;

                        coupon = state.coupon;
                        discountValue = (int.parse(selectedList
                                    .where((element) =>
                                        element.productId ==
                                        coupon!.product_ids![0])
                                    .map((e) => e.price!)
                                    .max) *
                                (int.parse(coupon!.amount!) / 100))
                            .round();
                      } else {
                        if (state.coupon.amount == "0") {
                          AdvanceSnackBar(
                                  mode: Mode.ADVANCE,
                                  message: "Voucher invalid",
                                  bgColor: Colors.red)
                              .show(context);
                        } else if (state.coupon.used_by!.length >=
                            state.coupon.usage_limit!) {
                          AdvanceSnackBar(
                                  mode: Mode.ADVANCE,
                                  message: "Voucher has used before",
                                  bgColor: Colors.red)
                              .show(context);
                        } else {
                          AdvanceSnackBar(
                                  mode: Mode.ADVANCE,
                                  message: "Voucher didn't met the requirement",
                                  bgColor: Colors.red)
                              .show(context);
                        }
                      }
                    });
                  }
                },
              ),
              //   BlocListener<CheckoutBloc, CheckoutState>(
              //     listener: (context, state) {
              //      if (state is OrdersGot) {
              //   setState(() {
              //     orders = state.orders;
              //       order
              //   });
              // }
              //     },
              //   ),
            ],
            child: cartItems.length > 0
                ? SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.9 -
                          (MediaQuery.of(context).padding.bottom +
                              MediaQuery.of(context).padding.top +
                              MediaQuery.of(context).viewInsets.bottom +
                              MediaQuery.of(context).viewInsets.top),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: cartItems.length,
                                itemBuilder: (context, index) {
                                  CartItem cartItem = cartItems[index];
                                  String cartAttributes = '';
                                  if (cartItem.cartAttributes != null) {
                                    cartAttributes = (cartItem
                                                    .cartAttributes!.size !=
                                                null
                                            ? cartItem.cartAttributes!.size! +
                                                ' '
                                            : '') +
                                        (cartItem.cartAttributes!.color != null
                                            ? cartItem.cartAttributes!.color! +
                                                ' '
                                            : '') +
                                        (cartItem.cartAttributes!.option != null
                                            ? cartItem.cartAttributes!.option! +
                                                ' '
                                            : '');
                                  }
                                  return Container(
                                    key: Key(cartItem.productId.toString()),
                                    padding: EdgeInsets.all(8),
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: double.infinity,
                                    child: Card(
                                      color: Constant.backgroundColor,
                                      shadowColor: Colors.white,
                                      child: Row(children: [
                                        Checkbox(
                                          side: BorderSide(color: Colors.white),
                                          value:
                                              selectedList.contains(cartItem),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value!) {
                                                selectedList.add(cartItem);
                                              } else {
                                                selectedList.remove(cartItem);
                                              }
                                            });
                                          },
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: Image.network(
                                                cartItem.thumbnail!)),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.only(
                                                top: 8, left: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  child: AutoSizeText(
                                                    cartItem.productName! +
                                                        ' ' +
                                                        cartAttributes,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.03,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      child: FadeInImage
                                                          .memoryNetwork(
                                                              placeholder:
                                                                  kTransparentImage,
                                                              image:
                                                                  'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                                              imageErrorBuilder:
                                                                  (e, o, c) {
                                                                return Container();
                                                              }),
                                                    ),
                                                    AutoSizeText(
                                                      (cartItem.price != null
                                                          ? cartItem.price!
                                                          : (cartItem.lineTotal! /
                                                                  cartItem
                                                                      .quantity!)
                                                              .round()
                                                              .toString()),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(right: 8),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: CounterButton(
                                              // progressColor: Colors.white,
                                              countColor: Colors.white,
                                              buttonColor: Colors.white,
                                              loading: false,
                                              onChange: (value) {
                                                if (value > 0) {
                                                  setState(() {
                                                    cartItems[cartItems.indexOf(
                                                            cartItem)] =
                                                        CartItem.changeQuantity(
                                                            cartItem, value);

                                                    selectedList = [];
                                                    _productBloc.add(
                                                      AddToCartRequest(
                                                        cart: Cart(
                                                          userId:
                                                              Constant.auth!.id,
                                                          products: cartItems
                                                              .map((e) => CartProduct(
                                                                  productId: e
                                                                      .productId,
                                                                  quantity: e
                                                                      .quantity!,
                                                                  variationsID:
                                                                      e.variation_id))
                                                              .toList(),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                } else {
                                                  setState(() {
                                                    final removedList =
                                                        List<CartItem>.from(
                                                            cartItems);
                                                    removedList.remove(
                                                        cartItems[index]);
                                                    cartItems = removedList;
                                                    selectedList = [];
                                                    _productBloc.add(
                                                      AddToCartRequest(
                                                        cart: Cart(
                                                          userId:
                                                              Constant.auth!.id,
                                                          products: cartItems
                                                              .map((e) => CartProduct(
                                                                  productId: e
                                                                      .productId,
                                                                  quantity: e
                                                                      .quantity!,
                                                                  variationsID:
                                                                      e.variation_id))
                                                              .toList(),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                }
                                                // if (value >= 0) {
                                                //   setState(() {
                                                //     _counterValue = value;
                                                //   });
                                                // }
                                              },
                                              count: cartItem.quantity!,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  );
                                }),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: Column(
                              children: [
                                // Expanded(
                                //   child: Text('testing '),
                                // ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0, 0),
                                              blurRadius: 3)
                                        ]),
                                    child: Column(
                                      children: [
                                        if (couponValid)
                                          Expanded(
                                            child: Form(
                                              key: _formKey,
                                              child: Container(
                                                color: Constant.backgroundColor,
                                                child: Row(children: [
                                                  Expanded(
                                                      flex: 2,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    TicketMaterial(
                                                                  height: 40,
                                                                  colorBackground:
                                                                      Constant
                                                                          .color1,
                                                                  leftChild:
                                                                      Center(
                                                                          child:
                                                                              Text(
                                                                    coupon !=
                                                                            null
                                                                        ? coupon!
                                                                            .code
                                                                        : 'sdfsfdsfdsfd',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )),
                                                                  rightChild:
                                                                      Center(
                                                                    child: Text(
                                                                      coupon !=
                                                                              null
                                                                          ? coupon!.amount.toString() +
                                                                              " %"
                                                                          : "5 %",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w900,
                                                                          // decoration: TextDecoration
                                                                          //     .lineThrough,
                                                                          decorationThickness: 2.8,
                                                                          foreground: Paint()
                                                                            ..shader = LinearGradient(
                                                                              colors: <Color>[
                                                                                Color(0xff9d7600),
                                                                                Color(0xffffeb3b)
                                                                                //add more color here.
                                                                              ],
                                                                            ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.025),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      couponValid =
                                                                          false;
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    child: Center(
                                                                        child: AutoSizeText(
                                                                      'Remove',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    )),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ))),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              // AutoSizeText('- ',
                                                              //     style: TextStyle(
                                                              //         color: Colors.white)),
                                                              Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.03,
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            5),
                                                                child: FadeInImage
                                                                    .memoryNetwork(
                                                                        placeholder:
                                                                            kTransparentImage,
                                                                        image:
                                                                            'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                                                        imageErrorBuilder: (e,
                                                                            o,
                                                                            c) {
                                                                          return Container();
                                                                        }),
                                                              ),
                                                              AutoSizeText(
                                                                  (int.parse(selectedList.where((element) => element.productId == coupon!.product_ids![0]).map((e) => e.price!).max) *
                                                                          (int.parse(coupon!.amount!) /
                                                                              100))
                                                                      .round()
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white))
                                                            ]),
                                                      ))
                                                ]),
                                              ),
                                            ),
                                          ),
                                        if (!couponValid)
                                          Expanded(
                                            child: Form(
                                              key: _formKey,
                                              autovalidateMode:
                                                  AutovalidateMode.disabled,
                                              child: Container(
                                                color: Constant.backgroundColor,
                                                child: Row(children: [
                                                  Expanded(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8),
                                                        child: TextFormField(
                                                          controller:
                                                              _couponController,
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .disabled,
                                                          onChanged: (e) {
                                                            setState(() {
                                                              notApplyingCoupon =
                                                                  true;
                                                            });
                                                          },
                                                          validator: (value) =>
                                                              notApplyingCoupon
                                                                  ? null
                                                                  : (selectedList
                                                                              .length <=
                                                                          0
                                                                      ? "Select one product to apply coupon"
                                                                      : value!.isEmpty
                                                                          ? "Can't be empty"
                                                                          : null),
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Enter Coupon Code',
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey[700]),
                                                            // hintTextDirection: TextDirection,
                                                            // hintStyle:,
                                                            errorStyle:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .red),

                                                            isDense: true,

                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    left: 5,
                                                                    top: 10.0),
                                                            border:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    gapPadding:
                                                                        0),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      color: Colors
                                                                          .red,
                                                                      width:
                                                                          1.0),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .white)),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Constant
                                                                      .color2,
                                                                  width: 1.0),
                                                            ),
                                                            errorBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .red,
                                                                        width:
                                                                            1.0),
                                                                gapPadding: 0),
                                                          ),
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 0,
                                                          horizontal: 8.0),
                                                      child:
                                                          //  TextButton(
                                                          //     onPressed: () {},
                                                          //     style: TextButton.styleFrom(
                                                          //         padding:
                                                          //             EdgeInsets
                                                          //                 .zero,
                                                          //         tapTargetSize:
                                                          //             MaterialTapTargetSize
                                                          //                 .shrinkWrap,
                                                          //         minimumSize:
                                                          //             Size(0, 0)),
                                                          //     child:
                                                          //         Text('Login')),
                                                          GestureDetector(
                                                        onTap: () {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return LoginLoadingDialog();
                                                              },
                                                            );
                                                            _productBloc.add(
                                                                ApplyCouponRequest(
                                                                    code: _couponController
                                                                        .text));
                                                          }
                                                          {
                                                            setState(() {
                                                              notApplyingCoupon =
                                                                  false;
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              color: _formKey.currentState !=
                                                                          null &&
                                                                      _formKey
                                                                          .currentState!
                                                                          .validate()
                                                                  ? Constant
                                                                      .color2
                                                                  : Colors.grey,
                                                            ),
                                                            child: Text(
                                                                "Apply Coupon",
                                                                style: TextStyle(
                                                                    color: _formKey.currentState !=
                                                                                null &&
                                                                            _formKey.currentState!
                                                                                .validate()
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .white))),
                                                      )

                                                      // ElevatedButton(
                                                      //     style:
                                                      //         ElevatedButton
                                                      //             .styleFrom(
                                                      //       tapTargetSize:
                                                      //           MaterialTapTargetSize
                                                      //               .shrinkWrap,
                                                      //       onSurface:
                                                      //           Colors.grey,

                                                      //       primary: Constant
                                                      //           .color2,
                                                      //       //onPrimary: Colors.black,
                                                      //       shadowColor:
                                                      //           Colors.white,
                                                      //     ),
                                                      //     onPressed: () {
                                                      //       if (_formKey
                                                      //           .currentState!
                                                      //           .validate()) {
                                                      //         showDialog(
                                                      //           context:
                                                      //               context,
                                                      //           barrierDismissible:
                                                      //               false,
                                                      //           builder:
                                                      //               (BuildContext
                                                      //                   context) {
                                                      //             return LoginLoadingDialog();
                                                      //           },
                                                      //         );
                                                      //         _productBloc.add(
                                                      //             ApplyCouponRequest(
                                                      //                 code: _couponController
                                                      //                     .text));
                                                      //       }
                                                      //     },
                                                      //     child: AutoSizeText(
                                                      //       "Apply Coupon",
                                                      //       maxLines: 1,
                                                      //       style: TextStyle(
                                                      //           color: Colors
                                                      //               .black),
                                                      //     )),
                                                      )
                                                ]),
                                              ),
                                            ),
                                          ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                          color: Constant.backgroundColor,
                                          child: Row(children: [
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    side: BorderSide(
                                                        color: Colors.white),
                                                    value: cartItems.length ==
                                                        selectedList.length,
                                                    onChanged: (value) {
                                                      if (value!) {
                                                        setState(() {
                                                          selectedList = List<
                                                                  CartItem>.from(
                                                              cartItems);
                                                        });
                                                      } else {
                                                        setState(() {
                                                          selectedList = [];
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  AutoSizeText('All',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  Expanded(
                                                      child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          AutoSizeText('Total ',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.03,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            child: FadeInImage
                                                                .memoryNetwork(
                                                                    placeholder:
                                                                        kTransparentImage,
                                                                    image:
                                                                        'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                                                    imageErrorBuilder:
                                                                        (e, o,
                                                                            c) {
                                                                      return Container();
                                                                    }),
                                                          ),
                                                          AutoSizeText(
                                                              couponValid
                                                                  ? '${selectedList.map((e) => e.lineTotal!).toList().sum - discountValue!}'
                                                                  : '${selectedList.map((e) => e.lineTotal!).toList().sum}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))
                                                        ]),
                                                  ))
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: selectedList.length > 0
                                                    ? () {
                                                        Constant.selectedCartList =
                                                            selectedList;
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              CheckoutPage(
                                                            selectedList:
                                                                selectedList,
                                                            ownedDiamonds: int
                                                                .parse(Constant
                                                                    .customer!
                                                                    .diamonds),
                                                            coupon: coupon,
                                                            discount_value:
                                                                discountValue,
                                                          ),
                                                        ));
                                                      }
                                                    : null,
                                                child: Container(
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        selectedList.length > 0
                                                            ? Constant.color1
                                                            : Colors.grey,
                                                  ),
                                                  child: Center(
                                                      child: AutoSizeText(
                                                    'Check Out',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                                ),
                                              ),
                                            )
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    child:
                        Center(child: Text('No product has added in cart yet')),
                  ),
          ),
          // bottomNavigationBar: Container(
          //   height: MediaQuery.of(context).size.height * 0.17,
          //   child: Column(
          //     children: [
          //       // Expanded(
          //       //   child: Text('testing '),
          //       // ),
          //       Expanded(
          //         child: Container(
          //           decoration: BoxDecoration(color: Colors.white, boxShadow: [
          //             BoxShadow(
          //                 color: Colors.grey, offset: Offset(0, 0), blurRadius: 3)
          //           ]),
          //           child: Column(
          //             children: [
          //               if (couponValid)
          //                 Expanded(
          //                   child: Form(
          //                     key: _formKey,
          //                     child: Container(
          //                       color: Constant.backgroundColor,
          //                       child: Row(children: [
          //                         Expanded(
          //                             flex: 2,
          //                             child: Padding(
          //                                 padding: const EdgeInsets.symmetric(
          //                                     horizontal: 8),
          //                                 child: Row(
          //                                   children: [
          //                                     Expanded(
          //                                       child: TicketMaterial(
          //                                         height: 40,
          //                                         colorBackground: Constant.color1,
          //                                         leftChild: Center(
          //                                             child: Text(
          //                                           coupon != null
          //                                               ? coupon!.code
          //                                               : 'sdfsfdsfdsfd',
          //                                           style: TextStyle(
          //                                               fontWeight:
          //                                                   FontWeight.bold),
          //                                         )),
          //                                         rightChild: Center(
          //                                           child: Text(
          //                                             coupon != null
          //                                                 ? coupon!.amount
          //                                                         .toString() +
          //                                                     " %"
          //                                                 : "5 %",
          //                                             style: TextStyle(
          //                                                 fontWeight:
          //                                                     FontWeight.w900,
          //                                                 // decoration: TextDecoration
          //                                                 //     .lineThrough,
          //                                                 decorationThickness: 2.8,
          //                                                 foreground: Paint()
          //                                                   ..shader =
          //                                                       LinearGradient(
          //                                                     colors: <Color>[
          //                                                       Color(0xff9d7600),
          //                                                       Color(0xffffeb3b)
          //                                                       //add more color here.
          //                                                     ],
          //                                                   ).createShader(
          //                                                           Rect.fromLTWH(
          //                                                               0.0,
          //                                                               0.0,
          //                                                               200.0,
          //                                                               100.0))),
          //                                           ),
          //                                         ),
          //                                       ),
          //                                     ),
          //                                     Padding(
          //                                       padding: EdgeInsets.symmetric(
          //                                           horizontal: 10,
          //                                           vertical: MediaQuery.of(context)
          //                                                   .size
          //                                                   .height *
          //                                               0.025),
          //                                       child: GestureDetector(
          //                                         onTap: () {
          //                                           setState(() {
          //                                             couponValid = false;
          //                                           });
          //                                         },
          //                                         child: Container(
          //                                           child: Center(
          //                                               child: AutoSizeText(
          //                                             'Remove',
          //                                             style: TextStyle(
          //                                                 color: Colors.red),
          //                                           )),
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   ],
          //                                 ))),
          //                         Expanded(
          //                             flex: 1,
          //                             child: Padding(
          //                               padding: const EdgeInsets.symmetric(
          //                                   horizontal: 8.0),
          //                               child: Row(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.end,
          //                                   children: [
          //                                     // AutoSizeText('- ',
          //                                     //     style: TextStyle(
          //                                     //         color: Colors.white)),
          //                                     Icon(
          //                                       Icons.remove,
          //                                       color: Colors.white,
          //                                     ),
          //                                     Container(
          //                                       height: MediaQuery.of(context)
          //                                               .size
          //                                               .height *
          //                                           0.03,
          //                                       margin: EdgeInsets.symmetric(
          //                                           horizontal: 5),
          //                                       child: FadeInImage.memoryNetwork(
          //                                           placeholder: kTransparentImage,
          //                                           image:
          //                                               'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
          //                                           imageErrorBuilder: (e, o, c) {
          //                                             return Container();
          //                                           }),
          //                                     ),
          //                                     AutoSizeText(
          //                                         (int.parse(selectedList
          //                                                     .where((element) =>
          //                                                         element
          //                                                             .productId ==
          //                                                         coupon!.product_ids![
          //                                                             0])
          //                                                     .map((e) => e.price)
          //                                                     .max) *
          //                                                 (int.parse(
          //                                                         coupon!.amount!) /
          //                                                     100))
          //                                             .round()
          //                                             .toString(),
          //                                         style: TextStyle(
          //                                             color: Colors.white))
          //                                   ]),
          //                             ))
          //                       ]),
          //                     ),
          //                   ),
          //                 ),
          //               if (!couponValid)
          //                 Expanded(
          //                   child: Form(
          //                     key: _formKey,
          //                     child: Container(
          //                       color: Constant.backgroundColor,
          //                       child: Row(children: [
          //                         Expanded(
          //                             flex: 2,
          //                             child: Padding(
          //                               padding: const EdgeInsets.symmetric(
          //                                   horizontal: 8),
          //                               child: TextFormField(
          //                                 controller: _couponController,
          //                                 validator: (value) => value!.isEmpty
          //                                     ? "Can't be empty"
          //                                     : selectedList.length <= 0
          //                                         ? "Select one product to apply coupon"
          //                                         : null,
          //                                 decoration: InputDecoration(
          //                                   hintText: 'Enter Coupon Code',
          //                                   hintStyle:
          //                                       TextStyle(color: Colors.grey[700]),
          //                                   // hintTextDirection: TextDirection,
          //                                   // hintStyle:,
          //                                   errorStyle:
          //                                       TextStyle(color: Colors.red),

          //                                   isDense: true,

          //                                   contentPadding:
          //                                       EdgeInsets.only(left: 5, top: 10.0),
          //                                   border: OutlineInputBorder(
          //                                       borderSide: BorderSide(
          //                                         color: Colors.white,
          //                                       ),
          //                                       gapPadding: 0),
          //                                   focusedErrorBorder: OutlineInputBorder(
          //                                     borderSide: const BorderSide(
          //                                         color: Colors.red, width: 1.0),
          //                                   ),
          //                                   enabledBorder: OutlineInputBorder(
          //                                       borderSide: BorderSide(
          //                                           color: Colors.white)),
          //                                   focusedBorder: OutlineInputBorder(
          //                                     borderSide: BorderSide(
          //                                         color: Constant.color2,
          //                                         width: 1.0),
          //                                   ),
          //                                   errorBorder: OutlineInputBorder(
          //                                       borderSide: const BorderSide(
          //                                           color: Colors.red, width: 1.0),
          //                                       gapPadding: 0),
          //                                 ),
          //                               ),
          //                             )),
          //                         Expanded(
          //                             flex: 1,
          //                             child: Padding(
          //                               padding: const EdgeInsets.symmetric(
          //                                   horizontal: 8.0),
          //                               child: ElevatedButton(
          //                                   style: ElevatedButton.styleFrom(
          //                                     onSurface: Colors.grey,

          //                                     primary: Constant.color2,
          //                                     //onPrimary: Colors.black,
          //                                     shadowColor: Colors.white,
          //                                   ),
          //                                   onPressed: () {
          //                                     if (_formKey.currentState!
          //                                         .validate()) {
          //                                       showDialog(
          //                                         context: context,
          //                                         barrierDismissible: false,
          //                                         builder: (BuildContext context) {
          //                                           return LoginLoadingDialog();
          //                                         },
          //                                       );
          //                                       _productBloc.add(ApplyCouponRequest(
          //                                           code: _couponController.text));
          //                                     }
          //                                   },
          //                                   child: AutoSizeText(
          //                                     "Apply Coupon",
          //                                     maxLines: 1,
          //                                     style: TextStyle(color: Colors.black),
          //                                   )),
          //                             ))
          //                       ]),
          //                     ),
          //                   ),
          //                 ),
          //               Container(
          //                 height: MediaQuery.of(context).size.height * 0.05,
          //                 color: Constant.backgroundColor,
          //                 child: Row(children: [
          //                   Expanded(
          //                     flex: 2,
          //                     child: Row(
          //                       children: [
          //                         Checkbox(
          //                           side: BorderSide(color: Colors.white),
          //                           value: cartItems.length == selectedList.length,
          //                           onChanged: (value) {
          //                             if (value!) {
          //                               setState(() {
          //                                 selectedList =
          //                                     List<CartItem>.from(cartItems);
          //                                 print(selectedList
          //                                     .map((e) => e.lineTotal)
          //                                     .toList()
          //                                     .sum
          //                                     .toString());
          //                               });
          //                             } else {
          //                               setState(() {
          //                                 selectedList = [];
          //                               });
          //                             }
          //                           },
          //                         ),
          //                         AutoSizeText('All',
          //                             style: TextStyle(color: Colors.white)),
          //                         Expanded(
          //                             child: Padding(
          //                           padding: EdgeInsets.only(right: 10),
          //                           child: Row(
          //                               mainAxisAlignment: MainAxisAlignment.end,
          //                               children: [
          //                                 AutoSizeText('Total ',
          //                                     style:
          //                                         TextStyle(color: Colors.white)),
          //                                 Container(
          //                                   height:
          //                                       MediaQuery.of(context).size.height *
          //                                           0.03,
          //                                   margin:
          //                                       EdgeInsets.symmetric(horizontal: 5),
          //                                   child: FadeInImage.memoryNetwork(
          //                                       placeholder: kTransparentImage,
          //                                       image:
          //                                           'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
          //                                       imageErrorBuilder: (e, o, c) {
          //                                         return Container();
          //                                       }),
          //                                 ),
          //                                 AutoSizeText(
          //                                     couponValid
          //                                         ? '${selectedList.map((e) => e.lineTotal).toList().sum - discountValue!}'
          //                                         : '${selectedList.map((e) => e.lineTotal).toList().sum}',
          //                                     style: TextStyle(color: Colors.white))
          //                               ]),
          //                         ))
          //                       ],
          //                     ),
          //                   ),
          //                   Expanded(
          //                     flex: 1,
          //                     child: GestureDetector(
          //                       onTap: selectedList.length > 0
          //                           ? () {
          //                               Constant.selectedCartList = selectedList;
          //                               Navigator.of(context)
          //                                   .push(MaterialPageRoute(
          //                                 builder: (context) => CheckoutPage(
          //                                   selectedList: selectedList,
          //                                   ownedDiamonds: int.parse(
          //                                       Constant.customer!.diamonds),
          //                                   coupon: coupon,
          //                                   discount_value: discountValue,
          //                                 ),
          //                               ));
          //                             }
          //                           : null,
          //                       child: Container(
          //                         height: double.infinity,
          //                         decoration: BoxDecoration(
          //                           color: selectedList.length > 0
          //                               ? Constant.color1
          //                               : Colors.grey,
          //                         ),
          //                         child: Center(
          //                             child: AutoSizeText(
          //                           'Check Out',
          //                           style: TextStyle(color: Colors.white),
          //                         )),
          //                       ),
          //                     ),
          //                   )
          //                 ]),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       Container(
          //         height: MediaQuery.of(context).padding.bottom,
          //       )
          //     ],
          //   ),
          // ),
        ));
  }
}
