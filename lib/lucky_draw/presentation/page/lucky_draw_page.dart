import 'dart:async';
import 'dart:math';

import 'package:advance_notification/advance_notification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soccer_sport/authentication/presentation/widget/login_loading_dialog.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_info.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_prize.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/prize.dart';
import 'package:soccer_sport/lucky_draw/presentation/bloc/lucky_draw_bloc.dart';
import 'package:soccer_sport/lucky_draw/presentation/widget/lucky_draw_dialog.dart';
import 'package:soccer_sport/lucky_draw/presentation/widget/lucky_draw_history_dialog.dart';
import 'package:soccer_sport/lucky_draw/presentation/widget/lucky_draw_item.dart';
import 'package:soccer_sport/products/presentation/bloc/product_bloc.dart';
import 'package:soccer_sport/products/presentation/page/product_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';

import '../../../injection_container.dart';

class LuckyDrawPage extends StatefulWidget {
  @override
  State<LuckyDrawPage> createState() => _LuckyDrawPageState();
}

class _LuckyDrawPageState extends State<LuckyDrawPage> {
  bool isDrawing = false;
  int selectedIndex = 0;
  List<int> array_index = [0, 1, 2, 3, 7, 11, 10, 9, 8, 4];
  List<int>? draw_prizes;
  LuckyDrawInfo? luckyDraw;
  final LuckyDrawBloc _luckyDrawBloc = serviceLocator<LuckyDrawBloc>();
  final ProductBloc _productBloc = serviceLocator<ProductBloc>();
  final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();

  Map<String, dynamic> coupons = {};
  List<Prize> prizes = [
    Prize(
        img:
            'https://soccersport.club/wp-content/uploads/2022/18/lucky_draw/grand.png',
        index: 0,
        name: 'Grand Prizes'),
    Prize(
        img:
            'https://soccersport.club/wp-content/uploads/2022/18/soccer_coin.png',
        index: 1,
        name: 'Coins x20',
        stack: 'x 20'),
    Prize(
        img:
            'https://soccersport.club/wp-content/uploads/2022/18/soccer_coin.png',
        index: 2,
        name: 'Coins x50',
        stack: 'x 50'),
    Prize(
        img:
            'https://soccersport.club/wp-content/uploads/2022/18/lucky_draw/10.png',
        index: 3,
        name: 'P6 Reload Bonus 10%'),
    Prize(
        img:
            'https://soccersport.club/wp-content/uploads/2022/18/lucky_draw/shoe.png',
        index: 7,
        name: 'Nike Phantom 5% voucher'),
    Prize(
        img:
            'https://soccersport.club/wp-content/uploads/2022/18/soccer_coin.png',
        index: 11,
        name: 'Coins x150',
        stack: 'x 150'),
    Prize(
        img:
            'https://soccersport.club/wp-content/uploads/2022/18/lucky_draw/15.png',
        index: 10,
        name: 'P6 Reload Bonus 15%'),
    Prize(
        img:
            'https://soccersport.club/wp-content/uploads/2022/18/lucky_draw/cloth.png',
        index: 9,
        name: 'Argetina T Shirt 5% voucher'),
    Prize(
        img:
            'https://soccersport.club/wp-content/uploads/2022/18/lucky_draw/20.png',
        index: 8,
        name: 'P6 Reload Bonus 20%'),
    Prize(
        img:
            'https://soccersport.club/wp-content/uploads/2022/18/lucky_draw/leg.png',
        index: 4,
        name: 'Leg Support 5% voucher'),
  ];
  @override
  void initState() {
    _luckyDrawBloc.add(RetrieveLuckyDrawRequest(id: Constant.auth!.id));

    _luckyDrawBloc.add(RetrieveCouponsRequest());
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoginLoadingDialog();
        },
      );
    });
    // _luckyDrawBloc.add(PersistCouponsRequest(coupons: {}));

    super.initState();
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
        title: Text("Lucky Draw"),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductPage()),
              );
            },
            child: Container(

                // padding: EdgeInsets.all(5),
                child: Padding(
              padding: const EdgeInsets.only(
                  right: 20.0, top: 5, bottom: 5, left: 2),
              child: Icon(
                FontAwesomeIcons.shoppingCart,
              ),
            )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => _luckyDrawBloc,
            ),
            BlocProvider(
              create: (context) => _productBloc,
            ),
            BlocProvider(
              create: (context) => _customerBloc,
            ),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<CustomerBloc, CustomerState>(
                  listener: ((context, state) {
                if (state is CustomerDetailsLoaded) {
                  setState(() {
                    Constant.customer = state.customer;
                    Navigator.of(context).pop();
                    luckyDrawAnimation();

                    // i think is terbalik laio sohia
                  });
                }
              })),
              BlocListener<LuckyDrawBloc, LuckyDrawState>(
                listener: (context, state) {
                  if (state is LuckyDrawInfoGet) {
                    setState(() {
                      Navigator.of(context).pop();

                      luckyDraw = state.lucky_draw;
                    });
                  }

                  if (state is LuckyDrawed) {
                    setState(() {
                      luckyDraw = state.lucky_draw;
                      _customerBloc.add(
                          GetCustomerDetailsRequest(id: Constant.auth!.id));
                    });
                  }

                  if (state is CouponsGet) {
                    setState(() {
                      coupons = state.coupons;
                    });
                  }

                  if (state is CouponPersisted) {
                    _luckyDrawBloc.add(LuckyDrawRequest(luckyDraw: luckyDraw!));
                  }

                  if (state is LuckyDrawNotEnugCoin) {
                    Navigator.of(context).pop();

                    AdvanceSnackBar(
                            mode: Mode.ADVANCE,
                            message: "Insufficient amount coin",
                            bgColor: Constant.color1)
                        .show(context);
                  }

                  if (state is LuckyDrawError) {
                    setState(() {
                      Navigator.of(context).pop();

                      isDrawing = false;
                    });
                  }
                },
              ),
              BlocListener<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is CouponGenerated) {
                    _luckyDrawBloc.add(PersistCouponsRequest(coupons: coupons));
                  }
                },
              ),
            ],
            child: Stack(
              children: [
                Container(
                  child: Column(children: [
                    // Container(
                    //   width: double.infinity,
                    //   color: Color.fromARGB(255, 57, 59, 60),
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       shadowColor: Colors.transparent,
                    //       primary: Colors.transparent,
                    //       //onPrimary: Colors.black,
                    //     ),
                    //     onPressed: () {},
                    //     child: Text(''),
                    //   ),
                    // ),
                    Container(
                      color: Color.fromARGB(255, 57, 59, 60),
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    Image.asset('assets/lucky_draw_bf.png')
                  ]),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            // padding: EdgeInsets.all(5),

                            height: MediaQuery.of(context).size.height * 0.045,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              border: Border.all(color: Constant.color2),
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Row(children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                                // width: MediaQuery.of(context).size.width * 0.04,
                                child: Center(
                                  child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image:
                                          'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                      imageErrorBuilder: (e, o, c) {
                                        return Container();
                                      }),
                                ),
                              ),
                              Expanded(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                    Text(Constant.customer != null
                                        ? Constant.customer!.diamonds
                                        : '0')
                                  ])),
                            ]),
                          ),

                          BlocBuilder<LuckyDrawBloc, LuckyDrawState>(
                            buildWhen: (previous, current) {
                              return current is CouponsGet;
                            },
                            builder: (context, state) {
                              if (state is CouponsGet) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Constant.color2,
                                    //onPrimary: Colors.black,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return LuckyDrawHistoryDialog(
                                            lucky_draw_info: luckyDraw,
                                            prizes: luckyDraw != null
                                                ? luckyDraw!.prizes
                                                    .map((e) => prizes
                                                        .firstWhere((element) =>
                                                            element.index ==
                                                            e.index))
                                                    .toList()
                                                    .reversed
                                                    .toList()
                                                : null,
                                            coupons: coupons);
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.history,
                                    color: Colors.black,
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                          // ElevatedButton.icon(
                          //     style: ElevatedButton.styleFrom(
                          //       primary: Constant.color2,
                          //       //onPrimary: Colors.black,
                          //     ),
                          //     onPressed: () {
                          //       showDialog(
                          //         context: context,
                          //         barrierDismissible: false,
                          //         builder: (BuildContext context) {
                          //           return LuckyDrawHistoryDialog(
                          //               lucky_draw_info: luckyDraw!,
                          //               prizes: luckyDraw!.prizes
                          //                   .map((e) => prizes.firstWhere(
                          //                       (element) =>
                          //                           element.index == e))
                          //                   .toList(),
                          //               coupons: coupons);
                          //         },
                          //       );
                          //     },
                          //     icon: Icon(
                          //       Icons.history,
                          //       color: Colors.black,
                          //     ),
                          //     label: Text("History",
                          //         style: TextStyle(color: Colors.black))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Center(
                        child: GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          padding: EdgeInsets.all(2),
                          children: List.generate(12, (index) {
                            if (index != 5 && index != 6) {
                              return Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(index == 1 ||
                                                index == 2 ||
                                                index == 11
                                            ? "assets/lucky_draw1.png"
                                            : index == 3 || index == 8
                                                ? "assets/lucky_draw4.png"
                                                : index == 4 ||
                                                        index == 7 ||
                                                        index == 9
                                                    ? "assets/lucky_draw3.png"
                                                    : index == 10
                                                        ? "assets/lucky_draw2.png"
                                                        : ''),
                                        fit: BoxFit.fill,
                                      ),
                                      border: Border.all(
                                          color: Colors.black, width: 1.0),
                                      boxShadow: [
                                        if (isDrawing &&
                                            (array_index[selectedIndex] ==
                                                index))
                                          BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 5.0,
                                            spreadRadius: 2.0,
                                          ),
                                      ]),
                                  child: LuckyDrawItem(
                                    prize: prizes.firstWhere(
                                        (element) => element.index == index),
                                  ));
                            } else {
                              return FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.asset(index == 5
                                      ? 'assets/lucky_draw5.png'
                                      : 'assets/lucky_draw6.png'));
                            }
                          }),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 15),
                          child: Text("Total Lucky Draw : " +
                              (luckyDraw != null
                                  ? luckyDraw!.count.toString()
                                  : "0") +
                              " times"),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Constant.color1,
                                  disabledForegroundColor: Colors.grey
                                  //onPrimary: Colors.black,
                                  ),
                              onPressed: !isDrawing
                                  ? () {
                                      getLuckyDrawPrize(1);
                                    }
                                  : null,
                              // onPressed: isDrawing ? null : startDrawing,
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(" x1 Spin "),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                      child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image:
                                              'https://soccersport.club/wp-content/uploads/2022/18/soccer_coin.png',
                                          imageErrorBuilder: (e, o, c) {
                                            return Container();
                                          }),
                                    ),
                                    Text(" 100"),
                                  ]),
                            ),
                          ),
                        )),
                        Expanded(
                            child: Container(
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Constant.color1,
                                  disabledForegroundColor: Colors.grey
                                  //onPrimary: Colors.black,
                                  ),
                              onPressed: !isDrawing
                                  ? () {
                                      getLuckyDrawPrize(5);
                                    }
                                  : null,
                              // onPressed: isDrawing ? null : startDrawing,
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(" x5 Spin "),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                      child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image:
                                              'https://soccersport.club/wp-content/uploads/2022/18/soccer_coin.png',
                                          imageErrorBuilder: (e, o, c) {
                                            return Container();
                                          }),
                                    ),
                                    Text(" 400"),
                                  ]),
                            ),
                          ),
                        ))
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.02,
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: Column(
                          children: [
                            Text("Terms & Conditions",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height * 0.02,
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "1. This lucky draw event is open to all registered users of the app."),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                        "2. There is no limit to the number of lucky draws a user can participate in."),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                        "3. Each lucky draw requires a certain number of coins. The number of coins required for each draw already specified above."),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                        "4. Some user will receive a coupon prize, which can be used to apply to designated products in the store."),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                        "5. The coupon prize cannot be exchanged for cash or other goods."),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                        "6. Coupons cannot be combined with other promotions or discounts."),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                        "7. Only one coupon can be used per product and per transactions."),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                        "8. The organizer reserves the right to modify or cancel this event at any time without prior notice."),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                        "9. In the event of any dispute, the organizer's decision shall be final and binding."),
                                  ],
                                )),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                          ],
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getLuckyDrawPrize(int time) async {
    setState(() {
      List<int> result = List.generate(time, (index) => index);
      List<LuckyDrawPrize> prizesIDs = luckyDraw!.prizes;

      List<int> productIDs = List.generate(time, (index) {
        luckyDraw = LuckyDrawInfo(
          id: Constant.auth!.id,
          count: luckyDraw!.count + 1,
          prizes: prizesIDs,
        );
        int productId = probabilityIndex();
        prizesIDs.add(LuckyDrawPrize(index: productId, date: DateTime.now()));
        return productId;
      });
      draw_prizes = productIDs;

      luckyDraw = LuckyDrawInfo(
          id: Constant.auth!.id,
          count: luckyDraw!.count,
          prizes: prizesIDs,
          draw_prizes: productIDs,
          draw: time);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoginLoadingDialog();
        },
      );

      List<Coupon> coupon_request = [];
      List<int> voucher_list = productIDs
          .where((element) => element == 7 || element == 9 || element == 4)
          .toList();
      if (voucher_list.length > 0) {
        coupon_request = voucher_list.map((e) {
          String timestamp =
              DateTime.now().millisecondsSinceEpoch.toRadixString(36);
          String stringdigit = "abcdefghijklmnopqrstuvwxyz0123456789";
          final random = Random();
          String randomString = '';
          for (var i = 0; i < 3; i++) {
            int randomIndex = random.nextInt(stringdigit.length);
            randomString += stringdigit[randomIndex];
          }

          String code = prizes[e].name[0] + "5%" + timestamp + randomString;
          if (coupons.containsKey(e.toString())) {
            (coupons[e.toString()] as List<dynamic>).add(code);
          } else {
            coupons[e.toString()] = [code];
          }
          return Coupon(
            code: code,
            amount: "5",
            type: "percent",
            individual_use: true,
            email_restrictions: [Constant.auth!.email],
            product_ids: [
              e == 7
                  ? 11399
                  : e == 9
                      ? 11509
                      : 11482
            ],
            usage_limit_per_user: 1,
            usage_limit: 1,
            limit_usage_to_x_items: 1,
          );
        }).toList();
        _productBloc.add(GenerateCouponRequest(coupon: coupon_request));
      } else {
        _luckyDrawBloc.add(LuckyDrawRequest(luckyDraw: luckyDraw!));
      }
      // print(coupon_request.map((e) => e.toMap()).toList().toString());
    });

    // await Future.forEach(result, (element) async {
    //   await startDrawing(luckyDraw!, productIDs[element as int]);
    // });
  }

  luckyDrawAnimation() async {
    int time = draw_prizes!.length;

    List<int> result = List.generate(time, (index) => index);

    await Future.forEach(result, (element) async {
      setState(() {
        isDrawing = true;
      });

      await startDrawing(luckyDraw!, draw_prizes![element as int]);
    });
  }

  int probabilityIndex() {
    if (luckyDraw!.count < 6) {
      final random = Random();
      if (random.nextDouble() < 0.7) {
        // 80% chance to get coins
        final coins = random.nextBool() ? 1 : 2;
        return coins;
      } else {
        // 20% chance to get an item
        return 3; // assuming item is represented as integer 1
      }
    } else {
      if (luckyDraw!.prizes
              .where((e) => e.index == 3 || e.index == 10 || e.index == 8)
              .toList()
              .length >=
          5) {
        final random = Random();
        final rewardProb = random.nextDouble();

        if (rewardProb < 0.3) {
          final carProb = random.nextDouble();
          if (carProb < 1 / 3) {
            return 7;
          } else if (carProb < 2 / 3) {
            return 9;
          } else {
            return 4;
          }
        } else {
          final coinProb = random.nextDouble();

          if (coinProb < 1 / 3) {
            return 1;
          } else if (coinProb < 2 / 3) {
            return 2;
          } else {
            return 11;
          }
        }
      } else {
        final random = Random();
        final rewardProb = random.nextDouble();
        if (rewardProb < 0.1) {
          // 10% chance to get a car
          final carProb = random.nextDouble();
          if (carProb < 1 / 3) {
            return 7;
          } else if (carProb < 2 / 3) {
            return 9;
          } else {
            return 4;
          }
        } else if (rewardProb < 0.5 && rewardProb > 0.1) {
          // 40% chance to get coins
          final coinProb = random.nextDouble();
          if (coinProb < 1 / 3) {
            return 1;
          } else if (coinProb < 2 / 3) {
            return 2;
          } else {
            return 11;
          }
        } else {
          // 50% chance to get a coupon
          final couponProb = random.nextDouble();
          if (couponProb < 1 / 3) {
            return 3;
          } else if (couponProb < 2 / 3) {
            return 8;
          } else {
            return 10;
          }
        }
      }
    }
  }

  Future<void> startDrawing(LuckyDrawInfo luckyDraw, int desiredIndex) async {
    int value = 0; // initial value
    int maxValues = 9; // maximum number of value
    int valueCount = 0; // current tick count
    int maxTick = 1;
    int tickCount = 0;
    int maxCycles = 5; // maximum number of cycles
    int cycleCount = 0; // current cycle count
    int baseDuration = 100; // base duration in milliseconds
    final timer = Timer.periodic(Duration(milliseconds: 50), (timer) async {
      // await Future.delayed(Duration(milliseconds: extraDuration)).then((_) {

      // });

      if (value == maxValues) {
        // increment cycle count
        tickCount++;

        if (tickCount == maxTick) {
          setState(() {
            cycleCount++;

            value = 0;
            tickCount = 0;
            // increase duration for next cycle
            selectedIndex = value;
          });
        } else {}
      } else {
        setState(() {
          tickCount++;

          if (tickCount == maxTick) {
            if (cycleCount > (desiredIndex > 4 ? 4 : 3)) maxTick = maxTick + 1;
            value++;
            selectedIndex = value;
            tickCount = 0;
          }
        });

        // increment value and tick count
      }
      if (cycleCount >= maxCycles) {
        if (array_index[selectedIndex] == desiredIndex) {
          timer.cancel();
        }
      }

      // update UI with new value and duration
    });

    await waitForTimer(timer);
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return LuckyDrawDialog(
          prize: prizes.firstWhere(
              (element) => element.index == array_index[selectedIndex]),
        );
      },
    );
    setState(() {
      isDrawing = false;
    });
  }

  Future<void> waitForTimer(Timer timer) async {
    // Wait for the timer to be canceled
    await Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 100));
      return timer.isActive;
    });
  }

  Dialog confirmationDialog(int amounth) {
    return Dialog(
        child: Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Column(children: [
        AutoSizeText('Lucky Draw Confirmation'),
        AutoSizeText("Total Coin"),
        AutoSizeText("Amount"),
        AutoSizeText("Balance"),
        Row(
          children: [
            ElevatedButton(onPressed: () {}, child: Text('Cancel')),
            ElevatedButton(onPressed: () {}, child: Text("Confirm"))
          ],
        )
      ]),
    ));
  }
}
