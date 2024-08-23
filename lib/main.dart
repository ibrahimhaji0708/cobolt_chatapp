import 'package:cobolt_chatapp/presentation/bloc/chat_bloc.dart';
import 'package:cobolt_chatapp/presentation/pages/HomeScreen/chat_screen.dart';
import 'package:cobolt_chatapp/presentation/pages/LoginScreen/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDvFhH7Bx4mMiHO1LqvUcg9dtnCDQ2HS0M",
      appId: "cobolt-chat",
      messagingSenderId: "1008645803520",
      projectId: "cobolt-chat",
    ),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatBloc()),
      ],
      child: const CoboltChat(),
    ),
  );
}

class CoboltChat extends StatefulWidget {
  const CoboltChat({super.key});

  @override
  State<CoboltChat> createState() => _CoboltChatState();
}

class _CoboltChatState extends State<CoboltChat> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cobolt Chat',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 93, 95, 240),
          //hintColor: const Color(0xFFFEF9EB),
        ),
        home: const AuthCheck());
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        } else if (state is UnauthenticatedState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else if (state is ChatErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An error occurred!')),
          );
        }
      },
      child: const LoginPage(),
    );
  }
}
