import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/banner/presentation/bloc/banner_bloc.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/setting/presentation/page/sign_up_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../../authentication/presentation/bloc/wordpress_auth_bloc.dart';
import '../../../injection_container.dart';

// class DailyClaimsDialog extends StatefulWidget {
//   final Function navigateToClaimPage;
//   DailyClaimsDialog({required this.navigateToClaimPage});
//   @override
//   State<DailyClaimsDialog> createState() => _DailyClaimsDialogState();
// }

// class _DailyClaimsDialogState extends State<DailyClaimsDialog> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         print('got take ma ??');

//         if (Constant.auth != null) {
//           widget.navigateToClaimPage();
//         } else {
//           print('got push ma ??');
//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => SignUpPage(
//               pressEvent: true,
//             ),
//           ));
//         }
//       },
//       child: Dialog(
//           insetPadding: EdgeInsets.zero,
//           // horizontal: MediaQuery.of(context).size.width * 0.1,

//           child: Stack(
//             alignment: AlignmentDirectional.topEnd,
//             children: [
//               Container(
//                   height: MediaQuery.of(context).size.height * 0.3,
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   child: FittedBox(
//                     fit: BoxFit.fill,
//                     child: FadeInImage.memoryNetwork(
//                         placeholder: kTransparentImage,
//                         image: '',
//                         imageErrorBuilder: (e, o, c) {
//                           return Container(
//                             color: Colors.grey,
//                             child: Image.asset('assets/image-loading.jpg'),
//                           );
//                         }),
//                   )),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Icon(Icons.exit_to_app),
//               ),
//             ],
//           )),
//     );
//   }
// }

class DailyClaimsDialog extends StatefulWidget {
  final Function navigateToClaimPage;
  DailyClaimsDialog({required this.navigateToClaimPage});
  @override
  State<DailyClaimsDialog> createState() => _DailyClaimsDialogState();
}

class _DailyClaimsDialogState extends State<DailyClaimsDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (Constant.auth != null) {
          Navigator.of(context).pop();
          Constant.pageController!.jumpToPage(0);
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      },
      child: Dialog(
          insetPadding: EdgeInsets.zero,
          // horizontal: MediaQuery.of(context).size.width * 0.1,
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Container(
                color: Colors.transparent,
                // height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Image.asset('assets/bet_banner.gif'),
                // child: FittedBox(
                //   fit: BoxFit.fill,
                //   child: Image.asset('assets/Image.gif'),
                //   // child: FadeInImage.memoryNetwork(
                //   //     placeholder: kTransparentImage,
                //   //     image:
                //   //         'https://soccersport.club/wp-content/uploads/2022/18/p6_banner.jpg',
                //   //     imageErrorBuilder: (e, o, c) {
                //   //       return Container();
                //   //     }),
                // ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
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
    );
  }
}
