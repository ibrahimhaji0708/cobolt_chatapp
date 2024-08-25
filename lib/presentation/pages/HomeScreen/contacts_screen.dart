import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobolt_chatapp/presentation/pages/HomeScreen/chat_screen.dart';

class Contact {
  final String name;
  final String phoneNumber;

  Contact({required this.name, required this.phoneNumber});
}

Future<List<Contact>> getRegisteredContacts() async {
  List<Contact> registeredContacts = [];

  Iterable<Contact> contacts =
      (await ContactsService.getContacts()) as Iterable<Contact>;

  for (var contact in contacts) {
    if (contact.phoneNumber.isNotEmpty) {
      for (var phone in contacts) {
        String normalizedPhoneNumber =
            phone.phoneNumber.replaceAll(RegExp(r'\D'), '');

        var querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber', isEqualTo: normalizedPhoneNumber)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          registeredContacts.add(Contact(
            name: contact.name,
            phoneNumber: phone.phoneNumber,
          ));
        }
      }
    }
  }

  return registeredContacts;
}

// Function to request contact permission
Future<bool> requestContactPermission() async {
  var status = await Permission.contacts.status;
  if (!status.isGranted) {
    status = await Permission.contacts.request();
  }
  return status.isGranted;
}

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key, required List contacts});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late Future<List<Contact>> _registeredContacts;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndFetchContacts();
  }

  void _checkPermissionAndFetchContacts() async {
    _hasPermission = await requestContactPermission();
    if (_hasPermission) {
      setState(() {
        _registeredContacts = getRegisteredContacts();
      });
    } else {
      setState(() {
        _registeredContacts = Future.value([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text(
          'Contacts',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _hasPermission
          ? FutureBuilder<List<Contact>>(
              future: _registeredContacts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading contacts.'));
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No registered contacts found.'));
                }

                final contacts = snapshot.data!;

                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ListTile(
                      title: Text(contact.name),
                      subtitle: Text(contact.phoneNumber),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(contact: contact),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )
          : Center(
              child: ElevatedButton(
                onPressed: _checkPermissionAndFetchContacts,
                child: const Text('Allow Contact Access'),
              ),
            ),
    );
  }
}
