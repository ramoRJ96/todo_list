import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/data_sources/app_database.dart';
import '../../data/data_sources/todo.dart';
import '../../data/models/todo_states.dart';

class TodoController extends GetxController {
  var todoList = <Todo>[].obs;
  var isLoading = false.obs;
  var isGettingData = false.obs;
  var isFilter = false.obs;
  var filterValue = TodoStates.all.obs;

  final todoController = TextEditingController();
  final descriptionController = TextEditingController();

  var todoErrorText = Rxn<String>();

  String completeField = 'Veuillez remplir ce champs';

  bool get isDataCompleted =>
      todoController.text.isNotEmpty;

  @override
  void onInit() async {
    await getTodoList();
    super.onInit();
  }

  void validateField(
    TextEditingController controller,
    Rxn<String> errorText,
  ) {
    if (controller.text.isEmpty) {
      errorText.value = completeField;
    } else {
      errorText.value = null;
    }
  }

  void validateFields() {
    validateField(todoController, todoErrorText);
  }

  Future<void> handleChangeFilterValue(TodoStates state) async {
    // This condition is used to avoid call when the state is the same
    if (filterValue.value != state) {
      // Map associating each state with an async function
      final Map<TodoStates, Future<void> Function()> actions = {
        TodoStates.completed: () => getTodoList(true),
        TodoStates.inProgress: () => getTodoList(false),
      };

      // Call the corresponding function or the default function
      await (actions[state]?.call() ?? getTodoList());
    }
    filterValue.value = state;

    if (kDebugMode) {
      print('Filter value: ${filterValue.value}');
    }
  }

  Future<void> getTodoList([bool? isCompleted]) async {
    isGettingData.value = true;
    todoList.clear();
    AppDatabase db = await AppDatabase.getInstance();
    try {
      if (isCompleted != null) {
        todoList.value = await db.todoDao.findByCompleted(isCompleted);
      } else {
        todoList.value = await db.todoDao.findAll();
      }
      if (kDebugMode) {
        print('Our todoList: $todoList');
      }
    } catch (e) {
      if (kDebugMode) {
        print('getTodoList Error: $e');
      }
    }
    isGettingData.value = false;
  }

  Future<bool> insertTodo() async {
    isLoading.value = true;
    AppDatabase db = await AppDatabase.getInstance();
    validateFields();
    if (isDataCompleted) {
      try {
        await db.todoDao.insert(Todo(
          name: todoController.text,
          description: descriptionController.text,
        ));
        if (kDebugMode) {
          print('Our todoList: $todoList');
        }
        isLoading.value = false;
        return true;
      } catch (e) {
        if (kDebugMode) {
          print('insertTodo Error: $e');
        }
        isLoading.value = false;
        return false;
      }
    }
    isLoading.value = false;
    return false;
  }

  Future<bool> updateTodo(Todo todo) async {
    AppDatabase db = await AppDatabase.getInstance();
    validateFields();
    if (isDataCompleted) {
      try {
        await db.todoDao.update(todo);
        var todoIndex = todoList.indexWhere((value) => value.id == todo.id);
        todoList[todoIndex] = todo;
        if (kDebugMode) {
          print('Our todoList: $todoList');
        }
        return true;
      } catch (e) {
        if (kDebugMode) {
          print('updateTodo Error: $e');
        }
        return false;
      }
    }
    isLoading.value = false;
    return false;
  }

  Future<void> deleteTodo(int id) async {
    AppDatabase db = await AppDatabase.getInstance();
    await db.todoDao.deleteById(id);
    todoList.removeWhere((v) => v.id == id);
  }

  Future<void> deleteAll() async {
    AppDatabase db = await AppDatabase.getInstance();
    await db.todoDao.deleteAll();
    todoList.clear();
  }

  void getCurrentTodo(Todo todo) {
    descriptionController.text = todo.description ?? '';
    todoController.text = todo.name ?? '';
  }

  void clearFormData() {
    todoController.clear();
    descriptionController.clear();
    todoErrorText.value = null;
  }
}
