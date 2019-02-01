class CloudMessage {
  String text;
  String title;

  bool get isCloudMessage => text.isNotEmpty || title.isNotEmpty;

  CloudMessage() {
    text = "";
    title = "";
  }

  static CloudMessage fromDynamic(dynamic data) {
    CloudMessage notification = new CloudMessage();
    dynamic _notification = data['notification'];
    notification.text = _notification['body'];
    notification.title = _notification['title'];
    return notification;
  }

  @override
  String toString() {
    return "!!!${text} !!!${title}";
  }

}