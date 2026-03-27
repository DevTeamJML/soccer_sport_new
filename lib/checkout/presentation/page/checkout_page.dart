import 'dart:convert';
import 'dart:io';

import 'package:advance_notification/advance_notification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbols.dart';
import 'package:soccer_sport/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:soccer_sport/checkout/presentation/widget/address_textformfield.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';
import 'package:soccer_sport/products/presentation/bloc/product_bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;

import '../../../core/constant/constants.dart';
import '../../../customer/domain/entities/billing.dart';
import '../../../injection_container.dart';
import '../../../products/domain/entities/cart.dart';
import '../../../products/domain/entities/cart_item.dart';
import '../../../products/domain/entities/cart_product.dart';
import '../../domain/entities/order.dart';
import '../widget/checkout_list_tile.dart';
import '../widget/checkpoints_step.dart';
import 'package:collection/collection.dart';

import '../widget/leave_checkout_dialog.dart';

class CheckoutPage extends StatefulWidget {
  List<CartItem> selectedList;
  int ownedDiamonds;
  Coupon? coupon;
  int? discount_value;
  CheckoutPage(
      {required this.selectedList,
      required this.ownedDiamonds,
      this.coupon,
      this.discount_value});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int currentStep = 0;
  bool orderCompleted = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool useSavedAddress = true;
  final CheckoutBloc _checkoutBloc = serviceLocator<CheckoutBloc>();
  final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();
  final ProductBloc _productBloc = serviceLocator<ProductBloc>();
  final _formKey = GlobalKey<FormState>();
  int totalPayment = 0;
  int balance = 0;
  bool processingTransaction = true;

  Billing? address;
  OrderDetails? order;
  PageController _pageController = PageController();

  @override
  void initState() {
    totalPayment = (widget.selectedList.map((e) => e.lineTotal!).toList().sum) -
        (widget.discount_value != null ? widget.discount_value! : 0);
    balance = widget.ownedDiamonds - (totalPayment);
    if (Constant.customer!.billing != null) {
      fillControllerText();
    } else {
      useSavedAddress = false;
    }
    super.initState();
  }

  void fillControllerText() async {
    Billing address = Constant.customer!.billing!;
    Future<Map<String, dynamic>> formattedNumber = parse(address.phone)
        .then(
      (value) => value,
    )
        .catchError((e) {
      return Future.value({'error': 'testing'});
    });
    var number = await formattedNumber;

    if (number['error'] == null) {
      firstNameController.text = address.firstName;
      lastNameController.text = address.lastName;
      address1Controller.text = address.address1;
      address2Controller.text = address.address2;
      stateController.text = address.state;
      cityController.text = address.city;
      postcodeController.text = address.postcode;
      phoneController.text = number['national_number'];
    }
  }

  void clearControllerText() {
    firstNameController.clear();
    lastNameController.clear();
    address1Controller.clear();
    address2Controller.clear();
    stateController.clear();
    cityController.clear();
    postcodeController.clear();
    phoneController.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _checkoutBloc.close();
    _customerBloc.close();
    _productBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: currentStep != 2
              ? IconButton(
                  onPressed: currentStep == 2
                      ? () {}
                      : () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return LeaveCheckoutDialog();
                            },
                          );
                        },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                )
              : null,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Constant.color1,
          title: Text(
            'Checkout',
            style: TextStyle(color: Colors.white),
          ),
          actions: [],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          // child: StepIndicatorPageView(
          //   steps: 3,
          //   indicatorPosition: IndicatorPosition.top,
          //   labels: List<String>.generate(3, (index) => "Step ${index + 1}"),
          //   controller: _pageController,
          //   complete: () {
          //     //typically, you'd want to put logic that returns true when all the steps
          //     //are completed here
          //     return Future.value(true);
          //   },
          //   children: List<Widget>.generate(
          //     3,
          //     (index) => Container(
          //       color: Color(0xffffffff),
          //       child: Center(
          //         child: Text(
          //           "Page ${index + 1}",
          //           style: TextStyle(
          //             fontSize: 24,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          child: Theme(
            data: ThemeData(
              canvasColor: Constant.backgroundColor,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    // primary: Colors.green,
                    background: Colors.red,
                    secondary: Colors.red,
                    surface: Colors.red,
                    onSurface: Colors.grey,
                  ),
            ),
            child: Stepper(
                type: StepperType.horizontal,
                currentStep: currentStep,
                // onStepTapped: (step) => setState(() => currentStep = step),
                onStepCancel: currentStep > 0
                    ? () => setState(() => --currentStep)
                    : null,
                onStepContinue: () {
                  final lastStep = currentStep == getStep().length - 1;
                  if (currentStep == 0) {
                    if (_formKey.currentState!.validate()) {
                      address = Billing(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        address1: address1Controller.text,
                        address2: address2Controller.text,
                        state: stateController.text,
                        city: cityController.text,
                        postcode: postcodeController.text,
                        phone: phoneController.text,
                      );
                      setState(() {
                        ++currentStep;
                      });
                    }
                  } else if (currentStep == 1) {
                    setState(() {
                      ++currentStep;

                      List<CartProduct> lineItems = widget.selectedList
                          .map((e) => CartProduct(
                              productId: e.productId,
                              quantity: e.quantity!,
                              variationsID: e.variation_id))
                          .toList();
                      _checkoutBloc.add(
                          CheckLimitCheckoutRequest(line_items: lineItems));

                      // _customerBloc.add(
                      //     PurchaseRewardRequest(value: totalPayment, id: 2));
                      // Order
                    });
                  } else if (currentStep == 2) {
                    setState(() {
                      ++currentStep;

                      // Order
                    });
                  }
                },
                // steps: [
                //   for (var i = 0; i < 3; ++i)
                //     _buildStep(
                //       title: Text('Step ${i + 1}'),
                //       isActive: i == currentStep,
                //       state: i == currentStep
                //           ? StepState.editing
                //           : i < currentStep
                //               ? StepState.complete
                //               : StepState.indexed,
                //     ),
                //   _buildStep(
                //     title: Text('Error'),
                //     state: StepState.error,
                //   ),
                //   _buildStep(
                //     title: Text('Disabled'),
                //     state: StepState.disabled,
                //   )
                // ],

                steps: getStep(),
                controlsBuilder: (context, controlDetails) {
                  return Container(
                    color: Constant.backgroundColor,
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: double.infinity,
                    child: currentStep == 1
                        ? Row(children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: controlDetails.onStepCancel,
                                child: Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Constant.color1,
                                  ),
                                  child: Center(
                                      child: AutoSizeText(
                                    'Back',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ),
                            if (balance >= 0)
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                            if (balance >= 0)
                              Expanded(
                                child: GestureDetector(
                                  onTap: controlDetails.onStepContinue,
                                  child: Container(
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Constant.color1,
                                    ),
                                    child: Center(
                                        child: AutoSizeText(
                                      'Place order',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                              ),
                          ])
                        : currentStep == 2
                            ? BlocBuilder<CheckoutBloc, CheckoutState>(
                                bloc: _checkoutBloc,
                                builder: (context, state) {
                                  if (processingTransaction) {
                                    if (state is OrderCreated) {
                                      return Row(children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.popUntil(
                                                  context,
                                                  ModalRoute.withName(
                                                      '/homepage'));

                                              Constant.pageController!
                                                  .jumpToPage(0);
                                            },
                                            child: Container(
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Constant.color1,
                                              ),
                                              child: Center(
                                                  child: AutoSizeText(
                                                'Back to homepage',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        ),
                                      ]);
                                    } else if (state is CheckoutError) {
                                      return Row(children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.popUntil(
                                                  context,
                                                  ModalRoute.withName(
                                                      '/homepage'));

                                              Constant.pageController!
                                                  .jumpToPage(0);
                                            },
                                            child: Container(
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Constant.color1,
                                              ),
                                              child: Center(
                                                  child: AutoSizeText(
                                                'Back to homepage',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        ),
                                      ]);
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    return Row(children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.popUntil(
                                                context,
                                                ModalRoute.withName(
                                                    '/homepage'));

                                            Constant.pageController!
                                                .jumpToPage(0);
                                          },
                                          child: Container(
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Constant.color1,
                                            ),
                                            child: Center(
                                                child: AutoSizeText(
                                              'Back to homepage',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ]);
                                  }
                                },
                              )
                            : Row(children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: controlDetails.onStepContinue,
                                    child: Container(
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Constant.color1,
                                      ),
                                      child: Center(
                                          child: AutoSizeText(
                                        'Next',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                ),
                              ]),
                  );
                }),
          ),
        ),
      ),
    );
  }

  List<Step> getStep() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: Text(
              'Address',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Use saved address'),
                                Checkbox(
                                  side: BorderSide(color: Colors.white),
                                  value: useSavedAddress,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        if (Constant.customer!.billing !=
                                            null) {
                                          fillControllerText();
                                          useSavedAddress = true;
                                        }
                                      } else {
                                        useSavedAddress = false;
                                        clearControllerText();
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Row(
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 1,
                                child: AddressTextFormField(
                                  title: 'First Name',
                                  textEditingController: firstNameController,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 1,
                                child: AddressTextFormField(
                                  title: 'Last Name',
                                  textEditingController: lastNameController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          AddressTextFormField(
                            title: 'Address 1',
                            textEditingController: address1Controller,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          AddressTextFormField(
                            title: 'Address 2',
                            textEditingController: address2Controller,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          Row(
                            children: [
                              // Flexible(
                              //   fit: FlexFit.loose,
                              //   flex: 1,
                              //   child: AddressTextFormField(
                              //     title: 'Country',
                              //     textEditingController: countryController,
                              //   ),
                              // ),
                              // SizedBox(
                              //   width: MediaQuery.of(context).size.width * 0.03,
                              // ),
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 1,
                                child: AddressTextFormField(
                                  title: 'State',
                                  textEditingController: stateController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          Row(
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 1,
                                child: AddressTextFormField(
                                  title: 'City',
                                  textEditingController: cityController,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                flex: 1,
                                child: AddressTextFormField(
                                  title: 'Postcode',
                                  textEditingController: postcodeController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          IntlPhoneField(
                            style: TextStyle(color: Colors.white),
                            controller: phoneController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            disableLengthCheck: true,
                            validator: (phone) async {
                              if (phone != null) {
                                Future<Map<String, dynamic>> formattedNumber =
                                    parse(phone.completeNumber)
                                        .then(
                                  (value) => value,
                                )
                                        .catchError((e) {
                                  return Future.value({'error': 'testing'});
                                });
                                var number = await formattedNumber;
                                if (number['error'] == null) {
                                  return null;
                                } else {
                                  return 'invalid number';
                                }
                              } else {
                                return 'Required';
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              hintText: 'Phone',
                              hintStyle: TextStyle(color: Colors.white),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                              ),
                            ),
                            initialCountryCode: 'MY',
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: Text('Payment', style: TextStyle(color: Colors.white)),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Column(
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
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                          color: Colors.grey[400]!,
                        )),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: double.infinity,
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.location_on, color: Constant.color1),
                      ),
                      if (address != null)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(address!.firstName +
                                ' ' +
                                address!.lastName +
                                ' | ' +
                                address!.phone),
                            Text(address!.address1),
                            Text(address!.address2),
                            Text(address!.city +
                                ', ' +
                                address!.state +
                                ', ' +
                                address!.postcode)
                          ],
                        )
                    ]),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: ListView.builder(
                      itemCount: widget.selectedList.length,
                      itemBuilder: ((context, index) {
                        return CheckoutListile(
                          cartItem: widget.selectedList[index],
                        );
                      }),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border:
                            Border(top: BorderSide(color: Colors.grey[400]!))),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Owned : '),
                          Row(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image:
                                        'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                    imageErrorBuilder: (e, o, c) {
                                      return Container();
                                    }),
                              ),
                              Text(widget.ownedDiamonds.toString())
                            ],
                          ),
                        ],
                      ),
                      if (widget.coupon != null &&
                          widget.discount_value != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount: '),
                            Row(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image:
                                          'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                      imageErrorBuilder: (e, o, c) {
                                        return Container();
                                      }),
                                ),
                                Text(widget.discount_value.toString())
                              ],
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Payment : '),
                          Row(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image:
                                        'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                    imageErrorBuilder: (e, o, c) {
                                      return Container();
                                    }),
                              ),
                              Text(totalPayment.toString())
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      if (balance > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Balance : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image:
                                          'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                      imageErrorBuilder: (e, o, c) {
                                        return Container();
                                      }),
                                ),
                                Text((balance).toString())
                              ],
                            ),
                          ],
                        ),
                      if (balance < 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Insufficient diamonds',
                                style: TextStyle(color: Colors.red))
                          ],
                        )
                    ]),
                  )
                ],
              ),
            )),
        Step(
            state: orderCompleted ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            title: Text('Order', style: TextStyle(color: Colors.white)),
            content: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => _checkoutBloc,
                ),
                BlocProvider(
                  create: (context) => _customerBloc,
                ),
                BlocProvider(
                  create: (context) => _productBloc,
                ),
              ],
              child: MultiBlocListener(
                listeners: [
                  BlocListener<CustomerBloc, CustomerState>(
                    bloc: _customerBloc,
                    listener: (context, state) {
                      if (state is CustomerDetailsLoaded) {
                        setState(() {
                          Constant.customer = state.customer;
                        });
                      }
                      if (state is RewardPurchased) {
                        if (state.reference.success) {
                          List<CartProduct> lineItems = widget.selectedList
                              .map((e) => CartProduct(
                                  productId: e.productId,
                                  quantity: e.quantity!,
                                  variationsID: e.variation_id))
                              .toList();
                          OrderDetails order = OrderDetails(
                            customerID: Constant.auth!.id,
                            paymentMethod: 'mycred_default',
                            setPaid: true,
                            transactionID: state.reference.ref_id,
                            lineItems: lineItems,
                            orderID: null,
                            orderNumber: null,
                            status: null,
                            orderDate: null,
                            shipping: address!,
                            coupon: widget.coupon != null
                                ? [
                                    Coupon(
                                        code: widget.coupon!.code,
                                        amount: widget.coupon!.amount,
                                        type: widget.coupon!.type,
                                        individual_use:
                                            widget.coupon!.individual_use,
                                        email_restrictions:
                                            widget.coupon!.email_restrictions,
                                        product_ids: widget.coupon!.product_ids,
                                        used_by: widget.coupon!.used_by,
                                        usage_limit: widget.coupon!.usage_limit,
                                        limit_usage_to_x_items: widget
                                            .coupon!.limit_usage_to_x_items,
                                        usage_limit_per_user:
                                            widget.coupon!.usage_limit_per_user)
                                  ]
                                : null,
                          );

                          _checkoutBloc.add(CreateOrderRequest(order: order));
                          List<CartItem> cartItems =
                              List<CartItem>.from(Constant.cartItems);
                          cartItems.removeWhere((element) =>
                              widget.selectedList.firstWhereOrNull((selected) =>
                                  selected.productId == element.productId &&
                                  (selected.variation_id != null &&
                                      element.variation_id != null &&
                                      (selected.variation_id ==
                                          element.variation_id))) !=
                              null);

                          _productBloc.add(AddToCartRequest(
                              cart: Cart(
                                  userId: Constant.auth!.id,
                                  products: cartItems
                                      .map((e) => CartProduct(
                                            productId: e.productId,
                                            quantity: e.quantity!,
                                            variationsID: e.variation_id,
                                          ))
                                      .toList())));
                        } else {
                          setState(() {
                            processingTransaction = false;
                          });
                        }
                      }
                    },
                  ),
                  BlocListener<CheckoutBloc, CheckoutState>(
                    bloc: _checkoutBloc,
                    listener: (context, state) async {
                      if (state is OrderCreated) {
                        if (state.created) {
                          _customerBloc.add(
                              GetCustomerDetailsRequest(id: Constant.auth!.id));
                        } else {}
                      }

                      if (state is LimitCheckoutChecked) {
                        if (state.success) {
                          _customerBloc.add(PurchaseRewardRequest(
                              value: totalPayment, id: 2));
                        } else {
                          setState(() {
                            processingTransaction = false;
                          });
                          AdvanceSnackBar(
                                  mode: Mode.ADVANCE,
                                  message: "Reached the purchase limit",
                                  bgColor: Colors.red)
                              .show(context);
                        }
                      }
                    },
                  ),
                  BlocListener<ProductBloc, ProductState>(
                    bloc: _productBloc,
                    listener: (context, state) {
                      if (state is CartItemsLoaded) {
                        setState(() {
                          Constant.cartItems = state.products;
                        });
                      }
                    },
                  ),
                ],
                child: BlocBuilder<CheckoutBloc, CheckoutState>(
                  bloc: _checkoutBloc,
                  builder: (context, state) {
                    if (processingTransaction) {
                      if (state is OrderCreated) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.25,
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Icon(
                                                    FontAwesomeIcons
                                                        .clipboardCheck,
                                                    color: Colors.green))),
                                        Expanded(
                                            flex: 1,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: AutoSizeText(
                                                'Order created',
                                                // maxFontSize: 20,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (state is CheckoutError) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.25,
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Icon(Icons.error,
                                                    color: Colors.red))),
                                        Expanded(
                                            flex: 1,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: AutoSizeText(
                                                'Order create failed',
                                                // maxFontSize: 20,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return LoadingWidget();
                      }
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.25,
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Icon(Icons.error,
                                                  color: Colors.red))),
                                      Expanded(
                                          flex: 1,
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: AutoSizeText(
                                              'Transaction failed',
                                              // maxFontSize: 20,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            )),
      ];
}
