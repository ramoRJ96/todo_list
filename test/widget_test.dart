import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/features/todo/data/data_sources/todo.dart';
import 'package:todo_list/features/todo/data/models/todo_states.dart';
import 'package:todo_list/features/todo/presentation/controllers/todo_controller.dart';

void main() {
  late TodoController todoController;

  setUp(() {
    todoController = TodoController();
  });

  group('TodoController Test', () {
    test('Initial value of filterValue should be TodoStates.all', () {
      expect(todoController.filterValue.value, TodoStates.all);
    });

    test('deleteTodo removes all todo', () async {
      await todoController.getTodoList();

      await todoController.deleteAll();

      expect(todoController.todoList.length, 0);
    });

    test('handleChangeFilterValue should update filterValue', () async {
      await todoController.handleChangeFilterValue(TodoStates.completed);
      expect(todoController.filterValue.value, TodoStates.completed);

      await todoController.handleChangeFilterValue(TodoStates.inProgress);
      expect(todoController.filterValue.value, TodoStates.inProgress);

      await todoController.handleChangeFilterValue(TodoStates.all);
      expect(todoController.filterValue.value, TodoStates.all);
    });

    test('insertTodo succeeds with valid data', () async {
      todoController.todoController.text = 'New Task';
      final result = await todoController.insertTodo();

      expect(result, true);
      expect(todoController.isLoading.value, false);
    });

    test('insertTodo fails with empty data', () async {
      final result = await todoController.insertTodo();

      expect(result, false);
      expect(todoController.isLoading.value, false);
      expect(todoController.todoErrorText.value, 'Veuillez remplir ce champs');
    });

    test(
        'getTodoList fetches all todos and test if it\'s the same that I insert',
        () async {
      //Remove all data before
      await todoController.deleteAll();

      todoController.todoController.text = 'Task 1';
      todoController.descriptionController.text = 'Description 1';
      await todoController.insertTodo();
      await todoController.getTodoList();

      expect(todoController.todoList.length, 1);
      expect(todoController.todoList[0].name, 'Task 1');
      expect(todoController.todoList[0].description, 'Description 1');
      expect(todoController.isGettingData.value, false);
    });

    test('deleteTodo removes the correct todo', () async {
      //Remove all data before
      await todoController.deleteAll();

      todoController.todoController.text = 'Task 1';
      await todoController.insertTodo();

      todoController.todoController.text = 'Task 2';
      await todoController.insertTodo();

      await todoController.getTodoList();
      await todoController.deleteTodo(todoController.todoList.first.id!);

      expect(todoController.todoList.length, 1);
    });

    test('updateTodo removes the correct todo', () async {
      //Remove all data before
      await todoController.deleteAll();

      todoController.todoController.text = 'Task 1';
      await todoController.insertTodo();

      await todoController.getTodoList();
      
      todoController.todoController.text = 'Task 2';
      await todoController.updateTodo(Todo(
        id: todoController.todoList.first.id,
        name: todoController.todoController.text,
        description: todoController.todoList.first.description,
      ));
      
      expect(todoController.todoList.first.name, 'Task 2');
    });
  });
}
