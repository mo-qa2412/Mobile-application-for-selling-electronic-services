// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Admin {
  int id;
  String name;
  int balance;
  String email;
  String userName;
  String password;
  Admin({
    required this.id,
    required this.name,
    required this.balance,
    required this.email,
    required this.userName,
    required this.password,
  });

  Admin copyWith({
    int? id,
    String? name,
    int? balance,
    String? email,
    String? userName,
    String? password,
  }) {
    return Admin(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Id': id,
      'Name': name,
      'Balance': balance,
      'Email': email,
      'UserName': userName,
      'Password': password,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['ID'] as int,
      name: map['Name'] as String,
      balance: map['Balance'] as int,
      email: map['Email'] as String,
      userName: map['UserName'] as String,
      password: map['Password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) =>
      Admin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Admin(id: $id, name: $name, balance: $balance, email: $email, userName: $userName, password: $password)';
  }

  @override
  bool operator ==(covariant Admin other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.balance == balance &&
        other.email == email &&
        other.userName == userName &&
        other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        balance.hashCode ^
        email.hashCode ^
        userName.hashCode ^
        password.hashCode;
  }
}
