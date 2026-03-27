import 'package:advance_notification/advance_notification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/banner/presentation/bloc/banner_bloc.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/setting/presentation/page/sign_up_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../authentication/presentation/bloc/wordpress_auth_bloc.dart';
import '../../../injection_container.dart';

class NotVerifiedDialog extends StatefulWidget {
  final bool? afterSignup;
  NotVerifiedDialog({this.afterSignup});

  @override
  State<NotVerifiedDialog> createState() => _NotVerifiedDialogState();
}

class _NotVerifiedDialogState extends State<NotVerifiedDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _customerBloc,
      child: BlocListener<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is VerificationEmailSended) {
            if (state.success) {
              Navigator.of(context).pop();

              AdvanceSnackBar(
                      mode: Mode.ADVANCE,
                      message: "Verfication Email sent.",
                      bgColor: Colors.green)
                  .show(context);
            } else {
              AdvanceSnackBar(
                      mode: Mode.ADVANCE,
                      message: "Fail to send verification email",
                      bgColor: Colors.red)
                  .show(context);
            }
          }

          if (state is SendVerificationEmailFail) {
            AdvanceSnackBar(
                    mode: Mode.ADVANCE,
                    message: "Fail to send verification email",
                    bgColor: Colors.red)
                .show(context);
          }
        },
        child: Dialog(
            backgroundColor: Constant.backgroundColor,
            insetPadding: EdgeInsets.zero,
            // horizontal: MediaQuery.of(context).size.width * 0.1,

            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning,
                              color: Colors.red,
                              size: 26,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Important Notice',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Container(
                            padding: EdgeInsets.all(10),
                            child: Column(children: [
                              Text(
                                "- Users had to verify their account through email after sign up. \n",
                                textAlign: TextAlign.justify,
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "- For those who has already registered before, also can verify your account through registered email.  \n",
                                textAlign: TextAlign.justify,
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                "- After three weeks, account haven't verified will be suspended .",
                                textAlign: TextAlign.justify,
                                style: TextStyle(fontSize: 12),
                              ),
                              // RichText(
                              //   textAlign: TextAlign.justify,
                              //   text: TextSpan(
                              //     text:
                              //         "- After three weeks, account haven't verified will be ",
                              //     style: TextStyle(fontSize: 12),
                              //     children: <TextSpan>[
                              //       TextSpan(
                              //           text: 'suspended',
                              //           style: TextStyle(
                              //             fontSize: 15,
                              //             // color: Colors.red[700],
                              //           )),
                              //       TextSpan(
                              //         text: '.',
                              //         style: TextStyle(fontSize: 15),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              if (widget.afterSignup == null &&
                                  widget.afterSignup != true)
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Click below button to get verification mail',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Expanded(
                                        child: BlocBuilder<CustomerBloc,
                                            CustomerState>(
                                          builder: (context, state) {
                                            return GestureDetector(
                                              onTap: state
                                                      is SendingVerificationEmail
                                                  ? null
                                                  : () {
                                                      _customerBloc.add(
                                                          SendVerificationEmailRequest(
                                                              id: Constant
                                                                  .auth!.id
                                                                  .toString()));
                                                    },
                                              child: Container(
                                                width: double.infinity,
                                                margin: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                ),
                                                child: state
                                                        is SendingVerificationEmail
                                                    ? Center(
                                                        child: LoadingWidget(),
                                                      )
                                                    : Center(
                                                        child: Text('Send',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ])),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('If got issues, can contact us via our email',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                )),
                            GestureDetector(
                              onTap: () async {
                                final url =
                                    'mailto:soccersport.clubcs@gmail.com';
                                if (await canLaunch(url)) {
                                  print('got ma??');
                                  await launch(url);
                                } else {
                                  await Clipboard.setData(ClipboardData(
                                      text: 'soccersport.clubcs@gmail.com'));
                                  AdvanceSnackBar(
                                          mode: Mode.ADVANCE,
                                          message: "Copied to clipbaord",
                                          bgColor: Colors.green)
                                      .show(context);
                                }
                                // if (!result.didOpen && result.canOpen) {
                                //   print('got open dao ??');

                                //   showDialog(
                                //     context: context,
                                //     builder: (_) {
                                //       return MailAppPickerDialog(
                                //         mailApps: result.options,
                                //       );
                                //     },
                                //   );
                                // } else {
                                //   print('got copy dao ??');

                                //   await Clipboard.setData(ClipboardData(
                                //       text: 'soccersport.clubcs@gmail.com'));
                                //   AdvanceSnackBar(
                                //           mode: Mode.ADVANCE,
                                //           message: "Copied to clipbaord",
                                //           bgColor: Colors.green)
                                //       .show(context);
                                // }
                                // If no mail apps found, show error
                              },
                              child: Text('soccersport.clubcs@gmail.com',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                      fontStyle: FontStyle.italic)),
                            )
                          ],
                        ),
                      ]),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.afterSignup != null && widget.afterSignup!) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Constant.pageController!.jumpToPage(0);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Opacity(
                    opacity: 0.7,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: Colors.grey,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
