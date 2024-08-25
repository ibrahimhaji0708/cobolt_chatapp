import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobolt_chatapp/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final Contact contact;

  const ChatScreen({super.key, required this.contact});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
      ),
      body: StreamBuilder<List<Message>>(
        stream: _getMessages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No messages'));
          }
          final messages = snapshot.data!;
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message.text),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        _sendMessage(_messageController.text);
                        _messageController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  //send and recieve msg
  void _sendMessage(String message) {
    // Example with Firestore
    final chatCollection = FirebaseFirestore.instance.collection('chats');
    chatCollection.add({
      'sender': FirebaseAuth.instance.currentUser?.uid,
      'receiver': widget.contact.phoneNumber,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

// To receive messages, set up a listener for changes in the Firestore collection
  Stream<List<Message>> _getMessages() {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('receiver', isEqualTo: widget.contact.phoneNumber)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromDocument(doc)).toList());
  }
}

class Contact {
  final String name;
  final String phoneNumber;

  Contact({required this.name, required this.phoneNumber});
}
