class User {
  final int uid;
  final String firstName;
  final String lastName;
  final String email;

  User({this.uid, this.firstName, this.lastName, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      email: json['email'],
    );
  }
}
