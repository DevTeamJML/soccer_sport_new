import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';

class FavouriteTeamDialogHeader extends StatelessWidget {
  final String name;

  const FavouriteTeamDialogHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        color: Colors.grey,
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
