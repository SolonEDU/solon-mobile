class User {
  final int uid;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String lang;

  User({
    this.uid,
    this.firstname,
    this.lastname,
    this.email,
    this.password,
    this.lang,
  });

  factory User.fromJson() {
    return User();
  }
}
