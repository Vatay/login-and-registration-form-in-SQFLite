class Person {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String story;
  final String country;
  final String password;

  Person({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.story,
    required this.country,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'story': story,
      'country': country,
      'password': password,
    };
    return map;
  }

  // Person.fromMap(this.id, this.name, this.phone, this.email, this.story,
  //   this.country, this.password) {
  //   final id = this.id;
  //   final name = this.name;
  //   final phone = this.phone;
  //   final email = this.email;
  //   final story = this.story;
  //   final country = this.country;
  //   final password = this.password;
  // }
}
