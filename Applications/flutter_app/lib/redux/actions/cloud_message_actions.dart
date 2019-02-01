import 'package:flutter/foundation.dart';
import 'package:flutter_app/redux/models/cloud_message.dart';

class ReceivedCloudMessage {
  final CloudMessage notification;

  ReceivedCloudMessage(@required this.notification);
}

class CloudMessageShowSuccessful {
  final CloudMessage notification;

  CloudMessageShowSuccessful(@required this.notification);
}