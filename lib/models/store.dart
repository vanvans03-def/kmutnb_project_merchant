import 'dart:convert';

class Store {
  final String storeId;
  final String user;
  final String storeName;
  final String storeImage;
  final String banner;
  final String phone;
  final String storeDescription;
  final String storeShortDescription;
  final String storeStatus;

  Store({
    required this.storeId,
    required this.user,
    required this.storeName,
    required this.storeImage,
    required this.banner,
    required this.phone,
    required this.storeDescription,
    required this.storeShortDescription,
    required this.storeStatus,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'storeId': storeId});
    result.addAll({'user': user});
    result.addAll({'storeName': storeName});
    result.addAll({'storeImage': storeImage});
    result.addAll({'banner': banner});
    result.addAll({'phone': phone});
    result.addAll({'storeDescription': storeDescription});
    result.addAll({'storeShortDescription': storeShortDescription});
    result.addAll({'storeStatus': storeStatus});

    return result;
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      storeId: map['storeId'] ?? '',
      user: map['user'] ?? '',
      storeName: map['storeName'] ?? '',
      storeImage: map['storeImage'] ?? '',
      banner: map['banner'] ?? '',
      phone: map['phone'] ?? '',
      storeDescription: map['storeDescription'] ?? '',
      storeShortDescription: map['storeShortDescription'] ?? '',
      storeStatus: map['storeStatus'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) => Store.fromMap(json.decode(source));
}
