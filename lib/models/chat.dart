import 'dart:convert';

class Chat {
  final String senderId;
  final String receiverId;
  final String message;
  //final String status;
  final DateTime timestamp;

  Chat({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    //required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      // 'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      // status: map['status'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  factory Chat.fromJson(Map<String, dynamic> map) => Chat.fromMap(map);

  String toJson() => json.encode(toMap());
}
