import 'package:flutter/material.dart';

class NoFavouriteTeam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('No Favourite Team yet.'),
        SizedBox(
          height: 8,
        ),
        Text('Click on "+" button to favourite team'),
      ],
    ));
  }
}
