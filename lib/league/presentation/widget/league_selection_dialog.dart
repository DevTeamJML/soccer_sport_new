import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/presentation/widget/league_country_name_seperator.dart';
import 'package:azlistview/azlistview.dart';
import 'package:outline_search_bar/outline_search_bar.dart';

class LeagueSelectionDialog extends StatefulWidget {
  final Function(int) selectedFunction;
  final List<LeagueDetails>? leagues;

  LeagueSelectionDialog({required this.selectedFunction, this.leagues});

  @override
  State<LeagueSelectionDialog> createState() => _LeagueSelectionDialogState();
}

class _LeagueSelectionDialogState extends State<LeagueSelectionDialog> {
  List<LeagueDetails> searchedResult = [];
  List<LeagueDetails> allLeagueList = [];
  String searchValue = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // searchedResult = List<LeagueDetails>.from(Constant.staticLeagues);
    print(Constant.staticLeagues[0].league.name + 'league pahge');
    if (widget.leagues != null) {
      allLeagueList = widget.leagues!;
    } else {
      allLeagueList = List<LeagueDetails>.from(Constant.staticLeagues);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // scrollable: true,
      // actions: [
      //   IconButton(
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: Colors.white,
      //     ),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ],
      child: Container(
        decoration: BoxDecoration(color: Constant.backgroundColor),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlineSearchBar(
              textEditingController: _controller,
              onClearButtonPressed: (v) {
                setState(() {
                  searchedResult.clear();
                  searchValue = '';
                });
              },
              onSearchButtonPressed: (value) {
                setState(() {
                  Constant.staticLeagues.forEach((element) {
                    if (element.league.name
                            .replaceAll(' ', '')
                            .toLowerCase()
                            .contains(
                                value.replaceAll(' ', '').toLowerCase()) ||
                        element.country!.name
                            .replaceAll(' ', '')
                            .toLowerCase()
                            .contains(
                                value.replaceAll(' ', '').toLowerCase())) {
                      searchedResult.add(element);
                    }
                  });
                  searchValue = value;
                });
              },
            ),
          ),
          searchedResult.length != 0 || searchValue != ''
              ? Expanded(
                  child: GroupedListView<LeagueDetails, String>(
                    shrinkWrap: true,
                    order: GroupedListOrder.ASC,
                    elements: searchedResult,
                    groupBy: (league) => league.country!.name,
                    groupSeparatorBuilder: (String name) =>
                        LeagueCountryNameSeperator(
                      name: name,
                    ),
                    itemBuilder: (context, LeagueDetails league) => ListTile(
                        key: ValueKey(league.league.id),
                        title: Text(league.league.name),
                        onTap: () {
                          print(league.league.id.toString() + 'id');
                          print('got run ???');
                          widget.selectedFunction(league.league.id);
                        }),
                  ),
                )
              : Expanded(
                  child: GroupedListView<LeagueDetails, String>(
                    shrinkWrap: true,
                    order: GroupedListOrder.ASC,
                    elements: allLeagueList,
                    groupBy: (league) => league.country!.name,
                    groupSeparatorBuilder: (String name) =>
                        LeagueCountryNameSeperator(
                      name: name,
                    ),
                    itemBuilder: (context, LeagueDetails league) => ListTile(
                        key: ValueKey(league.league.id),
                        title: Text(league.league.name),
                        onTap: () {
                          print('still have run');
                          widget.selectedFunction(league.league.id);
                        }),
                  ),
                )
        ]),
      ),
    );
  }
}
