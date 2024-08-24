import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Contact>> getRegisteredContacts() async {
  List<Contact> registeredContacts = [];

  // Fetch all contacts
  Iterable<Contact> contacts = await ContactsService.getContacts();

  for (Contact contact in contacts) {
    for (Item phone in contact.phones!) {
      String normalizedPhoneNumber = phone.value!.replaceAll(RegExp(r'\D'), '');

      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: normalizedPhoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        registeredContacts.add(contact);
      }
    }
  }

  return registeredContacts;
}

Future<bool> requestContactPermission() async {
  var status = await Permission.contacts.status;
  if (!status.isGranted) {
    status = await Permission.contacts.request();
  }
  return status.isGranted;
}

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late Future<List<Contact>> _registeredContacts;

  @override
  void initState() {
    super.initState();
    _registeredContacts = requestContactPermission().then((granted) {
      if (granted) {
        return getRegisteredContacts();
      } else {
        return [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Contacts',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          iconSize: 30.0,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<List<Contact>>(
        future: _registeredContacts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading contacts.'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No registered contacts found.'));
          }

          final contacts = snapshot.data!;

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                title: Text(contact.displayName ?? 'No name'),
                subtitle: Text(contact.phones!.isNotEmpty
                    ? contact.phones!.first.value ?? ''
                    : 'No phone number'),
                onTap: () {
                  //chat starty
                },
              );
            },
          );
        },
      ),
    );
  }
}
