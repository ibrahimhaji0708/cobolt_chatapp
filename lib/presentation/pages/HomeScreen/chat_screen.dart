import 'dart:io'; // Import this to use exit function
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<bool> _onWillPop() async {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
            iconSize: 30.0,
            color: Colors.white,
          ),
          title: const Text(
            'Chats',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
              iconSize: 30.0,
              color: Colors.white,
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            //const CategorySelector(),
            Expanded(
              child: Container(
                //height: 500.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF9EB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: const Column(
                  children: <Widget>[
                    // FavouriteContacts(),
                    // RecentChats(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
