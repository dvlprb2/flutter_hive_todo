import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final bool completed;

  Task(this.title, this.completed);
}
