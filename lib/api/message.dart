class Message {
  final String message;

  Message({this.message});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message']
    );
  }
}