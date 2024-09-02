import 'package:floor/floor.dart';

@Entity(tableName: 'todo')
class Todo {
  Todo({
    this.id,
    this.name,
    this.description,
    this.isCompleted = false
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  final String? name;

  final String? description;

  @ColumnInfo(name: 'is_completed')
  final bool isCompleted;
}
