import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/banner/presentation/bloc/banner_bloc.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/setting/presentation/page/sign_up_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../authentication/presentation/bloc/wordpress_auth_bloc.dart';
import '../../../authentication/presentation/page/login_page.dart';
import '../../../banner/domain/entities/ssc_dialog.dart';
import '../../../injection_container.dart';

class SscDialogWidget extends StatefulWidget {
  final SscDialog sscDialog;

  const SscDialogWidget({
    required this.sscDialog,
  });

  @override
  State<SscDialogWidget> createState() => _SscDialogWidgetState();
}

class _SscDialogWidgetState extends State<SscDialogWidget> {
  late SscDialog sscDialog;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sscDialog = widget.sscDialog;
  }

  Future<void> launchUrl() async {
    if (await canLaunch(sscDialog.callback)) {
      await launch(sscDialog.callback);
    } else {
      throw 'Could not launch ${sscDialog.callback}';
    }
  }

  Future<void> checkAuth() async {
    if (sscDialog.isAuth) {
      if (Constant.auth != null) {
        await launchUrl();
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } else {
      await launchUrl();
    }
  }

  @override
  Widget build(BuildContext context) {
    return sscDialog.isDialog
        ? Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            // horizontal: MediaQuery.of(context).size.width * 0.1,

            child: Container(
              decoration: BoxDecoration(
                color: Constant.backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Container(
                    height: 60,
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  sscDialog.dialogTitle != null
                                      ? sscDialog.dialogTitle!
                                      : " ",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Icon(
                                  FontAwesomeIcons.xmark,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: sscDialog.image,
                                  imageErrorBuilder: (e, o, c) {
                                    return Container();
                                  }),
                            ),
                            //  AutoSizeText(
                            //    ,
                            //   style: TextStyle(
                            //     fontSize: 22,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            //   maxLines: 1,
                            // ),
                          ),
                          if (sscDialog.dialogDescription != null)
                            Expanded(
                                child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Text(sscDialog.dialogDescription!,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                        )),
                                  ),
                                ],
                              ),
                            )),
                          GestureDetector(
                            onTap: () async {
                              await checkAuth();
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              // padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Constant.color1,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                  child: Text(
                                      sscDialog.button != null
                                          ? sscDialog.button!
                                          : "Submit",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ],
                      )),
                  // Expanded(
                  //   flex: 1,
                  //   child: Container(),
                  // ),
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: () async {
              await checkAuth();
            },
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: sscDialog.image,
                          imageErrorBuilder: (e, o, c) {
                            return Container();
                          }),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          // child: Icon(
                          //   Icons.exit_to_app,
                          //   color: Colors.white,
                          // ),
                          child: Container(
                            // decoration: BoxDecoration(
                            //                     shape: BoxShape.circle,

                            // )
                            child: Opacity(
                              opacity: 0.7,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  CupertinoIcons.clear_circled_solid,
                                  color: Colors.grey,
                                  size: 26,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ));
  }
}
