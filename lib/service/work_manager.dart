import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:win_score/service/notification/notification_service.dart';
import 'package:workmanager/workmanager.dart';

import '../resources/values/app_strings.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("scheduledwork jsonResponse $inputData");

    await BackGroundWork.instance._getBackGroundCounterValue(
      inputData?['gameId'],
      inputData?['leagueName'],
      inputData?['selectedOdd'],
    );
    return Future.value(true);
  });
}

class BackGroundWork {
  BackGroundWork._privateConstructor();

  static final BackGroundWork _instance = BackGroundWork._privateConstructor();

  static BackGroundWork get instance => _instance;

  Future<void> _getBackGroundCounterValue(
    String gameId,
    String leagueName,
    String selectedOdd,
  ) async {
    print(
        "scheduledwork gameId ${gameId} leagueName $leagueName selectedOdd $selectedOdd !");

    // https://spoyer.com/api/get.php?login=ayna&token=12784-OhJLY5mb3BSOx0O&task=eventdata&game_id=5103313
    final queryParametersHome = {
      'login': SPORT_LOGIN,
      'token': SPORT_TOKEN,
      'task': SPORT_TASK_EVENDATA,
      'game_id': "5118614",
    };
    var urlHome =
        Uri.https(SPORT_BASE_URL, '/api/en/get.php', queryParametersHome);

    print("scheduledwork urlHome ${urlHome} leagueName $leagueName ");

    try {
      var response = await http.get(urlHome);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)["results"];
        print("scheduledwork jsonResponse $jsonResponse");
        String matchScore = jsonResponse.first["ss"];
        print("matchScore $matchScore");
        NotificationService()
            .showNotification(gameId, leagueName, matchScore, selectedOdd);
      }
    } catch (e) {
      print("scheduledwork error $e");
    }
  }
}
