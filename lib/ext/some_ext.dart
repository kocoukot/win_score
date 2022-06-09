String getPlaceName(Iterable<String> placesList) {
  if (placesList.contains("BetClic")) {
    return "BetClic";
  } else if (placesList.contains("Bet365")) {
    return "Bet365";
  } else if (placesList.contains("Sbobet")) {
    return "Sbobet";
  } else if (placesList.contains("10Bet")) {
    return "10Bet";
  } else if (placesList.contains("BWin")) {
    return "BWin";
  } else {
    return "CloudBet";
  }
}
