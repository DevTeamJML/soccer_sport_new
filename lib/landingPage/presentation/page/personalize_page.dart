import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:soccer_sport/authentication/presentation/widget/login_loading_dialog.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:soccer_sport/landingPage/presentation/page/home_page.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class PersonalizePage extends StatefulWidget {
  final bool? settingPage;

  const PersonalizePage({
    this.settingPage,
  });

  @override
  State<PersonalizePage> createState() => _PersonalizePageState();
}

class _PersonalizePageState extends State<PersonalizePage> {
  List<int> leaguesId = [];
  List<int> selectedId = [];
  List<LeagueDetails> selectedLeague = [];
  final CustomerBloc customerBloc = serviceLocator<CustomerBloc>();
  List<int> leaguesID = [39, 61, 78, 140, 1];
  Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;

  @override
  void initState() {
    // TODO: implement initState

    if (Constant.customerRewardDetail != null) {
      selectedLeague = Constant.staticLeagues
          .where((element) => Constant.customerRewardDetail!.leagues
              .contains(element.league.id))
          .toList();

      selectedId = selectedLeague.map((e) => e.league.id).toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () async {
                if (widget.settingPage != null && widget.settingPage!) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();

                  Constant.pageController!.jumpToPage(0);
                }
              },
            ),
          ),
          body: BlocProvider(
            create: (context) => customerBloc,
            child: BlocListener<CustomerBloc, CustomerState>(
              listener: (context, state) {
                if (state is PersonalizeUpdated) {
                  setState(() {
                    Constant.customerRewardDetail = state.success;

                    Navigator.of(context).pop();

                    if (widget.settingPage != null && widget.settingPage!) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/splash', (Route<dynamic> route) => false);
                    } else {
                      Navigator.of(context).pop();

                      Constant.pageController!.jumpToPage(0);
                    }
                  });
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Text(
                      "Select your league preferences",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                          vertical: MediaQuery.of(context).size.height * 0.005),
                      child: Text(
                        "(England Premier League, La Liga, Bundesliga, Ligue1 are default)",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ListView(children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: MultiSelectChipField<LeagueDetails>(
                              title: Text(""),
                              scroll: false,
                              searchIcon:
                                  Icon(Icons.search, color: Colors.white),
                              searchHint: "Search league name",
                              searchHintStyle: TextStyle(color: Colors.white),
                              searchTextStyle: TextStyle(color: Colors.white),
                              searchable: true,
                              icon: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),

                              validator: (v) {
                                if (v != null && v.length > 5) {
                                  return "Cannot more than 5";
                                } else {
                                  return null;
                                }
                              },
                              items: Constant.staticLeagues
                                  .where((element) =>
                                      !(leaguesID.contains(element.league.id)))
                                  .map((e) => MultiSelectItem(
                                      e,
                                      (e.country != null
                                              ? e.country!.name
                                              : '') +
                                          " " +
                                          e.league.name))
                                  .toList(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              selectedChipColor: Constant.color1,
                              selectedTextStyle: TextStyle(color: Colors.white),
                              closeSearchIcon:
                                  Icon(Icons.close, color: Colors.white),

                              itemBuilder: (MultiSelectItem<LeagueDetails?>
                                      item,
                                  FormFieldState<List<LeagueDetails?>> state) {
                                // return your custom widget here
                                final e = item.value!;
                                final name =
                                    (e.country != null ? e.country!.name : '') +
                                        " " +
                                        e.league.name;
                                // return InkWell(
                                //   onTap: () {
                                //     _selectedAnimals.contains(item.value)
                                // 	      ? _selectedAnimals.remove(item.value)
                                // 	      : _selectedAnimals.add(item.value);
                                //     state.didChange(_selectedAnimals);
                                //     _multiSelectKey.currentState.validate();
                                //   },
                                //   child: Text(item.value.name),
                                // );

                                return Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(0),
                                  padding: const EdgeInsets.all(2.0),
                                  child: ChoiceChip(
                                    selected: selectedLeague.contains(e),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15.0),
                                        bottom: Radius.circular(15.0),
                                      ),
                                    ),
                                    label: Container(
                                      width: double.infinity,
                                      child: Text(
                                        name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    backgroundColor: Constant.backgroundColor,
                                    selectedColor: Constant.color1,
                                    avatar: selectedLeague.contains(e)
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          )
                                        : null,
                                    onSelected: selectedLeague.length < 5
                                        ? (_) {
                                            if (_) {
                                              setState(() {
                                                selectedLeague.add(item.value!);
                                                selectedId
                                                    .add(item.value!.league.id);
                                              });
                                            } else {
                                              setState(() {
                                                selectedLeague
                                                    .remove(item.value);
                                                selectedId.remove(
                                                    item.value!.league.id);
                                              });
                                            }
                                          }
                                        : null,
                                  ),
                                );
                              },

                              // listType: MultiSelectListType.CHIP,
                              onTap: null,
                            ),
                          ),
                        ]),
                        // child: ListView.builder(itemBuilder: ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.22 +
                          MediaQuery.of(context).padding.bottom,
                      padding: EdgeInsets.only(
                          top: 8,
                          bottom: MediaQuery.of(context).size.height * 0.03,
                          left: 8,
                          right: 8),
                      child: Column(
                        children: [
                          Text("Selected leagues [ ${selectedId.length} / 5 ]",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17)),
                          // ListView.builder(
                          //   itemCount: Constant.staticLeagues.length,
                          //   itemBuilder: ((context, index) {

                          //     return
                          //   }),
                          // ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: selectedLeague.length,
                                itemBuilder: ((context, index) {
                                  final e = selectedLeague[index];
                                  final name = (e.country != null
                                          ? e.country!.name
                                          : '') +
                                      " " +
                                      e.league.name;

                                  return Stack(
                                    alignment: AlignmentDirectional.topEnd,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(0),
                                        padding: const EdgeInsets.all(2.0),
                                        child: ChoiceChip(
                                          selected: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(15.0),
                                              bottom: Radius.circular(15.0),
                                            ),
                                          ),
                                          label: Container(
                                            child: Text(
                                              name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          backgroundColor: Constant.color1,
                                          selectedColor: Constant.color1,
                                          onSelected: (_) {},
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedLeague.remove(e);
                                              selectedId.remove(e.league.id);
                                            });
                                          },
                                          // child: Icon(
                                          //   Icons.exit_to_app,
                                          //   color: Colors.white,
                                          // ),
                                          child: Container(
                                            // decoration: BoxDecoration(
                                            //                     shape: BoxShape.circle,

                                            // )
                                            child: Opacity(
                                              opacity: 0.7,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  CupertinoIcons
                                                      .clear_circled_solid,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Constant.color2,
                                  ),
                                  onPressed: () {
                                    if (selectedId.length > 0) {
                                      if (Constant.customerRewardDetail !=
                                              null &&
                                          (unOrdDeepEq(
                                              Constant.customerRewardDetail!
                                                  .leagues,
                                              selectedId))) {
                                        print('is same league list');
                                        if (widget.settingPage != null &&
                                            widget.settingPage!) {
                                          Navigator.of(context).pop();
                                        } else {
                                          Navigator.of(context).pop();

                                          Constant.pageController!
                                              .jumpToPage(0);
                                        }
                                      } else {
                                        print('no same league list');

                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return LoginLoadingDialog();
                                          },
                                        );
                                        customerBloc.add(
                                            UpdatePersonalizeRequest(
                                                id: Constant.auth!.id
                                                    .toString(),
                                                leagues: selectedId));
                                      }
                                    } else {
                                      if (Constant.customerRewardDetail !=
                                              null &&
                                          Constant.customerRewardDetail!.leagues
                                                  .length >
                                              0) {
                                        print(
                                            'no selected and got store league before');
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return LoginLoadingDialog();
                                          },
                                        );
                                        customerBloc.add(
                                            UpdatePersonalizeRequest(
                                                id: Constant.auth!.id
                                                    .toString(),
                                                leagues: []));
                                      } else {
                                        print('no selected');

                                        if (widget.settingPage != null &&
                                            widget.settingPage!) {
                                          Navigator.of(context).pop();
                                        } else {
                                          Navigator.of(context).pop();

                                          Constant.pageController!
                                              .jumpToPage(0);
                                        }
                                      }
                                    }
                                  },
                                  child: Text("Confirm",
                                      style: TextStyle(color: Colors.black)))
                            ],
                          ),

                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
