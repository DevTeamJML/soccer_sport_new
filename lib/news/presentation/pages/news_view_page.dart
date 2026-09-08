import 'dart:core';

import 'package:advance_notification/advance_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/presentation/bloc/news_bloc.dart';
import 'package:soccer_sport/news/presentation/widget/news_list_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/constant/analytics_service.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../injection_container.dart';

class NewsViewPage extends StatefulWidget {
  final News news;
  NewsViewPage({required this.news});

  @override
  _NewsViewPageState createState() => _NewsViewPageState();
}

class _NewsViewPageState extends State<NewsViewPage> {
  String test = '';
  List<String> seperatedText = [];
  final NewsBloc _newsBloc = serviceLocator<NewsBloc>();
  final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();
  AdvanceSnackBar? actest;
  String content = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _newsBloc.add(GetNewContentRequest(
        id: widget.news.id.toString(),
        userid: Constant.auth != null ? Constant.auth!.id : null));
    // seperatedText = widget.news.description!.split('\n');
    serviceLocator<AnalyticsService>().logScreens(
        name: '/newspage/' +
            (widget.news.title != null
                ? widget.news.title!
                : widget.news.id.toString()));

    // print(seperatedText.length);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _newsBloc.close();
    _customerBloc.close();
    // if(actest != null){
    //   actest.
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('News'),
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
        body: SingleChildScrollView(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NewsBloc>(
                create: (context) => _newsBloc,
              ),
              BlocProvider(
                create: (context) => _customerBloc,
              ),
            ],
            child: MultiBlocListener(
              listeners: [
                BlocListener<NewsBloc, NewsState>(
                  listener: (context, state) {
                    if (state is NewContentLoaded) {
                      setState(() {
                        seperatedText = state.id.content;
                        if (state.id.get_points) {
                          _customerBloc.add(
                              GetUserBalanceRequest(id: Constant.auth!.id));
                        }
                      });
                    }
                  },
                ),
                BlocListener<CustomerBloc, CustomerState>(
                  listener: (context, state) {
                    if (state is UserBalanceLoaded) {
                      if (Constant.customer != null &&
                          (state.success -
                                  int.parse(Constant.customer!.diamonds)) >
                              0) {
                        AdvanceSnackBar(
                                mode: Mode.ADVANCE,
                                message: "Received 1 point",
                                bgColor: Colors.green)
                            .show(context);
                        setState(() {
                          Constant.customer = Customer(
                            id: Constant.customer!.id,
                            firstName: Constant.customer!.firstName,
                            lastName: Constant.customer!.lastName,
                            billing: Constant.customer!.billing,
                            shipping: Constant.customer!.shipping,
                            diamonds: state.success.toString(),
                            coins: Constant.customer!.coins,
                          );
                        });
                      }
                    }
                  },
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: double.infinity,
                      child: Stack(children: [
                        // Container(
                        //   decoration:
                        //       BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                        // ),
                        Stack(children: [
                          FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: widget.news.image!,
                              imageErrorBuilder: (e, o, c) {
                                return Container(
                                  color: Colors.grey,
                                  child:
                                      Image.asset('assets/image-loading.jpg'),
                                );
                              }),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.only(left: 15),
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Image.asset('assets/news_logo.png'),
                            ),
                          ),
                        ]),
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.news.title!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Constant.color2),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text(
                        timeago.format(
                            DateTime.parse(widget.news.date!).toLocal()),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<NewsBloc, NewsState>(
                      builder: (context, state) {
                        if (state is LoadNewContent) {
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: LoadingWidget());
                        } else if (state is NewsError) {
                          return ErrorsWidget();
                        } else {
                          if (seperatedText.isNotEmpty) {
                            return Column(
                              children:
                                  seperatedText.map((e) => Text(e)).toList(),
                            );
                          } else {
                            return ErrorsWidget();
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
