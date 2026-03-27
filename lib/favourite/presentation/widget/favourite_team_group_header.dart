import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class FavouriteTeamGroupHeader extends StatelessWidget {
  final String name;
  const FavouriteTeamGroupHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, top: 8),
        child: Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
