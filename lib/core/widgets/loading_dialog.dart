import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  // LoadingDialog({Key? key}) : super(key: key);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      // title: Text(AppLocalizations.of(context).profile),
      child: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              CircularProgressIndicator(),
              Text('Loading...'),
            ],
          ),
        )
      ])),
    );
  }
}
