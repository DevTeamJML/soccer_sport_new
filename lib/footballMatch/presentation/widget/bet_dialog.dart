import 'package:advance_notification/advance_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/team.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../authentication/presentation/widget/login_loading_dialog.dart';

class BetDialog extends StatefulWidget {
  final String predict;
  final FootballMatch match;
  const BetDialog({required this.predict, required this.match});

  @override
  State<BetDialog> createState() => _BetDialogState();
}

class _BetDialogState extends State<BetDialog> {
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();
  final _formKey = GlobalKey<FormState>();

  final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();
  final TextEditingController _controller = TextEditingController();
  late FootballMatch match;

  @override
  void initState() {
    // TODO: implement initState
    match = widget.match;

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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => _customerBloc),
          BlocProvider(create: (context) => _footballMatchBloc),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<FootballMatchBloc, FootballMatchState>(
              bloc: _footballMatchBloc,
              listener: (context, state) {
                // if (state is FavouriteTeamLoaded) {
                //   print('got the team');
                //   setState(() {
                //     favouriteTeam = state.teams;
                //   });
                // }
                // if (state is FavouriteTeamPersisted) {
                //   if (state.teams) {
                //     _FootballMatchBloc.add(GetFavouriteTeamRequest());
                //   }
                // }

                if (state is BetUpdated) {
                  setState(() {
                    _customerBloc
                        .add(GetCustomerDetailsRequest(id: Constant.auth!.id));
                    Constant.betList = state.bet;
                  });
                }

                if (state is BetFixtureFail) {
                  Navigator.of(context).pop();

                  AdvanceSnackBar(
                          mode: Mode.ADVANCE,
                          message: "Your coin amount was less than bet amount",
                          bgColor: Constant.color1)
                      .show(context);
                }
              },
            ),
            BlocListener<CustomerBloc, CustomerState>(
              listener: (context, state) {
                if (state is CustomerDetailsLoaded) {
                  setState(() {
                    Constant.customer = state.customer;
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
          child: Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(color: Constant.backgroundColor),
              height: MediaQuery.of(context).size.height * 0.35,
              // width: MediaQuery.of(context).size.width * 1,
              child: Column(children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Text(
                    widget.match.home.name + ' vs ' + widget.match.away.name,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text(Bet )

                        Text('Your current Coin balances'),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                                // width: MediaQuery.of(context).size.width * 0.04,
                                child: Center(
                                  child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image:
                                          'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                      imageErrorBuilder: (e, o, c) {
                                        return Container();
                                      }),
                                ),
                              ),
                              Text(Constant.customer != null
                                  ? Constant.customer!.diamonds
                                  : '0')
                            ]),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),

                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.isEmpty
                                  ? 'required'
                                  : int.parse(value) < 10
                                      ? 'Must more than 10 coin'
                                      : int.parse(value) > 100
                                          ? 'Must less than 100 coin'
                                          : int.parse(Constant
                                                      .customer!.diamonds) <
                                                  int.parse(value)
                                              ? 'Your total coin amount less than total bet amount'
                                              : null,
                              controller: _controller,
                              onChanged: (v) {
                                setState(() {});
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelText: 'Amount of coins to bet',
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                hintText: 'Amount of coins to bet',
                                hintStyle: TextStyle(color: Colors.white60),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // if (int.parse(Constant.customer!.diamonds )>
                      //     int.parse(_controller.text) ) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return LoginLoadingDialog();
                        },
                      );

                      List<Bet> bet = Constant.betList[0];
                      List<Bet> betLog = Constant.betList[1];
                      bet.add(Bet(
                          id: match.fixture.id,
                          lId: match.league!.id,
                          home: Team(
                            name: match.home.name,
                            logoUrl: match.home.logoUrl,
                            winner: match.home.winner,
                          ),
                          away: Team(
                            name: match.away.name,
                            logoUrl: match.away.logoUrl,
                            winner: match.away.winner,
                          ),
                          status: match.fixture.status.short!,
                          predict: widget.predict,
                          value: int.parse(_controller.text),
                          date: DateTime.now().toLocal()));
                      _footballMatchBloc.add(UpdateBetRequest(
                        id: Constant.auth!.id.toString(),
                        bet: bet,
                        betLog: betLog,
                      ));
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    // width: MediaQuery.of(context).size.height * 0.05,
                    color: _controller.text != '' &&
                            int.parse(_controller.text) > 0
                        ? Colors.red
                        : Colors.grey,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(3),
                    child: Center(
                        child: Text(
                            'Bet ' +
                                (widget.predict == 'Home'
                                    ? widget.match.home.name
                                    : widget.predict == "Away"
                                        ? widget.match.away.name
                                        : 'Draw'),
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
