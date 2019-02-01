import 'package:flutter_app/redux/actions/cloud_message_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app/redux/models/cloud_message.dart';

final cloudMessageReducer = combineReducers<CloudMessage>([
  new TypedReducer<CloudMessage, ReceivedCloudMessage>(_anyAction),
  new TypedReducer<CloudMessage, CloudMessageShowSuccessful>(_anyAction),
]);

CloudMessage _anyAction(CloudMessage notification, action) {
  return action.notification;
}