class Users {
  final int uid;
  final String firstName;
  final String lastName;
  final String email;

  Users.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        firstName = json['firstname'],
        lastName = json['lastname'],
        email = json['email'];
}
