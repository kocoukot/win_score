import 'package:flutter/foundation.dart';

enum SportType {
  FOOTBALL,
  BASKETBALL,
  HOCKEY,
}

extension SportTypeExtension on SportType {
  String get name => describeEnum(this);

  String get sportTypeName {
    switch (this) {
      case SportType.FOOTBALL:
        return 'Football';
      case SportType.BASKETBALL:
        return 'Basketball';
      case SportType.HOCKEY:
        return 'Hockey';
    }
  }

  String get sportTypeIcon {
    switch (this) {
      case SportType.FOOTBALL:
        return 'assets/ic_football.png';
      case SportType.BASKETBALL:
        return 'assets/ic_basketball.png';
      case SportType.HOCKEY:
        return 'assets/ic_hockey.png';
    }
  }
}
