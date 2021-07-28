class Course {
  int id;
  String title;
  double gpa;
  int credit;
  int status;

  Course({this.title, this.gpa, this.credit, this.status});
  Course.withId({this.id, this.credit, this.title, this.gpa, this.status});
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['gpa'] = gpa;
    map['credit'] = credit;
    map['status'] = status;
    return map;
  }

  factory Course.formMap(Map<String, dynamic> map) {
    return Course.withId(
      id: map['id'],
      title: map['title'],
      gpa: map['gpa'],
      credit: map['credit'],
      status: map['status'],
    );
  }
}
