class Draft {
  String userID;
  String text;
  String title;
  DateTime timeStamp;

  Draft({
    this.userID,
    this.text,
    this.title,
    this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'text': text,
      'title': title,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
    };
  }

  factory Draft.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return Draft(
      userID: map['userID'],
      title: map['title'],
      text: map['text'],
      timeStamp: map['timeStamp'] == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(map['timeStamp']),
    );
  }
}
