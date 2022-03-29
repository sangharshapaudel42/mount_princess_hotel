import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/admin_navigation_drawer_widget.dart';

class AdminPackages extends StatefulWidget {
  const AdminPackages({Key? key}) : super(key: key);

  @override
  State<AdminPackages> createState() => _AdminPackagesState();
}

class _AdminPackagesState extends State<AdminPackages> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Manage Packages'),
          centerTitle: true,
        ),
        body: const PackagePage(),
      );
}

class PackagePage extends StatefulWidget {
  const PackagePage({Key? key}) : super(key: key);

  @override
  _PackagePageState createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  // text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final _productInfos = FirebaseFirestore.instance.collection('Packages');

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _descriptionController.text = documentSnapshot['description'];
      _priceController.text = documentSnapshot['price'].toString();
    }

    @override
    void dispose() {
      super.dispose();
      _nameController.dispose();
      _descriptionController.dispose();
      _priceController.dispose();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String? name = _nameController.text;
                    final String? description = _descriptionController.text;
                    final double? price =
                        double.tryParse(_priceController.text);
                    if (name != null && price != null) {
                      // Update the product
                      await _productInfos.doc(documentSnapshot!.id).update({
                        "name": name,
                        "description": description,
                        "price": price
                      });

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: _productInfos.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (!streamSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  color: Colors.grey[300],
                  margin: const EdgeInsets.only(
                      top: 10, right: 10, left: 10, bottom: 10),
                  child: ListTile(
                    title: Text(documentSnapshot['name'],
                        style: const TextStyle(
                          fontSize: 25,
                        )),
                    subtitle: documentSnapshot['description'] == ""
                        ? Text(
                            '\n' +
                                'Price: \$ ' +
                                documentSnapshot['price'].toString(),
                            style: const TextStyle(
                                fontSize: 22, color: Colors.black))
                        : Text(
                            '\n' +
                                documentSnapshot['description'] +
                                '\n\n' +
                                'Price: \$ ' +
                                documentSnapshot['price'].toString(),
                            style: const TextStyle(
                                fontSize: 22, color: Colors.black),
                          ),
                    trailing: SizedBox(
                      width: 30,
                      child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _update(documentSnapshot)),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
}
