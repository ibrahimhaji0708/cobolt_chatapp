import 'dart:io'; // Import this to use exit function
import 'package:cobolt_chatapp/presentation/bloc/chat_bloc.dart';
import 'package:cobolt_chatapp/presentation/pages/LoginScreen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<bool> _onWillPop() async {
    exit(0);
  }

  // void _logout() async {
  //   await FirebaseAuth.instance.signOut();
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(
  //       builder: (context) => const LoginPage(),
  //     ),
  //   );
  // }

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
            IconButton(
              onPressed: () {
                context.read<ChatBloc>().add(LogoutEvent());
              },
              icon: const Icon(Icons.logout),
              iconSize: 30.0,
              color: Colors.white,
            ),
          ],
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatLoadedSuccessState) {
              return ListView.builder(
                itemCount: state.chatMessages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.chatMessages[index].message),
                  );
                },
              );
            } else if (state is ChatErrorState) {
              return const Center(child: Text('Error loading chat messages.'));
            } else if (state is ChatLogoutState) {
              // Navigate to LoginScreen on logout
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              });
            }

            return const Center(child: Text('No chat messages.'));
          },
        ),
      ),
    );
  }
}
