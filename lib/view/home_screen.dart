import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_appliction/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter CRUD with Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: context.watch<HomeProvider>().nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: context.watch<HomeProvider>().ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: context.watch<HomeProvider>().emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: context.watch<HomeProvider>().phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<HomeProvider>().createUser(context);
              },
              child: const Text('Create User'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: context.watch<HomeProvider>().getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.requireData;

                  return ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      final doc = data.docs[index];
                      final user = doc.data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(user['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Age: ${user['age']}'),
                              Text('Email: ${user['email']}'),
                              Text('Phone: ${user['phone']}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  context.read<HomeProvider>().updateUser(
                                      context,
                                      doc.id,
                                      user['name'],
                                      user['age'],
                                      user['email'],
                                      user['phone']);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context
                                      .read<HomeProvider>()
                                      .deleteUser(context, doc.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
