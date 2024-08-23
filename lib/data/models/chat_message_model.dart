class ChatMessageModel {
  final String id;
  final String sender;
  final String message;
  final DateTime timestamp;

  ChatMessageModel({
    required this.id,
    required this.sender,
    required this.message,
    required this.timestamp,
  });
}
