import 'dart:convert';

class UserData {
  final String userId;
  final String fullName;
  final String email;

  final String type;
  final String phoneNumber;
  final String address;

  UserData({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.type,
    required this.phoneNumber,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'fullName': fullName,
      'email': email,
      'type': type,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      userId: map['userId'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      type: map['type'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
    );
  }

  factory UserData.fromJson(Map<String, dynamic> map) => UserData.fromMap(map);

  String toJson() => json.encode(toMap());
}
