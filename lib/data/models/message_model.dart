import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final DateTime timestamp;
  final String sender;

  Message({required this.text, required this.timestamp, required this.sender});

  factory Message.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      text: data['message'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      sender: data['sender'],
    );
  }
}
