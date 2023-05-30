class Chat {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  Chat({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });
}
