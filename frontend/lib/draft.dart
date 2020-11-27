class Draft {
  String id;
  String text;
  DateTime timeStamp;

  Draft({
    this.id,
    this.text,
    this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
    };
  }

  factory Draft.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return Draft(
      id: map['id'],
      text: map['text'] ?? 'text',
      timeStamp: map['timeStamp'] == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(map['timeStamp']),
    );
  }
}
