import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:soccer_sport/authentication/presentation/bloc/wordpress_auth_bloc.dart';
import 'package:soccer_sport/authentication/presentation/widget/login_loading_dialog.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/landingPage/presentation/page/home_page.dart';
import 'package:soccer_sport/landingPage/presentation/page/personalize_page.dart';
import 'package:soccer_sport/notification/presentation/bloc/notification_bloc.dart';
import 'package:soccer_sport/setting/presentation/page/sign_up_page.dart';

import '../../../core/constant/analytics_service.dart';
import '../../../customer/presentation/widget/edit_address_loading.dart';
import '../../../injection_container.dart';
import 'package:advance_notification/advance_notification.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:transparent_image/transparent_image.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final WordpressAuthBloc _authBloc = serviceLocator<WordpressAuthBloc>();
  final NotificationBloc _notificationBloc = serviceLocator<NotificationBloc>();
  final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();

  bool _hideText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _authBloc.close();
    _usernameController.dispose();
    _passwordController.dispose();
    _notificationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<WordpressAuthBloc>(
                create: (context) => _authBloc,
              ),
              BlocProvider<NotificationBloc>(
                create: (context) => _notificationBloc,
              ),
              BlocProvider<CustomerBloc>(
                create: (context) => _customerBloc,
              ),
            ],
            child: MultiBlocListener(
              listeners: [
                BlocListener<WordpressAuthBloc, WordpressAuthState>(
                  bloc: _authBloc,
                  listener: (context, state) {
                    if (state is WordpressLoginSuccess) {
                      if (state.auth != null) {
                        // OneSignal.shared.sendTag('Non-Member', 'false');
                        // OneSignal.shared.sendTag('Member', 'true');
                        OneSignal.User.addTagWithKey("Non-Member", "false");
                        OneSignal.User.addTagWithKey("Member", "true");

                        serviceLocator<AnalyticsService>()
                            .setUserId(userId: state.auth!.email);

                        // Navigator.popUntil(
                        //     context, ModalRoute.withName('/homepage'));
                        _authBloc.add(PersistAuthRequest(auth: state.auth!));
                      } else {}
                    }

                    if (state is WordpressLoginIncorrect) {
                      Navigator.of(context).pop();
                      AdvanceSnackBar(
                              mode: Mode.ADVANCE,
                              message: "Username/Password incorrect.",
                              bgColor: Constant.color1)
                          .show(context);
                    }

                    if (state is AuthPersisted) {
                      setState(() {
                        Constant.isMember = true;
                        _customerBloc.add(
                            GetCustomerDetailsRequest(id: Constant.auth!.id));
                      });

                      // _notificationBloc
                      //     .add(PersistNotificationRequest(notification: true));
                    }
                  },
                ),
                BlocListener<NotificationBloc, NotificationState>(
                  bloc: _notificationBloc,
                  listener: (context, state) {
                    if (state is NotificationPersisted) {
                      if (state.notification) {
                        // OneSignal.shared.setAppId(FootballApi.oneSignalId);

                        // OneSignal.shared.setAppId(FootballApi.oneSignalId);
                        // OneSignal.shared.disablePush(false);
                        // OneSignal.shared
                        //     .promptUserForPushNotificationPermission();
                        OneSignal.initialize(FootballApi.oneSignalId);
                        // Enable push
                        OneSignal.User.pushSubscription.optIn();
                        // Ask permission (iOS / Android 13+)
                        OneSignal.Notifications.requestPermission(true);

                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomePage()));
                        Navigator.of(context).pop();
                        Constant.pageController!.jumpToPage(0);

                        Navigator.popUntil(
                            context, ModalRoute.withName('/homepage'));
                      } else {
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomePage()));
                        Navigator.of(context).pop();
                        Constant.pageController!.jumpToPage(0);

                        Navigator.popUntil(
                            context, ModalRoute.withName('/homepage'));
                      }
                    }
                  },
                ),
                BlocListener<CustomerBloc, CustomerState>(
                  bloc: _customerBloc,
                  listener: (context, state) {
                    if (state is CustomerDetailsLoaded) {
                      setState(() {
                        Constant.customer = state.customer;
                        _customerBloc.add(GetUserRewardDetailRequest(
                            id: Constant.auth!.id.toString()));
                      });
                    }

                    if (state is UserRewardDetailGet) {
                      setState(() {
                        Constant.customerRewardDetail = state.success;
                        Navigator.of(context).pop();

                        if (Constant.customerRewardDetail!.leagues.length > 0) {
                          Navigator.of(context).pop();
                          Constant.pageController!.jumpToPage(0);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PersonalizePage()),
                          );
                        }
                      });
                    }
                  },
                )
              ],
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ]),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Image.asset('assets/soccer_club_logo.png'),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: 'Username/Email',
                                  icon: const Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: const Icon(Icons.person))),
                              controller: _usernameController,
                              keyboardType: TextInputType.text,
                              validator: (value) => value!.isEmpty ? '' : null,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025,
                            ),
                            Stack(alignment: Alignment.centerRight, children: [
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    icon: const Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: const Icon(Icons.lock))),
                                controller: _passwordController,
                                keyboardType: TextInputType.text,
                                obscureText: _hideText,
                                validator: (value) =>
                                    value!.isEmpty ? '' : null,
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _hideText = !_hideText;
                                    });
                                  },
                                  icon: Icon(
                                    _hideText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ))
                            ]),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Constant.color2,
                                    // shadowColor: Colors.white,
                                    // side: BorderSide(color: Colors.white, width: 0.2),
                                  ),
                                  // color: Constant.color2,
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(30.0),
                                  // ),
                                  // textColor: Colors.white,
                                  child: Text(
                                    'Login',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _authBloc.add(WordpressLoginRequest(
                                          username: _usernameController.text,
                                          password: _passwordController.text));
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return LoginLoadingDialog();
                                        },
                                      );

                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             HomePage()));
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Constant.color2,
                                    // shadowColor: Colors.white,
                                    // side: BorderSide(color: Colors.white, width: 0.2),
                                  ),
                                  // color: Constant.color2,
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(30.0),
                                  // ),
                                  // textColor: Colors.white,
                                  child: Text(
                                    'Sign Up',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => SignUpPage(),
                                    ));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (await canLaunch(
                                  "https://soccersport.club/password-reset/")) {
                                await launch(
                                    "https://soccersport.club/password-reset/");
                              } else {
                                throw 'Could not launch https://soccersport.club/password-reset/';
                              }
                            },
                            child: Text(
                              'Forget your password?',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Skip For Now.',
                              style: TextStyle(color: Constant.color2),
                            ),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.06,
                      // ),
                    ],
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
