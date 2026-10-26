class Note {
  final int? id;
  final String title;
  final String content;
  final String createdAt;
  final int color;

  static const int defaultColor = 0xFFFFFFFF;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.color = defaultColor,
  });

  String get formattedDate {
    final d = DateTime.tryParse(createdAt);
    if (d == null) return '-';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt,
      'color': color,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: map['created_at'] ?? '',
      color: map['color'] ?? defaultColor,
    );
  }
}