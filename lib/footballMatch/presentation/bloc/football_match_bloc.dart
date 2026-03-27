import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/core/util/failure_message.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_ranking/bet_ranking.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_injuries.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_lineups.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_stats_info.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/predict.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/bet_won_update.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/check_fixture_on_live.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/check_match_tutorial.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/filter_fixture_by_round.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_all_incoming_match.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_all_match.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_all_match_by_league.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_bet_log.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_bet_ranking.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_fixture_by_league.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_fixture_rounds.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_fixtures_current_round.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_incoming_fixtures_by_league.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_incoming_live_match.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_match_event.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_match_injuries.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_match_lineups.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_match_predict.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_match_stats_info.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/persist_match_tutorial.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/update_bet.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/update_finished_bet.dart';

import '../../../core/error/failure.dart';
import '../../domain/entities/team_info/player_stats_info.dart';
import '../../domain/entities/team_info/player_stats_info_v2.dart';
import '../../domain/usecase/get_fixture_between_dates.dart';
import '../../domain/usecase/get_fixtures_by_team.dart';
import '../../domain/usecase/get_player_stats_info.dart';

part 'football_match_event.dart';
part 'football_match_state.dart';

class FootballMatchBloc extends Bloc<FootballMatchEvent, FootballMatchState> {
  final GetAllMatch getAllMatch;
  final GetFixtureByLeague getFixtureByLeague;
  final GetAllIncomingMatch getAllIncomingMatch;
  final GetIncomingFixtureByLeague getIncomingFixtureByLeague;
  final GetFixtureByRound getFixtureByRound;
  final GetFixtureRounds getFixtureRounds;
  final GetFixturesCurrentRound getFixturesCurrentRound;
  final CheckFixtureOnLive checkFixtureOnLive;
  final GetIncomingLiveMatch getIncomingLiveMatch;
  final GetFixtureBetweenDates getFixtureBetweenDates;
  final GetAllMatchByLeague getAllMatchByLeague;
  final GetBetLog getBetLog;
  final UpdateBet updateBet;
  final BetWonUpdate betWonUpdate;
  final UpdateFinishedBet updateFinishedBet;
  final PersistMatchTutorial persistMatchTutorial;
  final CheckMatchTutorial checkMatchTutorial;
  final GetBetRanking getBetRanking;
  final GetMatchLineups getMatchLineups;
  final GetMatchInjuries getMatchInjuries;
  final GetMatchEvent getMatchEvent;
  final GetMatchStatsInfo getMatchStatsInfo;
  final GetMatchPredict getMatchPredict;
  final GetFixturesByTeam getFixturesByTeam;
  final GetPlayerStatInfo getPlayerStatsInfo;
  FootballMatchBloc({
    required GetAllMatch getAllMatch,
    required GetAllIncomingMatch getAllIncomingMatch,
    required GetFixtureByLeague getFixtureByLeague,
    required GetIncomingFixtureByLeague getIncomingFixtureByLeague,
    required GetFixtureByRound getFixtureByRound,
    required GetFixtureRounds getFixtureRounds,
    required GetFixturesCurrentRound getFixturesCurrentRound,
    required CheckFixtureOnLive checkFixtureOnLive,
    required GetIncomingLiveMatch getIncomingLiveMatch,
    required GetFixtureBetweenDates getFixtureBetweenDates,
    required GetAllMatchByLeague getAllMatchByLeague,
    required GetBetLog getBetLog,
    required UpdateBet updateBet,
    required BetWonUpdate betWonUpdate,
    required UpdateFinishedBet updateFinishedBet,
    required CheckMatchTutorial checkMatchTutorial,
    required PersistMatchTutorial persistMatchTutorial,
    required GetBetRanking getBetRanking,
    required GetMatchStatsInfo getMatchStatsInfo,
    required GetMatchLineups getMatchLineups,
    required GetMatchInjuries getMatchInjuries,
    required GetMatchEvent getMatchEvent,
    required GetMatchPredict getMatchPredict,
    required GetFixturesByTeam getFixturesByTeam,
    required GetPlayerStatInfo getPlayerStatsInfo,
  })  : getAllMatch = getAllMatch,
        getFixtureByLeague = getFixtureByLeague,
        getAllIncomingMatch = getAllIncomingMatch,
        getIncomingFixtureByLeague = getIncomingFixtureByLeague,
        getFixtureByRound = getFixtureByRound,
        getFixtureRounds = getFixtureRounds,
        getFixturesCurrentRound = getFixturesCurrentRound,
        checkFixtureOnLive = checkFixtureOnLive,
        getIncomingLiveMatch = getIncomingLiveMatch,
        getFixtureBetweenDates = getFixtureBetweenDates,
        getAllMatchByLeague = getAllMatchByLeague,
        getBetLog = getBetLog,
        updateBet = updateBet,
        betWonUpdate = betWonUpdate,
        updateFinishedBet = updateFinishedBet,
        persistMatchTutorial = persistMatchTutorial,
        checkMatchTutorial = checkMatchTutorial,
        getBetRanking = getBetRanking,
        getMatchStatsInfo = getMatchStatsInfo,
        getMatchLineups = getMatchLineups,
        getMatchInjuries = getMatchInjuries,
        getMatchEvent = getMatchEvent,
        getMatchPredict = getMatchPredict,
        getFixturesByTeam = getFixturesByTeam,
        getPlayerStatsInfo = getPlayerStatsInfo,
        super(FootballMatchInitial());

  @override
  Stream<FootballMatchState> mapEventToState(
    FootballMatchEvent event,
  ) async* {
    if (event is GetAllMatchRequest) {
      yield LoadAllFootballMatch();
      final failureOrFootballMatches = await getAllMatch(NoParams());
      yield failureOrFootballMatches.fold(
        (failure) =>
            FootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => FootballMatchesLoaded(footballMatches: matches),
      );
    }

    if (event is GetAllIncomingMatchRequest) {
      yield LoadAllIncomingFootballMatch();
      final failureOrFootballMatches = await getAllMatch(NoParams());
      yield failureOrFootballMatches.fold(
        (failure) =>
            IncomingFootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => IncomingFootballMatchesLoaded(footballMatches: matches),
      );
    }

    if (event is GetFixturesByLeagueRequest) {
      yield LoadAllFootballMatch();
      final failureOrFootballMatches = await getFixtureByLeague(
          GetFixtureByLeagueParams(id: event.leagueId, season: event.season));
      yield failureOrFootballMatches.fold(
        (failure) =>
            FootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => FootballMatchesLoaded(footballMatches: matches),
      );
    }

    if (event is GetIncomingFixturesByLeagueRequest) {
      yield LoadAllFootballMatch();
      final failureOrFootballMatches = await getIncomingFixtureByLeague(
          GetIncomingFixtureByLeagueParams(
              id: event.leagueId, season: event.season));
      yield failureOrFootballMatches.fold(
        (failure) =>
            FootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => FootballMatchesLoaded(footballMatches: matches),
      );
    }

    if (event is GetFixtureByRoundRequest) {
      yield LoadCurrentRoundFixtures();
      final failureOrFootballMatches = await getFixtureByRound(
          GetFixtureByRoundParams(
              round: event.round, id: event.leagueId, season: event.season));
      yield failureOrFootballMatches.fold(
        (failure) =>
            FootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => CurrentRoundFixturesLoaded(
            footballMatches: matches, currentRound: event.round),
      );
    }
    if (event is GetFixtureRoundRequest) {
      yield LoadFixtureRounds();
      final failureOrFootballMatches = await getFixtureRounds(
          GetFixtureRoundsParams(id: event.leagueId, season: event.season));
      yield failureOrFootballMatches.fold(
        (failure) =>
            FootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => FixtureRoundsLoaded(footballMatches: matches),
      );
    }

    if (event is GetFixturesCurrentRoundRequest) {
      yield LoadFixturesCurrentRound();
      final failureOrFootballMatches = await getFixturesCurrentRound(
          GetFixturesCurrentRoundParams(
              id: event.leagueId, season: event.season));
      yield failureOrFootballMatches.fold(
        (failure) =>
            FootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => FixturesCurrentRoundLoaded(footballMatches: matches),
      );
    }

    if (event is CheckFixtureOnLiveRequest) {
      yield CheckingFixtureOnLive();
      final failureOrFootballMatches = await checkFixtureOnLive(
          CheckFixtureOnLiveParams(ongoingMatch: event.match));
      yield failureOrFootballMatches.fold(
        (failure) =>
            FootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => FixtureOnLiveChecked(footballMatches: matches),
      );
    }

    if (event is GetIncomingLiveMatchRequest) {
      yield LoadIncomingLiveMatch();
      final failureOrFootballMatches = await getIncomingLiveMatch(NoParams());
      yield failureOrFootballMatches.fold(
        (failure) =>
            FootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => IncomingLiveMatchLoaded(footballMatches: matches),
      );
    }

    if (event is GetFixtureBetweenDatesRequest) {
      yield LoadGetFixtureBetweenDates();
      final failureOrFootballMatches = await getFixtureBetweenDates(
          GetFixtureBetweenDatesParams(ids: event.ids));
      yield failureOrFootballMatches.fold(
        (failure) =>
            FootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => GetFixtureBetweenDatesLoaded(footballMatches: matches),
      );
    }
    if (event is GetAllMatchByLeagueRequest) {
      yield GettingAllMatchByLeague();
      final failureOrFootballMatches = await getAllMatchByLeague(
          GetAllMatchByLeagueParams(id: event.leagueId, season: event.season));
      yield failureOrFootballMatches.fold(
        (failure) =>
            FootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => AllMatchByLeagueGet(footballMatches: matches),
      );
    }

    if (event is GetBetLogRequest) {
      yield GettingBetLog();
      final failureOrFootballMatches =
          await getBetLog(GetBetLogParams(id: event.id));
      yield failureOrFootballMatches.fold(
        (failure) =>
            FootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => BetLogGet(bet: matches),
      );
    }
    if (event is UpdateBetRequest) {
      yield UpdatingBet();
      final failureOrFootballMatches = await updateBet(
          UpdateBetParams(id: event.id, bet: event.bet, betLog: event.betLog));
      yield failureOrFootballMatches.fold(
        (failure) {
          if (failure.runtimeType is NotEnugCoinFailure ||
              failure.runtimeType == NotEnugCoinFailure) {
            return BetFixtureFail();
          } else {
            return FootballMatchesError(message: Failure2Message.map(failure));
          }
        },
        (matches) => BetUpdated(bet: matches),
      );
    }

    if (event is UpdateFinishedBetRequest) {
      yield UpdatingBet();
      final failureOrFootballMatches = await updateFinishedBet(
          UpdateFinishedBetParams(
              id: event.id, bet: event.bet, betLog: event.betLog));
      yield failureOrFootballMatches.fold(
        (failure) =>
            FootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => BetUpdated(bet: matches),
      );
    }

    if (event is BetWonUpdateRequest) {
      yield BetWonUpdating();
      final failureOrFootballMatches = await betWonUpdate(BetWonUpdateParams(
          id: event.id, value: event.value, data: event.data));
      yield failureOrFootballMatches.fold(
        (failure) =>
            FootballMatchesError(message: Failure2Message.map(failure)),
        (matches) => BetWonUpdated(bet: matches),
      );
    }

    if (event is CheckMatchTutorialRequest) {
      yield CheckingMatchTutorial();
      final failureOrFootballMatches = await checkMatchTutorial(NoParams());
      yield failureOrFootballMatches.fold(
          (failure) =>
              FootballMatchesError(message: Failure2Message.map(failure)),
          (matches) => MatchTutorialChecked(bet: matches));
    }

    if (event is PersistMatchTutorialRequest) {
      yield PersistingMatchTutorial();
      final failureOrFootballMatches = await persistMatchTutorial(NoParams());
      yield failureOrFootballMatches.fold(
          (failure) =>
              FootballMatchesError(message: Failure2Message.map(failure)),
          (matches) => MatchTutorialPersisted(bet: matches));
    }

    if (event is GetBetRankingRequest) {
      yield LoadingBetRank();
      final failureOrFootballMatches = await getBetRanking(NoParams());
      yield failureOrFootballMatches.fold(
          (failure) =>
              FootballMatchesError(message: Failure2Message.map(failure)),
          (matches) => BetRankLoaded(bet: matches));
    }

    if (event is GetMatchStatsInfoRequest) {
      yield GettingMatchStatsInfo();
      final failureOrFootballMatches =
          await getMatchStatsInfo(GetMatchStatsInfoParams(id: event.id));
      yield failureOrFootballMatches.fold(
          (failure) =>
              FootballMatchesError(message: Failure2Message.map(failure)),
          (matches) => MatchStatsInfoGet(stats: matches));
    }

    if (event is GetMatchLineupsRequest) {
      yield GettingMatchLineups();
      final failureOrFootballMatches =
          await getMatchLineups(GetMatchLineupsParams(id: event.id));
      yield failureOrFootballMatches.fold(
          (failure) =>
              FootballMatchesError(message: Failure2Message.map(failure)),
          (matches) => MatchLineupsGet(stats: matches));
    }

    if (event is GetMatchInjuriesRequest) {
      yield GettingMatchInjuries();
      final failureOrFootballMatches =
          await getMatchInjuries(GetMatchInjuriesParams(id: event.id));
      yield failureOrFootballMatches.fold(
          (failure) =>
              FootballMatchesError(message: Failure2Message.map(failure)),
          (matches) => MatchInjuriesGet(stats: matches));
    }

    if (event is GetMatchEventRequest) {
      yield GettingMatchEvent();
      final failureOrFootballMatches =
          await getMatchEvent(GetMatchEventParams(id: event.id));
      yield failureOrFootballMatches.fold(
          (failure) =>
              FootballMatchesError(message: Failure2Message.map(failure)),
          (matches) => MatchEventGet(stats: matches));
    }

    if (event is GetMatchPredictRequest) {
      yield GettingMatchPredict();
      final failureOrFootballMatches =
          await getMatchPredict(GetMatchPredictParams(id: event.id));
      yield failureOrFootballMatches.fold(
          (failure) =>
              FootballMatchesError(message: Failure2Message.map(failure)),
          (matches) => MatchPredictGet(stats: matches));
    }

    if (event is GetFixtureByTeamRequest) {
      yield LoadFixturesByTeam();
      final failureOrFootballMatches = await getFixturesByTeam(
          GetFixturesByTeamParams(id: event.id, season: event.season));
      yield failureOrFootballMatches.fold(
          (failure) =>
              FootballMatchesError(message: Failure2Message.map(failure)),
          (matches) => FixturesByTeamLoaded(match: matches));
    }

    if (event is GetPlayerStatsInfoRequest) {
      yield LoadPlayerStatsInfo();
      final failureOrFootballMatches = await getPlayerStatsInfo(
          GetPlayerStatInfoParams(id: event.id, season: event.season));
      yield failureOrFootballMatches.fold(
          (failure) =>
              FootballMatchesError(message: Failure2Message.map(failure)),
          (matches) => PlayerStatsInfoLoaded(match: matches));
    }
  }
}

// Stream<ArticleState> _eitherLoadedOrErrorState(
//   Either<Failure, List<Article>> failureOrArticles,
// ) async* {
//   yield failureOrArticles.fold(
//     (failure) => ArticleError(message: Failure2Message.map(failure)),
//     (articles) => ArticleLoaded(articles: articles),
//   );
// }


 