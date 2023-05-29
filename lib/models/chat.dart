class ChatModel {
  final String sender;
  final String receiver;
  final String message;
  final DateTime timestamp;

  ChatModel({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
  });
}
