import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../footballMatch/domain/entities/team.dart';

class FavouriteTeamDialogListtile extends StatelessWidget {
  final Team team;
  final bool isFavourite;
  final Function() favouriteFunction;
  const FavouriteTeamDialogListtile(
      {required this.team,
      required this.isFavourite,
      required this.favouriteFunction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(team.id),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Image.network(
              team.logoUrl,
              width: 36.0,
            ),
          ),
          Expanded(
            child: Container(
              child: AutoSizeText(
                team.name,
                wrapWords: false,
                minFontSize: 5,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              isFavourite ? Icons.star : Icons.star_border,
              color: Colors.yellow,
            ),
          ),
        ],
      ),
      onTap: () {
        favouriteFunction();
      },
    );
  }
}
