class Message {
  final String message;

  Message({this.message});

  factory Message.fromJson(String json) {
    return Message(
      message: json
    );
  }
}