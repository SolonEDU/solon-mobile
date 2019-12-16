class User {
  final int uid;
  final String firstName;
  final String lastName;
  final String email;
  final String nativeLang;

  User({
    this.uid,
    this.firstName,
    this.lastName,
    this.email,
    this.nativeLang,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      email: json['email'],
    );
  }

  Map toUserMap() {
    var map = new Map<String, dynamic>();
    map['firstname'] = firstName;
    map['lastname'] = lastName;
    map['nativeLang'] = nativeLang;
    print("$firstName $lastName $nativeLang");
    print("MAP $map");
    return map;
  }
}
