class Person {
  final int? id;
  final String name;
  final int age;
  final String relationship;
  final int? parentId;
  final int userId; // Add this line

  Person({
    this.id,
    required this.name,
    required this.age,
    required this.relationship,
    this.parentId,
    required this.userId, // Ensure this is included in the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'relationship': relationship,
      'parentId': parentId,
      'userId': userId, // Ensure this is included in the map
    };
  }

  static Person fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      relationship: map['relationship'],
      parentId: map['parentId'],
      userId: map['userId'], // Ensure this is included in the fromMap method
    );
  }
}
