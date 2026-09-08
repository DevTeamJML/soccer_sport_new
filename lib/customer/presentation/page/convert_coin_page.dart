// import 'package:advance_notification/advance_notification.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:counter_button/counter_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ubuy/core/widgets/loading_widget.dart';
// import 'package:ubuy/customer/presentation/bloc/customer_bloc.dart';

// import '../../../core/constant/constants.dart';
// import '../../../injection_container.dart';

// class ConvertCoinPage extends StatefulWidget {
//   ConvertCoinPage({Key? key}) : super(key: key);

//   @override
//   State<ConvertCoinPage> createState() => _ConvertCoinPageState();
// }

// class _ConvertCoinPageState extends State<ConvertCoinPage> {
//   final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();
//   TextEditingController coinsController = TextEditingController();
//   TextEditingController diamondsController = TextEditingController();
//   int coinsBalance = 0;
//   int diamondsValue = 0;
//   @override
//   void initState() {
//     coinsBalance = int.parse(Constant.customer!.coins);

//     diamondsController.text = Constant.diamonds + '0';
//     coinsController.text = Constant.coins + Constant.customer!.coins;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Constant.color1,
//         // automaticallyImplyLeading: true,
//         title: Text(
//           'Convert diamonds',
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: BlocProvider(
//         create: (context) => _customerBloc,
//         child: BlocListener<CustomerBloc, CustomerState>(
//           listener: (context, state) {
//             if (state is DiamondsConverted) {
//               if (state.success) {
//                 _customerBloc
//                     .add(GetCustomerDetailsRequest(id: Constant.auth!.id));
//               }
//             }
//             if (state is CustomerDetailsLoaded) {
//               setState(() {
//                 Constant.customer = state.customer;
//                 Navigator.of(context).pop();
//               });
//             }
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: Column(
//               children: [
//                 Expanded(flex: 1, child: Container()),
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Column(
//                           children: [
//                             Text('Your current Coin balance'),
//                             Text(Constant.coins + Constant.customer!.coins)
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Stack(
//                                 alignment: AlignmentDirectional.centerEnd,
//                                 children: [
//                                   TextFormField(
//                                     readOnly: true,
//                                     validator: (value) =>
//                                         value!.isEmpty ? 'required' : null,
//                                     controller: diamondsController,
//                                     decoration: InputDecoration(
//                                       labelText: 'Amount of diamonds',
//                                       labelStyle: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold),
//                                       hintText: 'Amount of diamonds',
//                                       floatingLabelBehavior:
//                                           FloatingLabelBehavior.always,
//                                       border: OutlineInputBorder(),
//                                       focusedErrorBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.red, width: 1.0),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(),
//                                       ),
//                                       errorBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: Colors.red, width: 1.0),
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal:
//                                             MediaQuery.of(context).size.width *
//                                                 0.05),
//                                     child: FittedBox(
//                                         fit: BoxFit.fitHeight,
//                                         child: Row(
//                                           children: [
//                                             GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   if (diamondsValue > 0) {
//                                                     diamondsValue =
//                                                         diamondsValue - 1;
//                                                     diamondsController.text =
//                                                         Constant.diamonds +
//                                                             diamondsValue
//                                                                 .toString();
//                                                     coinsBalance =
//                                                         coinsBalance + 1000;
//                                                     coinsController.text =
//                                                         Constant.coins +
//                                                             coinsBalance
//                                                                 .toString();
//                                                   }
//                                                 });
//                                               },
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                         color: Colors.grey)),
//                                                 child: Icon(Icons.remove),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.05,
//                                             ),
//                                             GestureDetector(
//                                               onTap: () {
//                                                 int max = (coinsBalance / 1000)
//                                                             .round() >
//                                                         0
//                                                     ? (coinsBalance / 1000)
//                                                         .round()
//                                                     : 0;
//                                                 print(diamondsValue < max);
//                                                 if (max > 0) {
//                                                   if (diamondsValue < max) {
//                                                     setState(() {
//                                                       diamondsValue =
//                                                           diamondsValue + 1;
//                                                       diamondsController.text =
//                                                           Constant.diamonds +
//                                                               diamondsValue
//                                                                   .toString();
//                                                       coinsBalance =
//                                                           coinsBalance - 1000;
//                                                       coinsController.text =
//                                                           Constant.coins +
//                                                               coinsBalance
//                                                                   .toString();
//                                                     });
//                                                   }
//                                                 }
//                                               },
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                         color: Colors.grey)),
//                                                 child: Icon(Icons.add),
//                                               ),
//                                             ),
//                                           ],
//                                         )),
//                                   ),
//                                 ]),
//                             Text(
//                               'Exchange Rate : ' +
//                                   Constant.coins +
//                                   '1000 to ' +
//                                   Constant.diamonds +
//                                   '1',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                         TextFormField(
//                           validator: (value) =>
//                               value!.isEmpty ? 'required' : null,
//                           controller: coinsController,
//                           readOnly: true,
//                           style: TextStyle(color: Colors.grey),
//                           decoration: InputDecoration(
//                             labelText: 'Balance',
//                             labelStyle: TextStyle(
//                                 color: Colors.grey,
//                                 fontWeight: FontWeight.bold),
//                             floatingLabelBehavior: FloatingLabelBehavior.always,
//                             border: OutlineInputBorder(),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(
//                                   color: Colors.red, width: 1.0),
//                             ),
//                             enabledBorder: OutlineInputBorder(),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(
//                                   color: Colors.red, width: 1.0),
//                             ),
//                           ),
//                         ),
//                         BlocBuilder<CustomerBloc, CustomerState>(
//                           builder: (context, state) {
//                             if (state is ConvertingDiamonds ||
//                                 state is DiamondsConverted ||
//                                 state is LoadingCustomerDetails ||
//                                 state is CustomerDetailsLoaded) {
//                               return Container(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.06,
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.8,
//                                   decoration: BoxDecoration(
//                                     color: Constant.color1,
//                                   ),
//                                   child: LoadingWidget());
//                             } else {
//                               return GestureDetector(
//                                 onTap: diamondsValue > 0
//                                     ? () {
//                                         _customerBloc.add(
//                                             ConvertDiamondsRequest(
//                                                 value: diamondsValue));
//                                       }
//                                     : () {
//                                         AdvanceSnackBar(
//                                                 mode: Mode.ADVANCE,
//                                                 message: "Insufficient coins",
//                                                 bgColor: Colors.red)
//                                             .show(context);
//                                       },
//                                 child: Container(
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.06,
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.8,
//                                   decoration: BoxDecoration(
//                                     color: Constant.color1,
//                                   ),
//                                   child: Center(
//                                       child: AutoSizeText(
//                                     'Convert',
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                   )),
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                       ]),
//                 ),
//                 Expanded(flex: 1, child: Container()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
