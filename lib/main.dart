import 'package:cobolt_chatapp/presentation/pages/LoginScreen/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
  runApp(const CoboltChat());
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
      home: const LoginPage(),
    );
  }
}
