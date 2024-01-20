class Note {
  Note({
    required this.id,
    required this.userEmail,
    required this.date,
    required this.title,
    required this.feeling,
    required this.content,
    int createdAt = 0,
  }) : _createdAt = createdAt > 0 ? createdAt : DateTime.now().millisecondsSinceEpoch;

  final String id;
  final String userEmail;
  final DateTime date;
  final String title;
  final int feeling; // 0 to 100
  final String content;
  final int _createdAt; // timestamp

  // get for cratedAt
  int get createdAt => _createdAt;
}
