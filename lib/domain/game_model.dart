import 'package:win_score/utils/date_util.dart';

class GameModel {
  String gameId;
  String startTime;
  LeagueModel league;
  TeamModel homeTeam;
  TeamModel awayTeam;

  GameModel(
      {required this.gameId,
      required this.startTime,
      required this.league,
      required this.homeTeam,
      required this.awayTeam});

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      gameId: json['game_id'],
      startTime: json['time'],
      league: LeagueModel.fromJson(json['league']),
      homeTeam: TeamModel.fromJson(json['home']),
      awayTeam: TeamModel.fromJson(json['away']),
    );
  }

  String getGameTime() => formatGameTime(startTime);

  String getGameDate() => formatGameDate(startTime);
}

class TeamModel {
  String teamId;
  String teamName;
  String teamImageId;
  String teamCC;

  TeamModel({
    required this.teamId,
    required this.teamName,
    required this.teamImageId,
    required this.teamCC,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
        teamName: json['name'],
        teamId: json['id'],
        teamImageId: json['image_id'],
        teamCC: json['cc']);
  }
}

class LeagueModel {
  String leagueName;
  String leagueId;
  String leagueCC;

  LeagueModel({
    required this.leagueName,
    required this.leagueId,
    required this.leagueCC,
  });

  factory LeagueModel.fromJson(Map<String, dynamic> json) {
    return LeagueModel(
        leagueName: json['name'], leagueId: json['id'], leagueCC: json['cc']);
  }
}

class MemberModel {
  String memberName;
  String memberId;

  MemberModel({
    required this.memberName,
    required this.memberId,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      memberName: json['name'],
      memberId: json['id'],
    );
  }
}
