class User {
  final int id;
  final String email;
  final String nickname;

  User({required this.id, required this.email, required this.nickname});

  User.empty() : id = 0, email = "test@test.com", nickname = "HIBI";

  User copywith({int? id, String? email, String? nickname}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
    );
  }

  User.fromJson(Map<String, dynamic> data)
    : id = data['id'],
      email = data['email'],
      nickname = data["nickname"];

  Map<String, dynamic> toJson() {
    return {"id": id, "email": email, "nickname": nickname};
  }
}
