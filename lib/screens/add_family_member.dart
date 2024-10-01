import 'package:flutter/material.dart';
import 'package:mike_family_tree/models/person_model.dart';

class AddFamilyMemberPage extends StatefulWidget {
  final Function(Person) onAdd;
  final int userId;

  const AddFamilyMemberPage({super.key, required this.onAdd, required this.userId});

  @override
  State<AddFamilyMemberPage> createState() => _AddFamilyMemberPageState();
}

class _AddFamilyMemberPageState extends State<AddFamilyMemberPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _relationshipController = TextEditingController();
  int? _parentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Family Member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _relationshipController,
              decoration: const InputDecoration(labelText: 'Relationship'),
            ),
            ElevatedButton(
              onPressed: () {
                final newPerson = Person(
                  name: _nameController.text,
                  age: int.parse(_ageController.text),
                  relationship: _relationshipController.text,
                  parentId: _parentId,
                  userId: widget.userId, // This should work now
                );
                widget.onAdd(newPerson);
                Navigator.pop(context);
              },
              child: const Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }
}
