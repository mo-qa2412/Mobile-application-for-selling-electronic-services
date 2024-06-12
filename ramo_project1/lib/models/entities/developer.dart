// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Developer {
  int id;
  String name;
  String password;
  int balance;
  String phoneNumber;
  String email;
  String userName;
  bool hasFinishedSignUp;
  String? skills;
  String? contactEmail;
  Developer({
    required this.id,
    required this.name,
    required this.password,
    required this.balance,
    required this.phoneNumber,
    required this.email,
    required this.userName,
    this.hasFinishedSignUp = false,
    this.skills,
    this.contactEmail,
  });

  Developer copyWith({
    int? id,
    String? name,
    String? password,
    int? balance,
    String? phoneNumber,
    String? email,
    String? userName,
    bool? hasFinishedSignUp,
    String? skills,
    String? contactEmail,
  }) {
    return Developer(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      balance: balance ?? this.balance,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      hasFinishedSignUp: hasFinishedSignUp ?? this.hasFinishedSignUp,
      skills: skills ?? this.skills,
      contactEmail: contactEmail ?? this.contactEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'password': password,
      'balance': balance,
      'phoneNumber': phoneNumber,
      'email': email,
      'userName': userName,
      'hasFinishedSignUp': hasFinishedSignUp,
      'skills': skills,
      'contactEmail': contactEmail,
    };
  }

  factory Developer.fromMap(Map<String, dynamic> map) {
    return Developer(
      id: map['Id'] as int,
      name: map['Name'] as String,
      password: map['Password'] as String,
      balance: map['Balance'] as int,
      phoneNumber: map['PhoneNumber'] as String,
      email: map['Email'] as String,
      userName: map['UserName'] as String,
      hasFinishedSignUp: (map['HasFinishedSignUp'] as int) == 1,
      skills: map['Skills'] != null ? map['Skills'] as String : null,
      contactEmail:
          map['ContactEmail'] != null ? map['ContactEmail'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Developer.fromJson(String source) =>
      Developer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '$name$phoneNumber$email$userName$skills$contactEmail)';
  }

  @override
  bool operator ==(covariant Developer other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.password == password &&
        other.balance == balance &&
        other.phoneNumber == phoneNumber &&
        other.email == email &&
        other.userName == userName &&
        other.hasFinishedSignUp == hasFinishedSignUp &&
        other.skills == skills &&
        other.contactEmail == contactEmail;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        password.hashCode ^
        balance.hashCode ^
        phoneNumber.hashCode ^
        email.hashCode ^
        userName.hashCode ^
        hasFinishedSignUp.hashCode ^
        skills.hashCode ^
        contactEmail.hashCode;
  }
}
