import 'dart:convert';

class UserData {
  final String id;
  final String fullName;
  final String email;

  final String type;
  final String phoneNumber;
  final String address;

  UserData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.type,
    required this.phoneNumber,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'type': type,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['userId'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      type: map['type'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source)['data']);
}
