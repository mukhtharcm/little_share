import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FileModel {
  String? id;
  String name;
  String url;
  String collection_id;
  FileModel({
    this.id,
    required this.name,
    required this.url,
    required this.collection_id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'url': url,
      'collection_id': collection_id,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      url: map['url'] as String,
      collection_id: map['collection_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FileModel.fromJson(String source) =>
      FileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FileModel(id: $id, name: $name, url: $url, collection_id: $collection_id)';
  }
}
