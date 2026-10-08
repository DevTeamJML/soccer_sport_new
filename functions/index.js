const functions = require("firebase-functions");
const axios = require("axios");
const _ = require("lodash");
const admin = require("firebase-admin");
admin.initializeApp();
var database = admin.database();

var leagueIDs = ["39", "61", "78", "140", "1", "135"];
// const bodyMap = {
//     "notification": {
//         "title": "api testing",
//         "body": "Background message body",
//         "click_action": "FLUTTER_NOTIFICATION_CLICK",
//     },

//     // this message body work
//     "priority": "high",
//     "data": {
//         "body": "Background message testing",
//         "title": 'api testing',
//         "click_action": "FLUTTER_NOTIFICATION_CLICK",
//     },
//     "to": '/topics/39'
// };
//    response = await http.post(Uri.parse(FootballApi.fcmApi),
//       body: jsonEncode(bodyMap),
//       headers: {"Content-Type": 'application/json', "Authorization": "key="});
//   print(response.statusCode.toString());
//
//   if (response.statusCode == 200) {
//     print('is 200' + response.body);

//     // this mean that we are connected to the data base

//     var body = jsonDecode(response.body);
//   }

//publish the function
//firebase deploy --only functions

exports.getEplLive = functions.pubsub
  .schedule("*/1 * * * *")
  .onRun(async (context) => {
    // const options = {
    //     method: "GET",
    //     url: "https://api-football-v1.p.rapidapi.com/v3/fixtures",
    //     params: { live: 'all', timezone: 'Asia/Singapore' },
    //     headers: {
    //         'x-rapidapi-host': "api-football-v1.p.rapidapi.com",
    //         'x-rapidapi-key': "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad"
    //     },
    // };

    const options = {
      method: "GET",
      url: "https://v3.football.api-sports.io/fixtures",
      params: { live: "all", timezone: "Asia/Singapore" },
      headers: {
        "x-apisports-key": "c1d890ace076bef9b4a6199f081ed86a",
      },
    };

    const allowedLeagueIds = [39, 78, 140, 135, 1];

    async function testlog() {
      console.log("Function started");
      const axiosResponse = await axios(options);

      const apiResponse = axiosResponse.data;

      console.log("Result:", JSON.stringify(apiResponse));

      const repsonseList = apiResponse["response"];
      var eplRef = database.ref("62");

      var fixtureValue;
      const fixtures = [];

      (await eplRef.get()).forEach(function (obj) {
        fixtures.push(obj);
      });

      if (axiosResponse !== null) {
        if (repsonseList.length > 0) {
          repsonseList.forEach(function (obj) {
            if (!allowedLeagueIds.includes(obj.league.id)) {
              return;
            }
            // delete obj.events;
            if (fixtures.length > 0) {
              if (
                fixtures.every(
                  (fixture) => obj.fixture.id != fixture.val().fixture["id"],
                )
              ) {
                //* push a new one condtion;
                eplRef.push(obj);
                // if (leagueIDs.includes(obj.league.id)) {
                //     const payload = {
                //         notification: {
                //             title: obj.teams.home.name + ' vs ' + obj.teams.away.name,
                //             body: obj.teams.home.name + "'s match has started",
                //         },
                //         data: {
                //             body: obj.teams.home.name + "'s match has started",
                //             title: obj.teams.home.name + ' vs ' + obj.teams.away.name,
                //             // click_action: "FLUTTER_NOTIFICATION_CLICK",
                //         },
                //     };
                //     // const payload2 = {
                //     //     notification: {
                //     //         title: obj.teams.home.name + ' vs ' + obj.teams.away.name,
                //     //         body: obj.teams.away.name + "'s match has started",
                //     //     },
                //     //     data: {
                //     //         body: obj.teams.away.name + "'s match has started",
                //     //         title: obj.teams.away.name + ' vs ' + obj.teams.away.name,
                //     //         // click_action: "FLUTTER_NOTIFICATION_CLICK",
                //     //     },
                //     // };
                //     const optionsParams = {
                //         priority: 'high',
                //         timeToLive: 60 * 60 * 24
                //     };

                //     admin.messaging().sendToTopic('league' + obj.league.id, payload, optionsParams).then((response) => {
                //         // Response is a message ID string.
                //         console.log('Successfully sent message when new match begin:');

                //     }).catch((error) => {
                //         console.log('error messaging', error);
                //     });
                //     // admin.messaging().sendToTopic('/topics/' + obj.teams.away.id, payload2, optionsParams).then((response) => {
                //     //     // Response is a message ID string.
                //     //     console.log('Successfully sent message when new match begin:');

                //     // }).catch((error) => {
                //     //     console.log('error messaging', error);
                //     // });
                // }
              }
            } else {
              //* push a new one condition
              eplRef.push(obj);
              // const payload = {
              //     notification: {
              //         title: obj.teams.home.name + ' vs ' + obj.teams.away.name,
              //         body: obj.teams.home.name + "'s match has started",
              //     },
              //     data: {
              //         body: obj.teams.home.name + "'s match has started",
              //         title: obj.teams.home.name + ' vs ' + obj.teams.away.name,
              //         // click_action: "FLUTTER_NOTIFICATION_CLICK",
              //     },
              // };
              // const optionsParams = {
              //     priority: 'high',
              //     timeToLive: 60 * 60 * 24
              // };

              // admin.messaging().sendToTopic('/topics/league/' + obj.league.id, payload, optionsParams).then((response) => {
              //     // Response is a message ID string.
              //     console.log('Successfully sent message:');

              // }).catch((error) => {
              //     console.log('error messaging', error);
              // });
            }
          });
          fixtures.forEach(async function (key) {
            //* remove && push

            const fixtureId = key.val().fixture["id"];
            const liveFixture = repsonseList.find(
              (fixture) => fixture.fixture.id == fixtureId,
            );
            console.log(
              "Fixture:",
              fixtureId,
              "Found:",
              liveFixture != null,
              "Status:",
              liveFixture?.fixture?.status?.short ?? "NOT FOUND",
            );

            // repsonseList.every(
            //   (fixture) => fixture.fixture.id != key.val().fixture["id"],
            // )
            //  ["NS", "2H", "FT", "AET", "PEN"].includes(
            //     liveFixture?.fixture?.status?.short,
            //   )
            if (
              repsonseList.every(
                (fixture) => fixture.fixture.id != key.val().fixture["id"],
              )
            ) {
              //* console.log('removed');
              // ["39", "61", "78", "140", "1", "135"]
              const socialResultIds = [1, 39, 78, 135, 140];
              const leagueValue = key.val().league;
              const homeValue = key.val().teams["home"];
              const awayValue = key.val().teams["away"];
              const goalsValue = key.val().goals;

              if (socialResultIds.includes(key.val().league["id"])) {
                const fixturePostBody = {
                  method: "POST",
                  url: "https://soccersport.club/wp-json/wv/v1/fixture_auto_post",
                  params: {
                    league: {
                      name: `${leagueValue["name"]}`,
                    },
                    teams: {
                      home: {
                        name: `${homeValue["name"]}`,
                        logo: `${homeValue["logo"]}`,
                      },
                      away: {
                        name: `${awayValue["name"]}`,
                        logo: `${awayValue["logo"]}`,
                      },
                    },
                    goals: {
                      home: goalsValue["home"],
                      away: goalsValue["away"],
                    },
                    date: key.val().fixture["date"],
                  },
                  headers: {
                    "content-type": "application/json",
                  },
                };

                // axios(fixturePostBody);

                try {
                  console.log(
                    "Posting fixture:",
                    JSON.stringify({
                      league: leagueValue["name"],
                      home: homeValue["name"],
                      away: awayValue["name"],
                      homeGoal: goalsValue["home"],
                      awayGoal: goalsValue["away"],
                      date: key.val().fixture["date"],
                    }),
                  );

                  const wpResponse = await axios(fixturePostBody);

                  console.log(
                    "fixture_auto_post SUCCESS:",
                    wpResponse.status,
                    JSON.stringify(wpResponse.data),
                  );
                } catch (error) {
                  console.log("fixture_auto_post ERROR");

                  if (error.response) {
                    console.log("Status:", error.response.status);
                    console.log("Data:", JSON.stringify(error.response.data));
                  } else {
                    console.log(error.message);
                  }
                }
              }

              eplRef.child(key.key).remove();
            } else {
              //* console.log('update key');
              if (
                repsonseList.some(function (value) {
                  if (
                    value.fixture.id == key.val().fixture["id"] &&
                    !_.isEqual(key.val(), value)
                  ) {
                    fixtureValue = value;

                    if (value.events !== undefined && value.events !== null) {
                      var currentEvent = key.val().events;
                      var updatedEvent = value.events;
                      // const testPlayer = (lastEvent.player !== undefined || lastEvent.player !== null) ? lastEvent.player : null;

                      // if (testPlayer !== null) {
                      //     console.log((testPlayer !== null && (testPlayer.name !== null && testPlayer.name !== undefined)) ? lastEvent.player.name : 'is undefined');

                      // }
                      // if (!(_.isEqual(key.val().goals, value.goals))) {

                      var currentLastEvent =
                        currentEvent != null && currentEvent != undefined
                          ? currentEvent.slice(-1)[0]
                          : null;
                      var updatedLastEvent =
                        updatedEvent != null && updatedEvent != undefined
                          ? updatedEvent.slice(-1)[0]
                          : null;
                      let lastEvent = updatedLastEvent;

                      var currentEventTime =
                        currentLastEvent != null
                          ? currentLastEvent["time"]["elapsed"]
                          : null;
                      var updatedEventTime =
                        updatedLastEvent != null
                          ? updatedLastEvent.time.elapsed
                          : null;
                      if (
                        !_.isEqual(currentEvent, updatedEvent) &&
                        ((currentEventTime == null &&
                          updatedEventTime != null) ||
                          currentEventTime != updatedEventTime)
                      ) {
                        let leagueId = value.league.id;
                        if (
                          lastEvent.detail.toLowerCase() == "normal goal" ||
                          lastEvent.detail.toLowerCase() == "own goal"
                        ) {
                          const playerDetail =
                            lastEvent.player !== undefined &&
                              lastEvent.player !== null
                              ? lastEvent.player
                              : null;
                          // const homeGoal = (value.goals.home != null && value.goals.home !== undefined ) ? (value.goals.home).toString() : "0";
                          // const awayGoal = (value.goals.away != null && value.goals.away !== undefined ) ? (value.goals.away).toString() : "0";
                          // const payloadTitle = value.teams.home.name + " " + homeGoal + '-' + awayGoal + " " +value.teams.away.name;
                          const payloadTitle =
                            value.teams.home.name +
                            " vs " +
                            value.teams.away.name;

                          const payload = {
                            notification: {
                              title: payloadTitle,
                              body:
                                (playerDetail !== null &&
                                  playerDetail.name !== null &&
                                  playerDetail.name !== undefined
                                  ? lastEvent.player.name
                                  : lastEvent.team.name) + " has scored a goal",
                            },
                            data: {
                              body:
                                (playerDetail !== null &&
                                  playerDetail.name !== null &&
                                  playerDetail.name !== undefined
                                  ? lastEvent.player.name
                                  : lastEvent.team.name) + " has scored a goal",
                              title: payloadTitle,
                              // click_action: "FLUTTER_NOTIFICATION_CLICK",
                            },
                          };
                          const optionsParams = {
                            priority: "high",
                            timeToLive: 60 * 60 * 24,
                          };

                          admin
                            .messaging()
                            .sendToTopic(
                              "team" + lastEvent.team.id,
                              payload,
                              optionsParams,
                            )
                            .then((response) => {
                              // Response is a message ID string.
                              //*   console.log('Successfully sent message:');
                            })
                            .catch((error) => {
                              //*   console.log('error team goal messaging', error);
                            });

                          admin
                            .messaging()
                            .sendToTopic(
                              "fixtures" + value.fixture.id,
                              payload,
                              optionsParams,
                            )
                            .then((response) => {
                              // Response is a message ID string.
                              //*    console.log('Successfully sent message:');
                            })
                            .catch((error) => {
                              //*    console.log('error fixtures goal messaging', error);
                            });
                        }

                        if (
                          lastEvent.detail.toLowerCase() == "penalty" ||
                          lastEvent.detail.toLowerCase() ==
                          "penalty confirmed" ||
                          lastEvent.detail.toLowerCase() == "missed penalty" ||
                          lastEvent.detail.toLowerCase() == "goal cancelled"
                        ) {
                          // const playerDetail = (lastEvent.player !== undefined && lastEvent.player !== null) ? lastEvent.player : null;
                          const payloadTitle =
                            value.teams.home.name +
                            " vs " +
                            value.teams.away.name;

                          const teamDetail =
                            lastEvent.team != null &&
                              lastEvent.team.name != undefined
                              ? lastEvent.team.name
                              : "";
                          const description =
                            lastEvent.detail.toLowerCase() == "penalty"
                              ? "has scored a goal"
                              : lastEvent.detail.toLowerCase() ==
                                "penalty confirmed"
                                ? "penalty confirmed"
                                : lastEvent.detail.toLowerCase() ==
                                  "missed penalty"
                                  ? "missed penalty"
                                  : "goal cancelled";
                          const payload = {
                            notification: {
                              title: payloadTitle,
                              body: teamDetail + " " + description,
                            },
                            data: {
                              body: teamDetail + " " + description,
                              title: payloadTitle,
                              // click_action: "FLUTTER_NOTIFICATION_CLICK",
                            },
                          };
                          const optionsParams = {
                            priority: "high",
                            timeToLive: 60 * 60 * 24,
                          };

                          admin
                            .messaging()
                            .sendToTopic(
                              "team" + lastEvent.team.id,
                              payload,
                              optionsParams,
                            )
                            .then((response) => {
                              // Response is a message ID string.
                              //*   console.log('Successfully sent message:');
                            })
                            .catch((error) => {
                              //*    console.log('error team goal messaging', error);
                            });

                          admin
                            .messaging()
                            .sendToTopic(
                              "fixtures" + value.fixture.id,
                              payload,
                              optionsParams,
                            )
                            .then((response) => {
                              // Response is a message ID string.
                              //*     console.log('Successfully sent message:');
                            })
                            .catch((error) => {
                              //*   console.log('error fixtures goal messaging', error);
                            });
                        }

                        if (
                          lastEvent.detail.toLowerCase() == "red card" ||
                          lastEvent.detail.toLowerCase() == "yellow card"
                        ) {
                          const playerDetail =
                            lastEvent.player !== undefined &&
                              lastEvent.player !== null
                              ? lastEvent.player
                              : null;
                          const payloadTitle =
                            value.teams.home.name +
                            " vs " +
                            value.teams.away.name;
                          const payload = {
                            notification: {
                              title: payloadTitle,
                              body:
                                (playerDetail !== null &&
                                  playerDetail.name !== null &&
                                  playerDetail.name !== undefined
                                  ? lastEvent.player.name
                                  : lastEvent.team.name) +
                                " " +
                                lastEvent.detail.toLowerCase(),
                            },
                            data: {
                              body:
                                (playerDetail !== null &&
                                  playerDetail.name !== null &&
                                  playerDetail.name !== undefined
                                  ? lastEvent.player.name
                                  : lastEvent.team.name) +
                                " " +
                                lastEvent.detail.toLowerCase(),
                              title: payloadTitle,
                              // click_action: "FLUTTER_NOTIFICATION_CLICK",
                            },
                          };
                          const optionsParams = {
                            priority: "high",
                            timeToLive: 60 * 60 * 24,
                          };

                          admin
                            .messaging()
                            .sendToTopic(
                              "team" + lastEvent.team.id,
                              payload,
                              optionsParams,
                            )
                            .then((response) => {
                              // Response is a message ID string.
                              //*      console.log('Successfully sent message:');
                            })
                            .catch((error) => {
                              //*     console.log('error team goal messaging', error);
                            });

                          admin
                            .messaging()
                            .sendToTopic(
                              "fixtures" + value.fixture.id,
                              payload,
                              optionsParams,
                            )
                            .then((response) => {
                              // Response is a message ID string.
                              //*     console.log('Successfully sent message:');
                            })
                            .catch((error) => {
                              //*     console.log('error fixtures goal messaging', error);
                            });
                        }

                        // if (lastEvent.detail.toLowerCase() == 'normal goal') {
                        //     console.log('team has score a goal');
                        //     const payload = {
                        //         notification: {
                        //             title: value.home.name,
                        //             body: (lastEvent.player != undefined ? lastEvent.player.name : value.home.name) + 'has scored a goal',
                        //         },
                        //         data: {
                        //             body: (lastEvent.player != undefined ? lastEvent.player.name : value.home.name) + 'has scored a goal',
                        //             title: value.home.name,
                        //             // click_action: "FLUTTER_NOTIFICATION_CLICK",
                        //         },
                        //     };
                        //     const optionsParams = {
                        //         priority: 'high',
                        //         timeToLive: 60 * 60 * 24
                        //     };

                        //     admin.messaging().sendToTopic('/topics/39', payload, optionsParams).then((response) => {
                        //         // Response is a message ID string.
                        //         console.log('Successfully sent message:');

                        //     }).catch((error) => {
                        //         console.log('error messaging', error);
                        //     });
                        // }

                        // if (lastEvent.detail.toLowerCase() == 'own goal') {
                        //     const payload = {
                        //         notification: {
                        //             title: value.home.name,
                        //             body: ((lastEvent.player != undefined && lastEvent.player.name != undefined) ? lastEvent.player.name : value.home.name) + 'has scored a goal',
                        //         },
                        //         data: {
                        //             body: ((lastEvent.player != undefined && lastEvent.player.name != undefined) ? lastEvent.player.name : value.home.name) + 'has scored a goal',
                        //             title: value.home.name,
                        //             // click_action: "FLUTTER_NOTIFICATION_CLICK",
                        //         },
                        //     };
                        //     const optionsParams = {
                        //         priority: 'high',
                        //         timeToLive: 60 * 60 * 24
                        //     };

                        //     admin.messaging().sendToTopic('/topics/39', payload, optionsParams).then((response) => {
                        //         // Response is a message ID string.
                        //         console.log('Successfully sent message:', response);

                        //     }).catch((error) => {
                        //         console.log('error messaging', error);
                        //     });
                        // }
                      }
                    }

                    return true;
                  } else {
                    return false;
                  }
                })
              ) {
                //*  console.log('updated');
                eplRef.child(key.key).set(fixtureValue);
                // eplRef.child(key.key).child('fixture').set(fixtureValue.fixture);
                // eplRef.child(key.key).child('goals').set(fixtureValue.goals);
              }
            }
          });
        } else {
          //*   console.log('no response');
          eplRef.remove();
        }
      }
    }
    var d = new Date();
    let seconds = d.getSeconds();
    //* console.log(seconds.toString);

    await testlog();

    // setTimeout(testlog, 15000 - (seconds * 1000));
    setTimeout(testlog, 30000 - seconds * 1000);
    // setTimeout(testlog, 45000 - (seconds * 1000));
  });

exports.getLeaguesDaily = functions.pubsub
  .schedule("0 0 * * *")
  .onRun(async (context) => {
    const options = {
      method: "GET",
      url: "https://v3.football.api-sports.io/leagues",
      headers: {
        "x-apisports-key": "c1d890ace076bef9b4a6199f081ed86a",
      },
    };

    // const options = {
    //     method: "GET",
    //     url: "https://api-football-v1.p.rapidapi.com/v3/leagues",

    //     headers: {
    //         'x-rapidapi-host': "api-football-v1.p.rapidapi.com",
    //         'x-rapidapi-key': "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad"
    //     },
    // };

    const axiosResponse = await axios(options);

    if (axiosResponse !== null) {
      const apiResponse = axiosResponse.data;

      console.log("LEAGUES : ", JSON.stringify(apiResponse));

      const repsonseList = apiResponse["response"];
      var leaguesRef = database.ref("leagues");

      const leaguesList = [];
      (await leaguesRef.get()).forEach(function (obj) {
        leaguesList.push(obj);
      });
      var leagueValue;
      const seasonsMap = new Map();
      let epl;
      let ligue;
      let bundesliga;
      let laliga;
      let serieA;
      let worldCup;
      if (repsonseList.length > 0) {
        repsonseList.forEach((league) => {
          if (league.seasons && league.seasons.length > 0) {
            const latestSeason = league.seasons[league.seasons.length - 1];
            seasonsMap.set(league.league.id, latestSeason.year);
          }
        });

        console.log("Season Map:", Object.fromEntries(seasonsMap));
        epl =
          repsonseList.find((element) => element.league.id == 39) == undefined
            ? null
            : repsonseList.find((element) => element.league.id == 39);
        ligue =
          repsonseList.find((element) => element.league.id == 61) == undefined
            ? null
            : repsonseList.find((element) => element.league.id == 61);
        bundesliga =
          repsonseList.find((element) => element.league.id == 78) == undefined
            ? null
            : repsonseList.find((element) => element.league.id == 78);
        laliga =
          repsonseList.find((element) => element.league.id == 140) == undefined
            ? null
            : repsonseList.find((element) => element.league.id == 140);
        serieA =
          repsonseList.find((element) => element.league.id == 135) == undefined
            ? null
            : repsonseList.find((element) => element.league.id == 135);
        worldCup =
          repsonseList.find((element) => element.league.id == 1) == undefined
            ? null
            : repsonseList.find((element) => element.league.id == 1);

        if (leaguesList.length > 0) {
          leaguesList.forEach(function (key) {
            if (
              repsonseList.some(function (value) {
                if (
                  value.league.id == key.val().league["id"] &&
                  value != key.val()
                ) {
                  leagueValue = value;
                  let seaonsYear = value.seasons.slice(-1)[0];
                  seasonsMap.set(value.league.id, seaonsYear.year);
                  return true;
                } else {
                  return false;
                }
              })
            ) {
              console.log("updated");
              leaguesRef.child(key.key).set(leagueValue);
            }
          });
        } else {
          leaguesRef.push(epl);
          leaguesRef.push(ligue);
          leaguesRef.push(bundesliga);
          leaguesRef.push(laliga);
          leaguesRef.push(serieA);
          leaguesRef.push(worldCup);
        }

        const hasSerieA = leaguesList.some((x) => x.val()?.league?.id == 135);

        if (!hasSerieA && serieA) {
          console.log("Adding missing Serie A");
          await leaguesRef.push(serieA);
        }
      }
      var teamsRef = database.ref("teams");

      const eplOptions = {
        method: "GET",
        url: "https://v3.football.api-sports.io/teams",
        params: { league: "39", season: seasonsMap.get(39).toString() },
        headers: {
          "x-apisports-key": "c1d890ace076bef9b4a6199f081ed86a",
        },
      };

      // const eplOptions = {
      //     method: "GET",
      //     url: "https://api-football-v1.p.rapidapi.com/v3/teams",
      //     params: { league: '39', season: seasonsMap.get(39).toString() },
      //     headers: {
      //         'x-rapidapi-host': "api-football-v1.p.rapidapi.com",
      //         'x-rapidapi-key': "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad"
      //     },
      // };

      const eplResponse = await axios(eplOptions);
      const eplApiResponse = eplResponse.data;

      const eplResponseList = eplApiResponse["response"];

      const ligueOptions = {
        method: "GET",
        url: "https://v3.football.api-sports.io/teams",
        params: { league: "61", season: seasonsMap.get(61).toString() },
        headers: {
          "x-apisports-key": "c1d890ace076bef9b4a6199f081ed86a",
        },
      };

      // const ligueOptions = {
      //     method: "GET",
      //     url: "https://api-football-v1.p.rapidapi.com/v3/teams",
      //     params: { league: '61', season: seasonsMap.get(61).toString() },
      //     headers: {
      //         'x-rapidapi-host': "api-football-v1.p.rapidapi.com",
      //         'x-rapidapi-key': "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad"
      //     },
      // };

      const ligueResponse = await axios(ligueOptions);
      const ligueApiResponse = ligueResponse.data;

      const ligueResponseList = ligueApiResponse["response"];

      const bundesligaOptions = {
        method: "GET",
        url: "https://v3.football.api-sports.io/teams",
        params: { league: "78", season: seasonsMap.get(78).toString() },
        headers: {
          "x-apisports-key": "c1d890ace076bef9b4a6199f081ed86a",
        },
      };

      // const bundesligaOptions = {
      //   method: "GET",
      //   url: "https://api-football-v1.p.rapidapi.com/v3/teams",
      //   params: { league: "78", season: seasonsMap.get(78).toString() },
      //   headers: {
      //     "x-rapidapi-host": "api-football-v1.p.rapidapi.com",
      //     "x-rapidapi-key":
      //       "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad",
      //   },
      // };

      const bundesligaResponse = await axios(bundesligaOptions);
      const bundesligaApiResponse = bundesligaResponse.data;

      const bundesligaResponseList = bundesligaApiResponse["response"];

      const laligaOptions = {
        method: "GET",
        url: "https://v3.football.api-sports.io/teams",
        params: { league: "140", season: seasonsMap.get(140).toString() },
        headers: {
          "x-apisports-key": "c1d890ace076bef9b4a6199f081ed86a",
        },
      };

      // const laligaOptions = {
      //   method: "GET",
      //   url: "https://api-football-v1.p.rapidapi.com/v3/teams",
      //   params: { league: "140", season: seasonsMap.get(140).toString() },
      //   headers: {
      //     "x-rapidapi-host": "api-football-v1.p.rapidapi.com",
      //     "x-rapidapi-key":
      //       "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad",
      //   },
      // };

      const laligaResponse = await axios(laligaOptions);
      const laligaApiResponse = laligaResponse.data;

      const laligaResponseList = laligaApiResponse["response"];

      const serieAOptions = {
        method: "GET",
        url: "https://v3.football.api-sports.io/teams",
        params: { league: "135", season: seasonsMap.get(135).toString() },
        headers: {
          "x-apisports-key": "c1d890ace076bef9b4a6199f081ed86a",
        },
      };

      const serieAResponse = await axios(serieAOptions);
      const serieAApiResponse = serieAResponse.data;

      const serieAResponseList = serieAApiResponse["response"];

      const worldCupworldCupOptions = {
        method: "GET",
        url: "https://v3.football.api-sports.io/teams",
        params: { league: "1", season: seasonsMap.get(1).toString() },
        headers: {
          "x-apisports-key": "c1d890ace076bef9b4a6199f081ed86a",
        },
      };

      // const worldCupworldCupOptions = {
      //   method: "GET",
      //   url: "https://api-football-v1.p.rapidapi.com/v3/teams",
      //   params: { league: "1", season: seasonsMap.get(1).toString() },
      //   headers: {
      //     "x-rapidapi-host": "api-football-v1.p.rapidapi.com",
      //     "x-rapidapi-key":
      //       "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad",
      //   },
      // };

      const worldCupworldCupResponse = await axios(worldCupworldCupOptions);
      const worldCupworldCupApiResponse = worldCupworldCupResponse.data;

      const worldCupworldCupResponseList =
        worldCupworldCupApiResponse["response"];

      const teamsSnapshot = await teamsRef.get();
      const teamsData = teamsSnapshot.val() || {};

      const leaguesToUpdate = {
        39: eplResponseList,
        61: ligueResponseList,
        78: bundesligaResponseList,
        140: laligaResponseList,
        135: serieAResponseList,
        1: worldCupworldCupResponseList,
      };

      for (const [leagueId, newData] of Object.entries(leaguesToUpdate)) {
        const currentData = teamsData[leagueId];

        if (JSON.stringify(currentData) !== JSON.stringify(newData)) {
          console.log(`Updating teams for league ${leagueId}`);
          await teamsRef.child(leagueId).set(newData);
        }
      }

      // const teamList = [];
      // (await teamsRef.get()).forEach(function (obj) {
      //   teamList.push(obj);
      // });
      // if (teamList.length > 0) {
      //   console.log("more than 0");

      //   if (teamsRef.child(39).get().val() != eplResponseList) {
      //     teamsRef.child(39).set(eplResponseList);
      //   }
      //   if (teamsRef.child(61).get().val() != eplResponseList) {
      //     teamsRef.child(61).set(ligueResponseList);
      //   }
      //   if (teamsRef.child(78).get().val() != eplResponseList) {
      //     teamsRef.child(78).set(bundesligaResponseList);
      //   }
      //   if (teamsRef.child(140).get().val() != eplResponseList) {
      //     teamsRef.child(140).set(laligaResponseList);
      //   }
      //   if (teamsRef.child(1).get().val() != eplResponseList) {
      //     teamsRef.child(1).set(worldCupworldCupResponseList);
      //   }
      // } else {
      //   teamsRef.child(39).push(eplResponseList);
      //   teamsRef.child(61).push(ligueResponseList);
      //   teamsRef.child(78).push(bundesligaResponseList);
      //   teamsRef.child(140).push(laligaResponseList);
      //   teamsRef.child(1).push(worldCupworldCupResponseList);
      // }
    }
  });

// exports.getFixturesByDaily = functions.pubsub.schedule('0 0 * * *').onRun(async (context) => {

//     var fixturesRef = database.ref('fixtures');

//     const fixturesList = [];
//     (await fixturesRef.get()).forEach(function (obj) {
//         fixturesList.push(obj);
//     });

//     const options = {
//         method: "GET",
//         url: "https://api-football-v1.p.rapidapi.com/v3/leagues",

//         headers: {
//             'x-rapidapi-host': "api-football-v1.p.rapidapi.com",
//             'x-rapidapi-key': "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad"
//         },
//     };

//     const axiosResponse = await axios(options);

//     if (axiosResponse !== null) {
//         const apiResponse = axiosResponse.data;

//         const repsonseList = apiResponse['response'];

//         if (repsonseList.length > 0) {
//             epl = repsonseList.find(element => element.league.id == 39) == undefined ? null : repsonseList.find(element => element.league.id == 39);
//             ligue = repsonseList.find(element => element.league.id == 61) == undefined ? null : repsonseList.find(element => element.league.id == 61);
//             bundesliga = repsonseList.find(element => element.league.id == 78) == undefined ? null : repsonseList.find(element => element.league.id == 78);
//             laliga = repsonseList.find(element => element.league.id == 140) == undefined ? null : repsonseList.find(element => element.league.id == 140);
//             worldCup = repsonseList.find(element => element.league.id == 1) == undefined ? null : repsonseList.find(element => element.league.id == 1);

//             await epl.seasons.forEach(async function (obj, i) {
//                 async function test() {
//                     const response = await axios({
//                         method: "GET",
//                         url: "https://api-football-v1.p.rapidapi.com/v3/fixtures",
//                         params: { timezone: 'Asia/Singapore', league: 39, season: obj.year },
//                         headers: {
//                             'x-rapidapi-host': "api-football-v1.p.rapidapi.com",
//                             'x-rapidapi-key': "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad"
//                         },
//                     });
//                     if (response !== null) {
//                         const data = response.data;

//                         const responseList = data['response'];
//                         console.log(responseList);
//                         fixturesRef.child(39).child(obj.year).child('fixtures').set(responseList);
//                     }
//                 }
//                 setTimeout(test, 30000 * i);

//             });
//             // await ligue.seasons.forEach(async function (obj) {
//             //     const response = await axios({
//             //         method: "GET",
//             //         url: "https://api-football-v1.p.rapidapi.com/v3/fixtures",
//             //         params: { timezone: 'Asia/Singapore', league: 61, season: obj.year },
//             //         headers: {
//             //             'x-rapidapi-host': "api-football-v1.p.rapidapi.com",
//             //             'x-rapidapi-key': "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad"
//             //         },
//             //     });
//             //     if (response !== null) {
//             //         const data = response.data;

//             //         const responseList = data['response'];
//             //         fixturesRef.child(61).child(obj.year).child('fixtures').set(responseList);
//             //     }
//             // });
//             // await bundesliga.seasons.forEach(async function (obj) {
//             //     const response = await axios({
//             //         method: "GET",
//             //         url: "https://api-football-v1.p.rapidapi.com/v3/fixtures",
//             //         params: { timezone: 'Asia/Singapore', league: 78, season: obj.year },
//             //         headers: {
//             //             'x-rapidapi-host': "api-football-v1.p.rapidapi.com",
//             //             'x-rapidapi-key': "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad"
//             //         },
//             //     });
//             //     if (response !== null) {
//             //         const data = response.data;

//             //         const responseList = data['response'];
//             //         fixturesRef.child(78).child(obj.year).child('fixtures').set(responseList);
//             //     }
//             // });
//             // await laliga.seasons.forEach(async function (obj) {
//             //     const response = await axios({
//             //         method: "GET",
//             //         url: "https://api-football-v1.p.rapidapi.com/v3/fixtures",
//             //         params: { timezone: 'Asia/Singapore', league: 140, season: obj.year },
//             //         headers: {
//             //             'x-rapidapi-host': "api-football-v1.p.rapidapi.com",
//             //             'x-rapidapi-key': "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad"
//             //         },
//             //     });
//             //     if (response !== null) {
//             //         const data = response.data;

//             //         const responseList = data['response'];
//             //         fixturesRef.child(140).child(obj.year).child('fixtures').set(responseList);
//             //     }
//             // });
//             // await worldCup.seasons.forEach(async function (obj) {
//             //     const response = await axios({
//             //         method: "GET",
//             //         url: "https://api-football-v1.p.rapidapi.com/v3/fixtures",
//             //         params: { timezone: 'Asia/Singapore', league: 1, season: obj.year },
//             //         headers: {
//             //             'x-rapidapi-host': "api-football-v1.p.rapidapi.com",
//             //             'x-rapidapi-key': "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad"
//             //         },
//             //     });
//             //     if (response !== null) {
//             //         const data = response.data;

//             //         const responseList = data['response'];
//             //         fixturesRef.child(1).child(obj.year).child('fixtures').set(responseList);
//             //     }
//             // });

//         }
//     }

// });

exports.espnNews = functions.pubsub
  // .schedule("every 15 minutes")
  .schedule("0 * * * *")
  .timeZone("Asia/Singapore")
  .onRun(async () => {

    const leagues = [
      "fifa.world",  // World Cup
      "eng.1",       // English Premier League
      "ger.1",       // Germany Bundesliga
      "ita.1",       // Italy Serie A
      "esp.1",       // Spanish La Liga
      "fra.1",       // France Ligue 1

      "uefa.champions",     // UEFA Champions League
      "uefa.europa",        // UEFA Europa League
      "uefa.europa.conf",   // UEFA Conference League
      "uefa.nations",       // UEFA Nations League
    ];

    function isTodayInSingapore(dateString) {

      if (!dateString) return false;

      const articleDate = new Date(dateString);

      const today = new Intl.DateTimeFormat("en-CA", {
        timeZone: "Asia/Singapore",
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
      }).format(new Date());

      const articleDay = new Intl.DateTimeFormat("en-CA", {
        timeZone: "Asia/Singapore",
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
      }).format(articleDate);

      return articleDay === today;
    }


    let articles = [];

    // fetch espn
    for (const league of leagues) {

      try {

        const response = await axios.get(
          `https://site.api.espn.com/apis/site/v2/sports/soccer/${league}/news`
        );

        articles.push(
          ...(response.data.articles || [])
        );

      } catch (e) {

        console.log(
          "ESPN Error:",
          league,
          e.message
        );

      }
    }


    // today headlines
    articles = articles.filter(
      (article) =>
        article.type === "HeadlineNews" &&
        isTodayInSingapore(article.published)
    );

    // remove dups
    articles = [
      ...new Map(
        articles.map(
          (article) => [
            article.id,
            article
          ]
        )
      ).values()
    ];


    console.log(
      "Today's unique articles:",
      articles.length
    );

    // send to wordpress
    for (const article of articles) {

      const payload = {

        espn_id:
          article.id,

        title:
          article.headline,

        excerpt:
          article.description,

        image:
          article.images?.[0]?.url ?? "",

        source_url:
          article.links?.web?.href ?? "",

        published:
          article.published,
      };


      console.log(
        "Sending:",
        article.id,
        article.headline
      );


      try {

        await axios.post(
          "https://soccersport.club/wp-json/wv/v1/news_auto_post",
          payload
        );

      } catch (e) {

        console.log(
          "WP Error:",
          article.id,
          e.message
        );

      }
    }


    return null;
  });