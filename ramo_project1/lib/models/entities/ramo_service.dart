// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ramo/models/enums.dart';

class RAMOService {
  final int id;
  final String title;
  final ServiceCategory category;
  final int price;
  final int developerId;
  final String details;
  RAMOService({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.developerId,
    required this.details,
  });

  RAMOService copyWith({
    int? id,
    String? title,
    ServiceCategory? category,
    int? price,
    int? developerId,
    String? details,
  }) {
    return RAMOService(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      price: price ?? this.price,
      developerId: developerId ?? this.developerId,
      details: details ?? this.details,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category': category.index,
      'price': price,
      'developerId': developerId,
      'details': details,
    };
  }

  factory RAMOService.fromMap(Map<String, dynamic> map) {
    return RAMOService(
      id: map['Id'] as int,
      title: map['Title'] as String,
      category: ServiceCategory.values[map['Category'] as int],
      price: map['Price'] as int,
      developerId: map['DeveloperId'] as int,
      details: map['Details'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RAMOService.fromJson(String source) =>
      RAMOService.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '$title$category$details)';
  }

  @override
  bool operator ==(covariant RAMOService other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.category == category &&
        other.price == price &&
        other.developerId == developerId &&
        other.details == details;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        category.hashCode ^
        price.hashCode ^
        developerId.hashCode ^
        details.hashCode;
  }
}
