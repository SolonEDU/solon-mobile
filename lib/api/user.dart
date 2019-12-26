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
    Map<String, String> _languages = {
      'en': 'English',
      'zh': 'Chinese (Simplified)',
      'zh-CN': 'Chinese (Simplified)',
      'zh-TW': 'Chinese (Traditional)',
      'bn': 'Bengali',
      'ko': 'Korean',
      'ru': 'Russian',
      'ja': 'Japanese',
      'uk': 'Ukrainian',
    };
    return User(
      uid: json['uid'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      email: json['email'],
      nativeLang: _languages[json['lang']],
    );
  }

  Map toUserMap() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'nativeLang': nativeLang,
    };
  }
}
