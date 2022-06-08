import 'package:flutter/foundation.dart';

enum SelectionType{
  NEXT,
  PREVIOUS
}


extension SelectionArrowExtension on SelectionType{

  String get name => describeEnum(this);


  String get arrowTypeIcon {
    switch (this) {
      case SelectionType.NEXT:
        return 'assets/ic_next.png';
      case SelectionType.PREVIOUS:
        return 'assets/ic_prev.png';
    }
  }

}

