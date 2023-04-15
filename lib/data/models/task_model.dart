class TaskModel {
  int? id;
  String? title, time, date, status;

  TaskModel(
      {required this.title,
      required this.time,
      required this.date,
      required this.status});

  TaskModel.fromJson(Map json) {
    id = json['id'];
    title = json['title'];
    time = json['time'];
    date = json['date'];
    status = json['status'];
  }
}
