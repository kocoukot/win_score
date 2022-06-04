class GameModel {
  String gameId;
  String leagueName;
  String startTime;
  String startDate;
  TeamModel homeTeam;
  TeamModel awayTeam;

  GameModel(
      {required this.gameId,
      required this.leagueName,
      required this.startTime,
      required this.startDate,
      required this.homeTeam,
      required this.awayTeam});

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      gameId: json['gameId'],
      leagueName: json['leagueName'],
      startTime: json['startTime'],
      startDate: json['startDate'],
      homeTeam: TeamModel.fromJson(json['homeTeam']),
      awayTeam: TeamModel.fromJson(json['awayTeam']),
    );
  }
}

class TeamModel {
  String teamName;
  String teamLogo;
  String teamFlag;
  List<String> teamLineup;

  TeamModel({
    required this.teamName,
    required this.teamLogo,
    required this.teamFlag,
    required this.teamLineup,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
        teamName: json['teamName'],
        teamLogo: json['teamLogo'],
        teamFlag: json['teamFlag'],
        teamLineup: List.from(json['teamLineup']));
  }
}
