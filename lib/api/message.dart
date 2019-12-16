class Message {
  final String message;

  Message({this.message});

  factory Message.fromJson(String message) {
    return Message(
      message: message
    );
  }
}