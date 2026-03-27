import 'package:advance_notification/advance_notification.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:soccer_sport/authentication/presentation/bloc/wordpress_auth_bloc.dart';
import 'package:soccer_sport/authentication/presentation/widget/login_loading_dialog.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/landingPage/presentation/page/personalize_page.dart';
import 'package:soccer_sport/landingPage/presentation/widget/daily_claims_page.dart';
import 'package:soccer_sport/landingPage/presentation/widget/not_verified_dialog.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:wordpress_api/wordpress_api.dart';

import '../../../core/constant/analytics_service.dart';
import '../../../core/constant/constants.dart';
import '../../../customer/presentation/bloc/customer_bloc.dart';
import '../../../injection_container.dart';

class SignUpPage extends StatefulWidget {
  final bool? pressEvent;
  SignUpPage({this.pressEvent});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // late WebViewController controller;

  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _usernameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _cPasswordController = TextEditingController();

  final WordpressAuthBloc _authBloc = serviceLocator<WordpressAuthBloc>();
  final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();

  // final NotificationBloc _notificationBloc = serviceLocator<NotificationBloc>();
  bool _hideText = true;

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Signup Page'),
    //     leading: IconButton(
    //       icon: Icon(
    //         Icons.arrow_back,
    //         color: Colors.white,
    //       ),
    //       onPressed: () async {
    //         Navigator.of(context).pop();
    //       },
    //     ),
    //   ),
    //   body: WebView(
    //     javascriptMode: JavascriptMode.unrestricted,
    //     initialUrl: 'https://soccersport.club/register',
    //     onWebViewCreated: (controller) {
    //       this.controller = controller;
    //       controller.clearCache();
    //     },
    //     navigationDelegate: (v) {
    //       print(v);
    //       if (v.url.split('/').contains('register')) {
    //         return NavigationDecision.navigate;
    //       } else {
    //         AdvanceSnackBar(
    //                 mode: "ADVANCE",
    //                 message: "Register Success",
    //                 bgColor: Colors.green)
    //             .show(context);
    //         Navigator.of(context).pop();
    //         return NavigationDecision.prevent;
    //       }
    //     },
    //     onPageStarted: (url) {},
    //     onPageFinished: (url) {
    //       controller.evaluateJavascript(
    //           "document.getElementsByClassName('um-alt')[0].style.display='none'");
    //       controller.evaluateJavascript(
    //           "document.getElementsByTagName('header')[0].style.display='none'");
    //       controller.evaluateJavascript(
    //           "document.getElementsByTagName('footer')[0].style.display='none'");
    //     },
    //   ),
    // );

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
        title: Text(
          "Sign Up",
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<WordpressAuthBloc>(
                create: (context) => _authBloc,
              ),
              BlocProvider<CustomerBloc>(
                create: (context) => _customerBloc,
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
                          _customerBloc.add(GetUserRewardDetailRequest(
                              id: Constant.auth!.id.toString()));
                        });
                      }

                      if (state is UserRewardDetailGet) {
                        setState(() {
                          Constant.customerRewardDetail = state.success;

                          if (Constant.customerRewardDetail!.leagues.length >
                              0) {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return NotVerifiedDialog(afterSignup: true);
                              },
                            );
                          } else {
                            Navigator.of(context).pop();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PersonalizePage(
                                        settingPage: true,
                                      )),
                            ).then((_) => showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return NotVerifiedDialog(afterSignup: true);
                                  },
                                ));
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => PersonalizePage(
                            //             settingPage: true,
                            //           )).then((_) => setState(() {
                            //         print('got chsngrcustomer');
                            //         Constant.customer = Constant.customer;
                            //       }));
                            // );
                          }

                          // if (widget.pressEvent != null && widget.pressEvent!) {
                          //   Constant.pageController!.jumpToPage(0);
                          //   serviceLocator<AnalyticsService>()
                          //       .logScreens(name: '/dailyclaim');
                          //   Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //         builder: (context) => DailyClaimsPage()),
                          //   );
                          // } else {
                          //   Constant.pageController!.jumpToPage(0);
                          // }
                        });
                      }
                    }),
                BlocListener<WordpressAuthBloc, WordpressAuthState>(
                  bloc: _authBloc,
                  listener: (context, state) {
                    if (state is UserRegistered) {
                      if (state.auth != null) {
                        _authBloc.add(WordpressLoginRequest(
                            username: state.auth!.username,
                            password: state.auth!.password));
                        // Navigator.of(context).pop();
                      } else {}
                    }

                    if (state is UserExistError) {
                      Navigator.of(context).pop();

                      AdvanceSnackBar(
                              mode: Mode.ADVANCE,
                              message: "Username/email has been taken",
                              bgColor: Colors.red)
                          .show(context);
                    }

                    if (state is WordpressLoginSuccess) {
                      if (state.auth != null) {
                        // OneSignal.shared.sendTag('Non-Member', 'false');
                        // OneSignal.shared.sendTag('Member', 'true');
                        OneSignal.User.addTagWithKey("Non-Member", "false");
                        OneSignal.User.addTagWithKey("Member", "true");

                        serviceLocator<AnalyticsService>()
                            .setUserId(userId: state.auth!.email);
                        _authBloc.add(PersistAuthRequest(auth: state.auth!));
                      } else {}
                    }
                    if (state is WordpressLoginIncorrect) {
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
                // BlocListener<NotificationBloc, NotificationState>(
                //   bloc: _notificationBloc,
                //   listener: (context, state) {
                //     if (state is NotificationPersisted) {
                //       if (state.notification) {
                //         // OneSignal.shared.setAppId(UBuyApi.oneSignalId);

                //         OneSignal.shared.setAppId(UBuyApi.oneSignalId);
                //         OneSignal.shared.disablePush(false);
                //         OneSignal.shared
                //             .promptUserForPushNotificationPermission();
                //         Navigator.of(context).pop();

                //         Navigator.popUntil(
                //             context, ModalRoute.withName('/NavigationPage'));
                //         Constant.pageController!.jumpToPage(0);
                //       } else {
                //         Navigator.of(context).pop();

                //         Navigator.popUntil(
                //             context, ModalRoute.withName('/NavigationPage'));
                //         Constant.pageController!.jumpToPage(0);
                //       }
                //     }
                //   },
                // )
              ],
              child: BlocBuilder<WordpressAuthBloc, WordpressAuthState>(
                bloc: _authBloc,
                builder: (context, state) {
                  return Column(children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset('assets/soccer_club_logo.png'),
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: 'Username',
                                  icon: const Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: const Icon(Icons.person))),
                              controller: _usernameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.text,
                              validator: (value) => value!.isEmpty
                                  ? "Username can't be empty"
                                  : null,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            // TextFormField(
                            //   textInputAction: TextInputAction.next,
                            //   decoration: InputDecoration(
                            //     labelText: 'First Name',
                            //   ),
                            //   autovalidateMode:
                            //       AutovalidateMode.onUserInteraction,
                            //   controller: _firstNameController,
                            //   keyboardType: TextInputType.text,
                            //   validator: (value) => value!.isEmpty
                            //       ? "First Name can't be empty"
                            //       : null,
                            // ),
                            // SizedBox(
                            //   height: MediaQuery.of(context).size.height * 0.01,
                            // ),
                            // TextFormField(
                            //   textInputAction: TextInputAction.next,
                            //   decoration: InputDecoration(
                            //     labelText: 'Last Name',
                            //   ),
                            //   controller: _lastNameController,
                            //   autovalidateMode:
                            //       AutovalidateMode.onUserInteraction,
                            //   keyboardType: TextInputType.text,
                            //   validator: (value) => value!.isEmpty
                            //       ? "Last Name can't be empty"
                            //       : null,
                            // ),
                            // SizedBox(
                            //   height: MediaQuery.of(context).size.height * 0.01,
                            // ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  icon: const Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: const Icon(Icons.email))),
                              controller: _emailController,
                              keyboardType: TextInputType.text,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return EmailValidator.validate(
                                        value != null ? value : '')
                                    ? null
                                    : "Please enter a valid email";
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Stack(alignment: Alignment.centerRight, children: [
                              TextFormField(
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      errorStyle: TextStyle(color: Colors.red),
                                      errorMaxLines: 2,
                                      labelText: 'Password',
                                      icon: const Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: const Icon(Icons.lock))),
                                  controller: _passwordController,
                                  keyboardType: TextInputType.text,
                                  obscureText: _hideText,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    RegExp regex = RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
                                    return value!.isEmpty
                                        ? "Password can't be empty"
                                        : !(regex.hasMatch(value))
                                            ? 'Must contain at least one lowercase letter, one capital letter and one number'
                                            : null;
                                  }),
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
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Stack(alignment: Alignment.centerRight, children: [
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    icon: const Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: const Icon(Icons.lock))),
                                controller: _cPasswordController,
                                keyboardType: TextInputType.text,
                                obscureText: _hideText,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) => value!.isEmpty
                                    ? "Confirm Password can't be empty"
                                    : value != _passwordController.text
                                        ? 'Confirm password not match'
                                        : null,
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
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 40),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    state is RegisteringUser ||
                                            state is UserRegistered
                                        ? LoadingWidget()
                                        : Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.06,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Constant.color1,
                                                // shadowColor: Colors.white,
                                                // side: BorderSide(color: Colors.white, width: 0.2)
                                              ),
                                              // color: Constant.color1,
                                              // shape: RoundedRectangleBorder(
                                              //   borderRadius:
                                              //       BorderRadius.circular(30.0),
                                              // ),
                                              child: Text(
                                                'Sign Up',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  // print(
                                                  //     _usernameController.text);
                                                  // print(
                                                  //     _passwordController.text);
                                                  // print(_emailController.text);
                                                  _authBloc
                                                      .add(RegisterUserRequest(
                                                    username:
                                                        _usernameController
                                                            .text,
                                                    password:
                                                        _passwordController
                                                            .text,
                                                    email:
                                                        _emailController.text,
                                                  ));
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder:
                                                        (BuildContext context) {
                                                      return LoginLoadingDialog();
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),

                            // SizedBox(
                            //   height: MediaQuery.of(context).size.height * 0.06,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
