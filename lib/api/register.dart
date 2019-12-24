class Register {
  final String lang;
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  Register({
    this.lang,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
  });

  // factory Register.fromJson(Map<String, dynamic> json) {
  //   return Register(
  //     lang: json['lang'],
  //     firstName: json['firstname'],
  //     lastName: json['lastname'],
  //     email: json['email'],
  //     password: json['password'],
  //   );
  // }

  Map toRegisterMap() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'password': password,
      'lang': "en",
    };
  }
}
