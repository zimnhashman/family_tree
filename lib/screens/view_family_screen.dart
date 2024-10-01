import 'package:flutter/material.dart';
import 'package:mike_family_tree/database/db_helper.dart';
import 'package:mike_family_tree/models/person_model.dart';
import 'add_family_member.dart';


class ViewFamilyTreePage extends StatefulWidget {
  final int userId;

  const ViewFamilyTreePage({super.key, required this.userId});

  @override
  _ViewFamilyTreePageState createState() => _ViewFamilyTreePageState();
}

class _ViewFamilyTreePageState extends State<ViewFamilyTreePage> {
  final DBHelper dbHelper = DBHelper();
  Person? rootAncestor;

  @override
  void initState() {
    super.initState();
    _loadFamilyTree();
  }

  Future<void> _loadFamilyTree() async {
    final List<Person> rootMembers = await dbHelper.getFamilyMembersForUser(null, widget.userId);
    if (rootMembers.isNotEmpty) {
      setState(() {
        rootAncestor = rootMembers.first;
      });
    }
  }

  void _addFamilyMember(Person newMember) async {
    await dbHelper.insertPerson(newMember);
    _loadFamilyTree();
  }

  Widget buildFamilyTree(Person person) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${person.name} (${person.relationship})'),
        FutureBuilder<List<Person>>(
          future: dbHelper.getFamilyMembersForUser(person.id, widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  children: snapshot.data!.map(buildFamilyTree).toList(),
                ),
              );
            }

            return Container();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Family Tree')),
      body: rootAncestor == null
          ? const Center(child: Text('No family members added yet'))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildFamilyTree(rootAncestor!),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFamilyMemberPage(onAdd: _addFamilyMember, userId: widget.userId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
