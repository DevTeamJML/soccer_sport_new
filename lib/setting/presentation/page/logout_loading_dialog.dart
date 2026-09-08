import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/loading_widget.dart';

class LogoutLoadingDialog extends StatelessWidget {
  const LogoutLoadingDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.05,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          LoadingWidget(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text('Logout....')
        ]),
      ),
    );
  }
}
