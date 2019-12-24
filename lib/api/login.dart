class Login {
  final String email;
  final String password;

  Login({
    this.email,
    this.password,
  });

  Map toLoginMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}