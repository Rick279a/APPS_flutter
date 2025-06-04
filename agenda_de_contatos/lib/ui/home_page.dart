import 'dart:io';

import 'package:agenda_de_contatos/helpers/contact_helper.dart';
import 'package:agenda_de_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    setState(() {
      if (result == OrderOptions.orderaz) {
        contacts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      } else {
        contacts.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
      }
    });
  }

  void _showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact)),
    );

    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contatos"),
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: OrderOptions.orderaz,
                child: Text("Ordenar de A-Z"),
              ),
              const PopupMenuItem(
                value: OrderOptions.orderza,
                child: Text("Ordenar de Z-A"),
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showContactPage(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _showContactPage(contact: contacts[index]),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].img.isNotEmpty
                        ? FileImage(File(contacts[index].img))
                        : const AssetImage("images/person.png") as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacts[index].name,
                      style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(contacts[index].email ?? ""),
                    Text(contacts[index].phone),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
