class OddsModel {
  String homeOdd;
  String awayOdd;
  String drawOdd = '-';

  OddsModel({
    required this.homeOdd,
    required this.awayOdd,
    required this.drawOdd,
  });

  factory OddsModel.fromJson(Map<String, dynamic> json) {
    var draw = '';
    if (json['draw_od'] != null) {
      draw = json['draw_od'];
    } else {
      draw = '-';
    }
    return OddsModel(
      homeOdd: json['home_od'],
      awayOdd: json['away_od'],
      drawOdd: draw,
    );
  }
}
