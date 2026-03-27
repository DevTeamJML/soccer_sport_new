import 'dart:io';

import 'package:advance_notification/advance_notification.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:soccer_sport/setting/domain/entity/feedback.dart';
import 'package:soccer_sport/setting/presentation/bloc/feedback_bloc.dart';

class FeedbackPage extends StatefulWidget {
  // const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _commentsController = TextEditingController();
  late InAppWebViewController controller;

  final _formKey = GlobalKey<FormState>();

  // final FeedbackBloc _feedbackBloc = serviceLocator<FeedbackBloc>();
  // File? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Constant.auth != null) {
      _emailController.text = Constant.auth!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        automaticallyImplyLeading: false,
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
      body: InAppWebView(
        onProgressChanged: ((controller, progress) {}),
        onConsoleMessage: (v, d) {},

        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
              useShouldInterceptAjaxRequest: true,
              useShouldInterceptFetchRequest: true,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
            ),
            android: AndroidInAppWebViewOptions(),
            ios: IOSInAppWebViewOptions(
              enableViewportScale: true,

              // useShouldOverrideUrlLoading: true,
            )),
        initialUrlRequest: URLRequest(
            url: WebUri('https://soccersport.club/feedback/')),
        onWebViewCreated: (controller) {
          this.controller = controller;
        },
        // onPageStarted: (url) {},
        // onPageFinished: (url) {
        //   controller.evaluateJavascript(
        //       "document.getElementsByTagName('header')[0].style.display='none'");
        //   controller.evaluateJavascript(
        //       "document.getElementsByTagName('footer')[0].style.display='none'");
        // },
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Feedback'),
    //   ),
    //   body: BlocProvider(
    //     create: (context) => _feedbackBloc,
    //     child: BlocListener<FeedbackBloc, FeedbackState>(
    //       listener: (context, state) {
    //         if (state is FeedbackSent) {
    //           setState(() {});
    //         }
    //       },
    //       child: Container(
    //         padding: EdgeInsets.symmetric(
    //           horizontal: MediaQuery.of(context).size.width * 0.05,
    //           vertical: MediaQuery.of(context).size.height * 0.05,
    //         ),
    //         child: Form(
    //           key: _formKey,
    //           child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 TextFormField(
    //                   style: TextStyle(color: Colors.white),
    //                   validator: (value) => value!.isEmpty ? 'required' : null,
    //                   controller: _emailController,
    //                   decoration: InputDecoration(
    //                     labelText: "Email",
    //                     hintStyle: TextStyle(color: Colors.white),
    //                     labelStyle: TextStyle(
    //                         color: Colors.white, fontWeight: FontWeight.bold),
    //                     hintText: "Email",
    //                     floatingLabelBehavior: FloatingLabelBehavior.always,
    //                     border: OutlineInputBorder(),
    //                     focusedErrorBorder: OutlineInputBorder(
    //                       borderSide: BorderSide(color: Colors.red, width: 1.0),
    //                     ),
    //                     enabledBorder: OutlineInputBorder(
    //                         borderSide: BorderSide(color: Colors.white)),
    //                     focusedBorder: OutlineInputBorder(
    //                       borderSide:
    //                           BorderSide(color: Colors.blue, width: 1.0),
    //                     ),
    //                     errorBorder: OutlineInputBorder(
    //                       borderSide: BorderSide(color: Colors.red, width: 1.0),
    //                     ),
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: MediaQuery.of(context).size.height * 0.02,
    //                 ),
    //                 TextFormField(
    //                   keyboardType: TextInputType.multiline,
    //                   maxLines: 4,
    //                   style: TextStyle(color: Colors.white),
    //                   validator: (value) => value!.isEmpty ? 'required' : null,
    //                   controller: _commentsController,
    //                   decoration: InputDecoration(
    //                     labelText: "Comments",
    //                     hintStyle: TextStyle(color: Colors.grey),
    //                     labelStyle: TextStyle(
    //                         color: Colors.white, fontWeight: FontWeight.bold),
    //                     hintText: "Optional",
    //                     floatingLabelBehavior: FloatingLabelBehavior.always,
    //                     border: OutlineInputBorder(),
    //                     focusedErrorBorder: OutlineInputBorder(
    //                       borderSide: BorderSide(color: Colors.red, width: 1.0),
    //                     ),
    //                     enabledBorder: OutlineInputBorder(
    //                         borderSide: BorderSide(color: Colors.white)),
    //                     focusedBorder: OutlineInputBorder(
    //                       borderSide:
    //                           BorderSide(color: Colors.blue, width: 1.0),
    //                     ),
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: MediaQuery.of(context).size.height * 0.02,
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       "Attachment",
    //                       style: TextStyle(fontWeight: FontWeight.bold),
    //                     ),
    //                   ],
    //                 ),
    //                 GestureDetector(
    //                   onTap: () async {
    //                     print('wht gtot nothing ?');
    //                     final result = await FilePicker.platform.pickFiles(
    //                         allowMultiple: false, type: FileType.image);
    //                     if (result != null) {
    //                       if (result.files.first.size > 5000000) {
    //                         AdvanceSnackBar(
    //                                 mode: Mode.ADVANCE,
    //                                 message: "File size can't be more than 5MB",
    //                                 bgColor: Colors.red)
    //                             .show(context);
    //                       } else {
    //                         setState(() {
    //                           final imageTemporary =
    //                               File(result.files.first.path!);
    //                           image = imageTemporary;
    //                         });
    //                       }
    //                     } else {
    //                       return;
    //                     }
    //                   },
    //                   child: DottedBorder(
    //                     color: Colors.grey,
    //                     child: image == null
    //                         ? Container(
    //                             width: double.infinity,
    //                             height:
    //                                 MediaQuery.of(context).size.height * 0.2,
    //                             decoration: BoxDecoration(
    //                                 color: Colors.grey.withOpacity(0.4)),
    //                             child: Column(
    //                               mainAxisAlignment: MainAxisAlignment.center,
    //                               children: [
    //                                 Icon(
    //                                   Icons.upload_file,
    //                                   color: Colors.white,
    //                                 ),
    //                                 Text("[Optional]"),
    //                                 Text("Tap here to upload image")
    //                               ],
    //                             ))
    //                         : Container(
    //                             width: double.infinity,
    //                             height:
    //                                 MediaQuery.of(context).size.height * 0.2,
    //                             child: FittedBox(
    //                               fit: BoxFit.contain,
    //                               child: Image.file(image!),
    //                             )),
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: MediaQuery.of(context).size.height * 0.02,
    //                 ),
    //                 SizedBox(
    //                   width: MediaQuery.of(context).size.width * 0.4,
    //                   child: ElevatedButton(
    //                       style: ElevatedButton.styleFrom(
    //                           primary: Constant.color1,
    //                           padding: EdgeInsets.all(15)),
    //                       onPressed: () {
    //                         if (_formKey.currentState!.validate()) {
    //                           FeedbackC feedback = FeedbackC(
    //                               email: _emailController.text,
    //                               comments: _commentsController.text,
    //                               attachment: image);
    //                           _feedbackBloc
    //                               .add(SendFeedbackRequest(feedback: feedback));
    //                         }
    //                       },
    //                       child: Text("Submit")),
    //                 )
    //               ]),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
