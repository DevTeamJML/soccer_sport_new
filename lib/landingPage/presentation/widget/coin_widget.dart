// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
// import 'package:soccer_sport/injection_container.dart';
// import 'package:transparent_image/transparent_image.dart';

// class CoinWidget extends StatefulWidget {
//   final bool claimed;
//   final String days;
//   final bool claimable;
//   const CoinWidget(
//       {required this.claimed, required this.days, required this.claimable});

//   @override
//   State<CoinWidget> createState() => _CoinWidgetState();
// }

// class _CoinWidgetState extends State<CoinWidget> {
//   final CustomerBloc customerBloc = serviceLocator<CustomerBloc>();
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => customerBloc,
//       child: BlocListener<CustomerBloc, CustomerState>(
//         listener: (context, state) {
//           // TODO: implement listener
//         },
//         child: 
//       ),
//     );
//   }
// }
