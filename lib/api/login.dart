class Login {
  final String email;
  final String password;

  Login({
    this.email,
    this.password,
  });

  Map toLoginMap() {
    var map = new Map<String, dynamic>();
    map['email'] = email;
    map['password'] = password;
    print("MAP $map");
    return map;
  }
}