class Task {
  int id;
  String title;
  String description;
  bool completed;

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'] ?? '',
        completed = json['completed'];

  Task({
    required this.id,
    required this.title,
    required this.completed,
    this.description = "",
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'completed': completed,
        'description': description,
      };
}
