import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_sport/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:soccer_sport/checkout/presentation/widget/order_listtile.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';

import '../../../core/constant/constants.dart';
import '../../../injection_container.dart';
import '../../domain/entities/order.dart';

class MyOrderPage extends StatefulWidget {
  MyOrderPage({Key? key}) : super(key: key);

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage>
    with SingleTickerProviderStateMixin {
  final CheckoutBloc _checkoutBloc = serviceLocator<CheckoutBloc>();
  List<OrderDetails> orders = [];
  List<OrderDetails> inProgressOrder = [];

  List<OrderDetails> completedOrder = [];

  late TabController _tabController;

  @override
  void initState() {
    if (Constant.auth != null) {
      _checkoutBloc.add(GetOrdersRequest(userID: Constant.auth!.id));
    }
    _tabController = new TabController(
      vsync: this,
      length: 2,
    );
    super.initState();
  }

  @override
  void dispose() {
    _checkoutBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),

        centerTitle: true,
        backgroundColor: Constant.color1,
        // automaticallyImplyLeading: true,
        title: Text(
          'My Orders',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(controller: _tabController, tabs: _tablist),
      ),
      body: BlocProvider(
        create: (context) => _checkoutBloc,
        child: BlocListener<CheckoutBloc, CheckoutState>(
          listener: (context, state) {
            if (state is OrdersGot) {
              setState(() {
                orders = state.orders;
                inProgressOrder = state.orders
                    .where((element) =>
                        element.status!.toLowerCase() == 'processing')
                    .toList();
                completedOrder = state.orders
                    .where((element) =>
                        element.status!.toLowerCase() == 'completed')
                    .toList();
              });
            }
          },
          child: TabBarView(controller: _tabController, children: [
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                if (state is OrdersGot) {
                  if (inProgressOrder.length > 0) {
                    return ListView.builder(
                      itemCount: inProgressOrder.length,
                      itemBuilder: ((context, index) {
                        return OrderListtile(order: inProgressOrder[index]);
                      }),
                    );
                  } else {
                    return Center(
                        child: Text('There is no order has been made so far',
                            style: TextStyle(color: Colors.white)));
                  }
                } else if (state is CheckoutError) {
                  return Center(
                      child: Text('Server exception',
                          style: TextStyle(color: Colors.white)));
                } else {
                  return LoadingWidget();
                }
              },
            ),
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                if (state is OrdersGot) {
                  if (completedOrder.length > 0) {
                    return ListView.builder(
                      itemCount: completedOrder.length,
                      itemBuilder: ((context, index) {
                        return OrderListtile(order: completedOrder[index]);
                      }),
                    );
                  } else {
                    return Center(
                        child: Text('There is no order has been made so far',
                            style: TextStyle(color: Colors.white)));
                  }
                } else if (state is CheckoutError) {
                  return Center(
                      child: Text('Server exception',
                          style: TextStyle(color: Colors.white)));
                } else {
                  return LoadingWidget();
                }
              },
            ),
          ]),
        ),
      ),
    );
  }

  List<Widget> _tablist = [
    Tab(
      icon: Text('In Progress'),
    ),
    Tab(
      icon: Text('Completed'),
    )
  ];
}
