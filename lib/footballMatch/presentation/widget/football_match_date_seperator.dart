import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';

class FootballMatchDateSeperator extends StatelessWidget {
  final String date;

  const FootballMatchDateSeperator({required this.date});

  @override
  Widget build(BuildContext context) {
    final convertedDate = DateTime.parse(date).toLocal();
    final formattedDate = Constant.formattedDate(convertedDate);
    final dateName =
        (Constant.dateName(convertedDate)).substring(0, 3).toUpperCase();
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Text(
          '$dateName ,' + formattedDate,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
