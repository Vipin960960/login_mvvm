const String tableUsers = 'Users';

class UserFields {
  static final List<String> values = [
    id, name, email, password, time
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String email = 'email';
  static const String password = 'password';
  static const String time = 'time';
}

class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final DateTime createdTime;

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.createdTime,
  });

  User copy({
    int? id,
    String? name,
    String? email,
    String? password,
    DateTime? createdTime,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        createdTime: createdTime ?? this.createdTime,
      );

  static User fromJson(Map<String, Object?> json) => User(
        id: json[UserFields.id] as int?,
        name: json[UserFields.name]  as String,
        email: json[UserFields.email]  as String,
        password: json[UserFields.password] as String,
        createdTime: DateTime.parse(json[UserFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.password: password,
        UserFields.name: name,
        UserFields.email: email,
        UserFields.time: createdTime.toIso8601String(),
      };
}
