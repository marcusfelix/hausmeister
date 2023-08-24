class Document {
  final String id;
  final String name;
  final Uri document;

  Document({
    required this.id,
    required this.name,
    required this.document,
  });

  factory Document.fromJson(String id, Map<String, dynamic> data) {
    return Document(
      id: id,
      name: data['name'],
      document: data['document']
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'document': document,
  };
}