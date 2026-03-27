// AzListView(
//             data: leagueList,
//             itemCount: leagueList.length,
//             itemBuilder: (context, index) {
//               final league = leagueList[index];
//               final tag = league.getSuspensionTag();
//               final offStage = !league.isShowSuspension;
//               return Column(children: [
//                 Offstage(
//                   offstage: offStage,
//                   child: Text(tag),
//                 ),
//                 ListTile(
//                   title: Text(league.league.name),
//                 ),
//               ]);
//             },
//             indexHintBuilder: (context, hint) => Container(
//               alignment: Alignment.center,
//               width: 60,
//               height: 60,
//               decoration:
//                   BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
//               child: Text(hint,
//                   style: TextStyle(
//                     color: Colors.white,
//                   )),
//             ),
//             indexBarMargin: EdgeInsets.all(10),
//             indexBarOptions: IndexBarOptions(
//               needRebuild: true,
//               indexHintAlignment: Alignment.centerRight,
//               indexHintOffset: Offset(-20, 0),
//               selectTextStyle: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//               selectItemDecoration:
//                   BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
//             ),
//           )


//  SuspensionUtil.sortListBySuspensionTag(leagueList);
//     SuspensionUtil.setShowSuspensionStatus(leagueList);