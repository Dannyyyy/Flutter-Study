import 'package:flutter_app/redux/actions/counter_actions.dart';

int counterReducer(int currentCount, action) {

  switch(action) {
    case IncrementCountAction:
      currentCount++;
      return currentCount;

    case DecrementCountAction:
      currentCount--;
      return currentCount;

    case ResetCountAction:
      currentCount = 0;
      return currentCount;

    default: return currentCount;
  }
}