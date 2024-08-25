import 'dart:io';
import 'package:cobolt_chatapp/presentation/bloc/chat_bloc.dart';
import 'package:cobolt_chatapp/presentation/pages/HomeScreen/contacts_screen.dart';
import 'package:cobolt_chatapp/presentation/pages/LoginScreen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required Contact contact});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _usernameController;
  var _passwordController;
  Future<bool> _onWillPop() async {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatLogoutState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          } else if (state is ChatAddContactSuccessState) {
            print("ChatAddContactSuccessState triggered");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactsScreen(contacts: [],)),
            );
          }
        },
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
                return const Center(
                    child: Text('Error loading chat messages.'));
              } else if (state is ChatLogoutState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _usernameController.clear();
                  _passwordController.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                });
              }

              return const Center(child: Text('No chat messages.'));
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.read<ChatBloc>().add(NavigateToContactsEvent());
            },
            child: const Icon(Icons.person_add_alt_1_rounded),
          ),
        ),
      ),
    );
  }
}
