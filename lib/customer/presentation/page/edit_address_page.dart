import 'package:advance_notification/advance_notification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/customer/presentation/widget/edit_address_loading.dart';

import '../../../injection_container.dart';
import '../../domain/entities/billing.dart';
import '../../domain/entities/shipping.dart';

class EditAddressPage extends StatefulWidget {
  EditAddressPage({Key? key}) : super(key: key);

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();
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
  Country _selectedDialogCountry = Country(
    name: "Malaysia",
    flag: "🇲🇾",
    code: "MY",
    dialCode: "60",
    nameTranslations: {
      "en": "Malaysia",
    },
    minLength: 11,
    maxLength: 11,
  );
  String _phone = '';
  @override
  void initState() {
    fillControllerText();
    super.initState();
  }

  Future<void> fillControllerText() async {
    if (Constant.customer!.shipping != null) {
      Billing address = Constant.customer!.billing!;
      Future<Map<String, dynamic>> formattedNumber = parse(address.phone)
          .then(
        (value) => value,
      )
          .catchError((e) {
        return Future.value({'error': 'testing'});
      });
      var number = await formattedNumber;
      firstNameController.text = address.firstName;
      lastNameController.text = address.lastName;
      address1Controller.text = address.address1;
      address2Controller.text = address.address2;
      stateController.text = address.state;
      cityController.text = address.city;
      postcodeController.text = address.postcode;
      // phoneController.text = address.phone;
      if (number['errro'] == null) {
        phoneController.text = number['national_number'];
        _phone = number['e164'];
      }
    }
  }

  @override
  void dispose() {
    _customerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Constant.color1,
          // automaticallyImplyLeading: true,
          title: Text(
            'Edit Address',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocProvider(
          create: (context) => _customerBloc,
          child: BlocListener<CustomerBloc, CustomerState>(
            listener: (context, state) {
              if (state is EditingAddress) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return EditAddressLoading();
                  },
                );
              }
              if (state is AddressEdited) {
                // if (state.customer ) {
                //   _customerBloc
                //       .add(GetCustomerDetailsRequest(id: Constant.auth!.id));
                // }
                setState(() {
                  Constant.customer = state.customer;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();

                  AdvanceSnackBar(
                          mode: Mode.ADVANCE,
                          message: "Address Updated",
                          bgColor: Colors.green)
                      .show(context);
                });
              }
            },
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                  style: TextStyle(color: Colors.white),
                                  validator: (value) =>
                                      value!.isEmpty ? 'required' : null,
                                  controller: firstNameController,
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    hintText: 'First Name',
                                    hintStyle: TextStyle(color: Colors.white),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
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
                                  style: TextStyle(color: Colors.white),
                                  validator: (value) =>
                                      value!.isEmpty ? 'required' : null,
                                  controller: lastNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    hintText: 'Last Name',
                                    hintStyle: TextStyle(color: Colors.white),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
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
                          style: TextStyle(color: Colors.white),
                          validator: (value) =>
                              value!.isEmpty ? 'required' : null,
                          controller: address1Controller,
                          decoration: InputDecoration(
                            labelText: 'Address 1',
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            hintText: 'Address 1',
                            hintStyle: TextStyle(color: Colors.white),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (value) =>
                              value!.isEmpty ? 'required' : null,
                          controller: address2Controller,
                          decoration: InputDecoration(
                            labelText: 'Address 2',
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            hintText: 'Address 2',
                            hintStyle: TextStyle(color: Colors.white),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Row(
                          children: [
                            // Flexible(
                            //     fit: FlexFit.loose,
                            //     flex: 1,
                            //     child: TextFormField(
                            //       validator: (value) =>
                            //           value!.isEmpty ? 'required' : null,
                            //       controller: countryController,
                            //       decoration: InputDecoration(
                            //         labelText: 'Country',
                            //         labelStyle: TextStyle(
                            //             color: Colors.black,
                            //             fontWeight: FontWeight.bold),
                            //         hintText: 'Country',
                            //         floatingLabelBehavior:
                            //             FloatingLabelBehavior.always,
                            //         border: OutlineInputBorder(),
                            //         focusedErrorBorder: OutlineInputBorder(
                            //           borderSide: const BorderSide(
                            //               color: Colors.red, width: 1.0),
                            //         ),
                            //         enabledBorder: OutlineInputBorder(),
                            //         focusedBorder: OutlineInputBorder(
                            //           borderSide: const BorderSide(
                            //               color: Colors.blue, width: 1.0),
                            //         ),
                            //         errorBorder: OutlineInputBorder(
                            //           borderSide: const BorderSide(
                            //               color: Colors.red, width: 1.0),
                            //         ),
                            //       ),
                            //     )),
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width * 0.03,
                            // ),
                            Flexible(
                                fit: FlexFit.loose,
                                flex: 1,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  validator: (value) =>
                                      value!.isEmpty ? 'required' : null,
                                  controller: stateController,
                                  decoration: InputDecoration(
                                    labelText: 'State',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    hintText: 'State',
                                    hintStyle: TextStyle(color: Colors.white),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
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
                                  style: TextStyle(color: Colors.white),
                                  validator: (value) =>
                                      value!.isEmpty ? 'required' : null,
                                  controller: cityController,
                                  decoration: InputDecoration(
                                    labelText: 'City',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    hintText: 'City',
                                    hintStyle: TextStyle(color: Colors.white),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
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
                                style: TextStyle(color: Colors.white),
                                validator: (value) =>
                                    value!.isEmpty ? 'required' : null,
                                controller: postcodeController,
                                decoration: InputDecoration(
                                  labelText: 'Postcode',
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  hintText: 'Postcode',
                                  hintStyle: TextStyle(color: Colors.white),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
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
                        Theme(
                          data: ThemeData(
                            iconTheme: IconThemeData(color: Colors.white),
                            colorScheme: Theme.of(context).colorScheme.copyWith(
                                  // primary: Colors.green,
                                  background: Colors.red,
                                  secondary: Colors.red,
                                  surface: Colors.red,
                                  onSurface: Colors.grey,
                                  tertiary: Colors.white,
                                  inverseSurface: Colors.white,
                                ),
                          ),
                          child: IntlPhoneField(
                            dropdownIcon: Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            controller: phoneController,
                            pickerDialogStyle: PickerDialogStyle(
                              countryNameStyle: TextStyle(color: Colors.black),
                              // searchFieldInputDecoration: InputDecoration
                            ),
                            dropdownTextStyle: TextStyle(color: Colors.white),
                            style: TextStyle(color: Colors.white),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onCountryChanged: (c) {
                              setState(() {
                                _selectedDialogCountry = c;
                              });
                            },
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
                                  setState(() {
                                    _phone = number['e164'];
                                  });
                                  return null;
                                } else {
                                  return 'invalid number';
                                }
                              } else {
                                return 'Required';
                              }
                            },
                            onChanged: (v) {
                              setState(() {
                                _phone = v.completeNumber;
                              });
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
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              Shipping shipping = Shipping(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  address1: address1Controller.text,
                                  address2: address2Controller.text,
                                  city: cityController.text,
                                  state: stateController.text,
                                  postcode: postcodeController.text,
                                  phone: _phone);
                              _customerBloc
                                  .add(EditAddressRequest(shipping: shipping));
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Constant.color1,
                            ),
                            child: Center(
                                child: Text('Save',
                                    style: TextStyle(color: Colors.white))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
