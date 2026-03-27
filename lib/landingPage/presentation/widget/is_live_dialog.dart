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
import '../../../injection_container.dart';

class IsLiveDialog extends StatefulWidget {
  final String content;
  final String title;

  const IsLiveDialog({required this.content, required this.title});

  @override
  State<IsLiveDialog> createState() => _IsLiveDialogState();
}

class _IsLiveDialogState extends State<IsLiveDialog> {
  String content = '';
  String title = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    content = widget.content;
    title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Dialog(
          insetPadding: EdgeInsets.zero,
          // horizontal: MediaQuery.of(context).size.width * 0.1,

          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Container(
                color: Constant.backgroundColor,
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                title,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            Expanded(
                                child: Text(content,
                                    style: TextStyle(
                                      fontSize: 13,
                                    ))),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  print('got press??');
                                  Navigator.of(context).pop();

                                  Constant.pageController!.jumpToPage(1);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 30),
                                  // padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Constant.color1,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  child: Center(child: Text('Go to Live Page')),
                                ),
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
              GestureDetector(
                  onTap: () {
                    print('got press??');
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
                            color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          CupertinoIcons.clear_circled_solid,
                          color: Colors.grey,
                          size: 26,
                        ),
                      ),
                    ),
                  )),
            ],
          )),
    );
  }
}
