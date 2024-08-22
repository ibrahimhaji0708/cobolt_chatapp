import 'package:cobolt_chatapp/presentation/pages/LoginScreen/signin_page.dart';
import 'package:cobolt_chatapp/core/constants/constants.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 228, 241, 255),
            Color.fromARGB(240, 179, 179, 179),
            Color.fromARGB(255, 117, 122, 128),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 31, 33, 133),
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout_rounded),
              ),
              const SizedBox(width: 8.0),
              // Text('Exit'),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 45.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 10.7),
                      ClipOval(
                        child: Image.asset(
                          'assets/images/CoboltChat.jpeg',
                          height: 120,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'COBOLT',
                        style: kLabelStyle.copyWith(
                            fontSize: 44, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 20.0),
                  child: Text(
                    'Cobolt Chat allows you to reach people securely in peer to peer through a fully distributed network. ',
                    style: kHintTextStyle.copyWith(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 30),
                //
                CustomButton(
                  leftIcon: Icons.person,
                  text: 'Create a Cobolt Account',
                  rightIcon: Icons.arrow_forward,
                  kBgColor: const Color.fromARGB(255, 31, 33, 133),
                  kTxtColor: Colors.white,
                  route: const SignIn(),
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                CustomButton(
                  leftIcon: Icons.devices,
                  text: 'Connect from another device',
                  rightIcon: Icons.arrow_forward,
                  onPressed: () {
                    //
                  },
                  kBgColor: const Color.fromARGB(255, 31, 33, 133),
                  kTxtColor: Colors.white,
                  route: const LoginPage(),
                ),
                const SizedBox(height: 25),
                CustomButton(
                  leftIcon: Icons.cloud_upload_rounded,
                  text: 'Connect from BackUp',
                  rightIcon: Icons.arrow_forward,
                  onPressed: () {
                    //
                  },
                  kBgColor: Colors.white,
                  kTxtColor: const Color.fromARGB(255, 31, 33, 133),
                  route: const LoginPage(),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  leftIcon: Icons.router_rounded,
                  text: 'Connect to Management Server',
                  rightIcon: Icons.arrow_forward,
                  onPressed: () {
                    //
                  },
                  kBgColor: Colors.white,
                  kTxtColor: const Color.fromARGB(255, 31, 33, 133),
                  route: const LoginPage(),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  leftIcon: Icons.wifi_calling_3_sharp,
                  text: 'Add SIP Account',
                  rightIcon: Icons.arrow_forward,
                  onPressed: () {
                    //
                  },
                  kBgColor: Colors.white,
                  kTxtColor: const Color.fromARGB(255, 31, 33, 133),
                  route: const LoginPage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
