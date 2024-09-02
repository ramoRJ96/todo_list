import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../data/data_sources/todo.dart';
import '../../data/models/filter_model.dart';
import '../../data/models/todo_states.dart';
import '../controllers/todo_binding.dart';
import '../controllers/todo_controller.dart';
import '../widgets/add_todo_button.dart';
import '../widgets/no_todo_screen.dart';
import '../widgets/todo_bottom_sheet.dart';
import '../widgets/todo_item.dart';

class TodoScreen extends GetView<TodoController> {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TodoBinding().dependencies();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            const Icon(
              Icons.task_alt,
            ),
            Gap(10.w),
            Text(
              'Task',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.0.w,
          vertical: 40.0.h,
        ),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Gap(40.h),
              Obx(() {
                final filtersButton = [
                  FilterModel(
                    label: 'Toutes',
                    onPressed: () =>
                        controller.handleChangeFilterValue(TodoStates.all),
                    isActive: controller.filterValue.value == TodoStates.all,
                  ),
                  FilterModel(
                    label: 'En cours',
                    onPressed: () => controller
                        .handleChangeFilterValue(TodoStates.inProgress),
                    isActive:
                        controller.filterValue.value == TodoStates.inProgress,
                  ),
                  FilterModel(
                    label: 'Complètes',
                    onPressed: () => controller
                        .handleChangeFilterValue(TodoStates.completed),
                    isActive:
                        controller.filterValue.value == TodoStates.completed,
                  ),
                ];
                return SizedBox(
                  height: 100.h,
                  child: ListView.separated(
                      itemCount: filtersButton.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return Gap(20.h);
                      },
                      itemBuilder: (context, index) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: SizedBox(
                            width: Get.width * .3,
                            height: 80.h,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0.r),
                                        side: BorderSide(
                                          color: filtersButton[index].isActive
                                              ? Colors.blue.shade900
                                              : Colors.blueGrey.shade900,
                                        ))),
                                elevation: const WidgetStatePropertyAll(0.0),
                                backgroundColor: WidgetStateProperty.all(
                                  filtersButton[index].isActive
                                      ? Colors.blue.shade100
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor,
                                ),
                              ),
                              onPressed: filtersButton[index].onPressed,
                              child: Text(
                                filtersButton[index].label,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: filtersButton[index].isActive
                                          ? Colors.blue.shade700
                                          : Colors.blueGrey.shade900,
                                    ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }),
              Gap(40.h),
              Obx(() {
                if (controller.isGettingData.value) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }

                if (controller.todoList.isEmpty) {
                  return const NoTodoScreen();
                }

                return ListView.separated(
                    itemCount: controller.todoList.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return Gap(20.h);
                    },
                    itemBuilder: (context, index) {
                      var todo = controller.todoList[index];
                      return TodoItem(
                        todo: todo,
                        controller: controller,
                        onCompleted: (isCompleted) async {
                          await controller.updateTodo(Todo(
                            id: todo.id,
                            name: todo.name,
                            description: todo.description,
                            isCompleted: isCompleted ?? false,
                          ), true);
                        },
                      );
                    });
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: AddTodoButton(
        onAdd: () async {
          await showModalBottomSheet<void>(
            context: context,
            backgroundColor: Colors.white,
            isScrollControlled: true,
            builder: (_) {
              return FractionallySizedBox(
                  heightFactor: 0.7,
                  widthFactor: 0.95,
                  child: TodoBottomSheet(
                    controller: controller,
                  ));
            },
          );
          controller.clearFormData();
        },
      ),
    );
  }
}
