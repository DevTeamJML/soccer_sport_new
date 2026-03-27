import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
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

class HomepageAds extends StatefulWidget {
  const HomepageAds();

  @override
  State<HomepageAds> createState() => _HomepageAdsState();
}

class _HomepageAdsState extends State<HomepageAds> {
  final BannerBloc _bannerBloc = serviceLocator<BannerBloc>();

  final WordpressAuthBloc _authBloc = serviceLocator<WordpressAuthBloc>();
  BannerHtml? html;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bannerBloc.add(GetFirstTimeInstallBannerRequest(
        api: FootballApi.bannerApi, id: 'mobile-modal-banner1'));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WordpressAuthBloc>(
            create: (context) => _authBloc,
          ),
          BlocProvider(
            create: (context) => _bannerBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<WordpressAuthBloc, WordpressAuthState>(
              bloc: _authBloc,
              listener: (context, state) {
                if (state is FirstTimeInstallRemoved) {
                  print('got remove ??');
                  Navigator.of(context).pop();
                }
                // TODO: implement listener
              },
            ),
            BlocListener<BannerBloc, BannerState>(
              listener: (context, state) {
                // if (state is FirstTimeBannerLoaded) {
                //   setState(() {
                //     html = state.html;
                //   });
                // }
              },
            ),
          ],
          child: GestureDetector(
            onTap: html != null
                ? () async {
                    if (html!.href != null) {
                      if (await canLaunch(html!.href!)) {
                        await launch(html!.href!);
                      } else {
                        throw 'Could not launch ${html!.href!}';
                      }
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }
                  }
                : null,
            child: Dialog(
                insetPadding: EdgeInsets.zero,
                // horizontal: MediaQuery.of(context).size.width * 0.1,

                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: html != null
                            ? FittedBox(
                                fit: BoxFit.fill,
                                child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: html!.url!,
                                    imageErrorBuilder: (e, o, c) {
                                      return Container(
                                        color: Colors.grey,
                                        child: Image.asset(
                                            'assets/image-loading.jpg'),
                                      );
                                    }),
                              )
                            : LoadingWidget()),
                    if (html != null)
                      // GestureDetector(
                      //   onTap: () {
                      //     print('got press??');
                      //     _authBloc.add(RemoveFirstTimeInstallRequest());
                      //     serviceLocator<AnalyticsService>()
                      //         .logScreens(name: '/homepageads/close');
                      //   },
                      //   child: Icon(Icons.exit_to_app),
                      // ),

                      GestureDetector(
                          onTap: () {
                            print('got press??');
                            _authBloc.add(RemoveFirstTimeInstallRequest());
                            serviceLocator<AnalyticsService>()
                                .logScreens(name: '/homepageads/close');
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
                )),
          ),
        ),
      ),
    );
  }
}
