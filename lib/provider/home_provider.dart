import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // CREATE operation
  Future<void> createUser(BuildContext context) async {
    if (nameController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty) {
      await _usersCollection.add({
        'name': nameController.text,
        'age': int.parse(ageController.text),
        'email': emailController.text,
        'phone': phoneController.text,
      });
      _clearControllers();
      _showSnackBar(context, 'User created successfully');
      notifyListeners();
    }
  }

  // UPDATE operation
  Future<void> updateUser(BuildContext context, String id, String name, int age,
      String email, String phone) async {
    nameController.text = name;
    ageController.text = age.toString();
    emailController.text = email;
    phoneController.text = phone;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearControllers();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _usersCollection.doc(id).update({
                'name': nameController.text,
                'age': int.parse(ageController.text),
                'email': emailController.text,
                'phone': phoneController.text,
              });
              _clearControllers();
              Navigator.pop(context);
              _showSnackBar(context, 'User updated successfully');
              notifyListeners();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // DELETE operation
  Future<void> deleteUser(BuildContext context, String id) async {
    await _usersCollection.doc(id).delete();
    _showSnackBar(context, 'User deleted successfully');
    notifyListeners();
  }

  // READ operation
  Stream<QuerySnapshot> getUsers() {
    return _usersCollection.snapshots();
  }

  // Clear text controllers
  void _clearControllers() {
    nameController.clear();
    ageController.clear();
    emailController.clear();
    phoneController.clear();
  }

  // Show SnackBar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
