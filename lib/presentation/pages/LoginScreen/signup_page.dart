import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobolt_chatapp/core/constants/constants.dart';
import 'package:cobolt_chatapp/presentation/pages/HomeScreen/chat_screen.dart';
import 'package:cobolt_chatapp/presentation/pages/HomeScreen/contacts_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _phoneNumberController = TextEditingController();

Future<void> _signUp(BuildContext context) async {
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();
  // final username = _usernameController.text.trim();
  final phoneNumber = _phoneNumberController.text.trim().replaceAll(RegExp(r'\D'), '');

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
      // 'username': username,
      'email': email,
      'phoneNumber': phoneNumber, // Storing the normalized phone number
    });

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ChatScreen(contact: Contact(name: '', phoneNumber: phoneNumber),)));
  } catch (e) {
    print(e);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Up Failed'),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}


//phonenumber verification
Future<void> _signInWithPhoneNumber(BuildContext context) async {
  final phoneNumber = _phoneNumberController.text.trim();

  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ChatScreen(contact: Contact(name: '', phoneNumber: ''),)));
      },
      verificationFailed: (FirebaseAuthException e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Verification Failed'),
            content: Text(e.message ?? 'Unknown error occurred'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        showDialog(
          context: context,
          builder: (context) {
            String smsCode = '';
            return AlertDialog(
              title: const Text('Enter SMS Code'),
              content: TextField(
                onChanged: (value) {
                  smsCode = value;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (smsCode.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Invalid Code'),
                          content:
                              const Text('Please enter the SMS code received.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: smsCode,
                      );
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ChatScreen(contact: Contact(name: '', phoneNumber: ''),),
                      ));
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text('Error: ${e.toString()}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var _obscureText = false;

  Widget _buildEmail() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Email',
            style: kLabelStyle,
          ),
          const SizedBox(height: 5.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    !value.contains('@') ||
                    !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address.';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color.fromARGB(255, 31, 33, 133),
                ),
                hintText: 'Enter your Email',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Phone Number',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
            style: const TextStyle(
              color: Colors.black54,
              fontFamily: 'OpenSans',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Color.fromARGB(255, 31, 33, 133),
              ),
              hintText: 'Enter your Phone Number',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
            obscureText: _obscureText,
            style: const TextStyle(
              color: Colors.black54,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.lock,
                color: Color.fromARGB(255, 31, 33, 133),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: _obscureText
                      ? Colors.grey
                      : const Color.fromARGB(255, 31, 33, 133),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSigninBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ElevatedButton(
          onPressed: () {
            if (_phoneNumberController.text.isNotEmpty) {
              _signInWithPhoneNumber(context);
            } else {
              _signUp(context);
            }
          },
          style: const ButtonStyle(),
          child: const Text(
            'SIGNUP',
            style: TextStyle(
              color: Color.fromARGB(255, 31, 33, 133),
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

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
        appBar: AppBar(),
        backgroundColor: Colors.transparent,
        body: Form(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 90.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color.fromARGB(255, 31, 33, 133),
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 45.0),
                    const Icon(
                      Icons.person,
                      size: 170,
                    ),
                    const SizedBox(height: 25),
                    //
                    _buildEmail(),
                    const SizedBox(height: 8.5),
                    _buildPhoneNumberTF(),
                    const SizedBox(height: 8.5),
                    _buildPasswordTF(),
                    _buildSigninBtn(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
