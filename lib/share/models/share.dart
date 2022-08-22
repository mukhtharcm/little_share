// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SharedCollection {
  String? id;
  String title;
  String description;

  SharedCollection({
    this.id,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
    };
  }

  factory SharedCollection.fromMap(Map<String, dynamic> map) {
    return SharedCollection(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SharedCollection.fromJson(String source) =>
      SharedCollection.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SharedCollection(id: $id, title: $title, description: $description)';
}
