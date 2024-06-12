// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ServiceOrder {
  final int id;
  final int serviceId;
  final int customerId;
  final int isFinished;
  final int likeStatus;
  ServiceOrder({
    required this.id,
    required this.serviceId,
    required this.customerId,
    required this.isFinished,
    required this.likeStatus,
  });

  ServiceOrder copyWith({
    int? id,
    int? serviceId,
    int? customerId,
    int? isFinished,
    int? likeStatus,
  }) {
    return ServiceOrder(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      customerId: customerId ?? this.customerId,
      isFinished: isFinished ?? this.isFinished,
      likeStatus: likeStatus ?? this.likeStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'serviceId': serviceId,
      'customerId': customerId,
      'isFinished': isFinished,
      'likeStatus': likeStatus,
    };
  }

  factory ServiceOrder.fromMap(Map<String, dynamic> map) {
    return ServiceOrder(
      id: map['Id'] as int,
      serviceId: map['ServiceId'] as int,
      customerId: map['CustomerId'] as int,
      isFinished: map['IsFinished'] as int,
      likeStatus: map['LikeStatus'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceOrder.fromJson(String source) =>
      ServiceOrder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ServiceOrder(id: $id, serviceId: $serviceId, customerId: $customerId, isFinished: $isFinished, likeStatus: $likeStatus)';
  }

  @override
  bool operator ==(covariant ServiceOrder other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.serviceId == serviceId &&
        other.customerId == customerId &&
        other.isFinished == isFinished &&
        other.likeStatus == likeStatus;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        serviceId.hashCode ^
        customerId.hashCode ^
        isFinished.hashCode ^
        likeStatus.hashCode;
  }
}
