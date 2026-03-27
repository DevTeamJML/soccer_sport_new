import 'package:flutter/material.dart';
import 'package:soccer_sport/checkout/presentation/page/checkout_base.dart';
import 'package:soccer_sport/core/constant/constants.dart';

import '../../../customer/domain/entities/billing.dart';
import '../../../products/domain/entities/cart_item.dart';

class VerifyAddress extends CheckoutPage {
  final List<CartItem> selectedList;
  VerifyAddress({required this.selectedList});

  @override
  _VerifyAddressState createState() => _VerifyAddressState();
}

class _VerifyAddressState extends CheckoutPageState<VerifyAddress> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    currentPage = 0;
    super.initState();
  }

  @override
  Widget pageUI() {
    return _formUI();
  }

  Widget _formUI() {
    return SingleChildScrollView(
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    children: [
                      Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'required' : null,
                            controller: firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              hintText: 'First Name',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                              ),
                            ),
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'required' : null,
                            controller: lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              hintText: 'Last Name',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    validator: (value) => value!.isEmpty ? 'required' : null,
                    controller: address1Controller,
                    decoration: InputDecoration(
                      labelText: 'Address 1',
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      hintText: 'Address 1',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    validator: (value) => value!.isEmpty ? 'required' : null,
                    controller: address2Controller,
                    decoration: InputDecoration(
                      labelText: 'Address 2',
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      hintText: 'Address 2',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    children: [
                      Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'required' : null,
                            controller: countryController,
                            decoration: InputDecoration(
                              labelText: 'Country',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              hintText: 'Country',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                              ),
                            ),
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'required' : null,
                            controller: stateController,
                            decoration: InputDecoration(
                              labelText: 'State',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              hintText: 'State',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                              ),
                            ),
                          )),
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
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'required' : null,
                            controller: cityController,
                            decoration: InputDecoration(
                              labelText: 'City',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              hintText: 'City',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 1.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.0),
                              ),
                            ),
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'required' : null,
                          controller: postcodeController,
                          decoration: InputDecoration(
                            labelText: 'Postcode',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            hintText: 'Postcode',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    validator: (value) => value!.isEmpty ? 'required' : null,
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      hintText: 'Phone number',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => PaymentPage(
                        //         selectedList: widget.selectedList,
                        //         shipping: Billing(
                        //             firstName: firstNameController.text,
                        //             lastName: lastNameController.text,
                        //             address1: address1Controller.text,
                        //             address2: address2Controller.text,
                        //             state: stateController.text,
                        //             city: cityController.text,
                        //             postcode: postcodeController.text,
                        //             phone: phoneController.text,
                        //            ),
                        //       ),
                        //     ));
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: Constant.color1,
                      ),
                      child: Center(
                          child: Text('Next',
                              style: TextStyle(color: Colors.white))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
