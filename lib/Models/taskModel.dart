class Task {
  int id;
  String title;
  String priority;
  DateTime date;
  int status;

  Task({this.title, this.date, this.priority, this.status});
  Task.withId({this.id, this.date, this.status, this.title, this.priority});
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['date'] = date.toIso8601String();
    map['priority'] = priority;
    map['status'] = status;
    return map;
  }

  factory Task.formMap(Map<String, dynamic> map) {
    return Task.withId(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      priority: map['priority'],
      status: map['status'],
    );
  }
}
