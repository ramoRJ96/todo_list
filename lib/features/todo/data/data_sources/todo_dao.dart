import 'package:floor/floor.dart';

import 'todo.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM todo ORDER BY id DESC')
  Future<List<Todo>> findAll();

  @Query('SELECT * FROM todo WHERE is_completed = :isCompleted ORDER BY id DESC')
  Future<List<Todo>> findByCompleted(bool isCompleted);

  @Query('SELECT * FROM user WHERE state = :state')
  Future<List<Todo>> findByState(String state);

  @Query('DELETE FROM todo')
  Future<void> deleteAll();

  @Query('DELETE FROM todo WHERE id = :id')
  Future<void> deleteById(int id);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> insert(Todo todo);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> update(Todo todo);
}
