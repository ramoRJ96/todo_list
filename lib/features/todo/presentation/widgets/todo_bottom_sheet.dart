import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../data/data_sources/todo.dart';
import '../controllers/todo_controller.dart';

class TodoBottomSheet extends StatelessWidget {
  const TodoBottomSheet({
    super.key,
    this.readOnly = false,
    this.isEditing = false,
    this.todo,
    required this.controller,
  });

  final TodoController controller;
  final bool readOnly;
  final bool isEditing;
  final Todo? todo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(60.h),
            Row(
              mainAxisAlignment: readOnly
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                Text(
                  readOnly
                      ? 'Votre tâche'
                      : '${isEditing ? "Modifier" : "Ajouter"}  une tâche',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.black),
                ),
              ],
            ),
            Gap(50.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(
                () => TextField(
                  controller: controller.todoController,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.task),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorText: controller.todoErrorText.value,
                    enabled: !readOnly,
                    label: Text(
                      'Tâche',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.grey.shade500),
                    ),
                  ),
                ),
              ),
            ),
            Gap(40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                controller: controller.descriptionController,
                maxLines: 5,
                readOnly: readOnly,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.description),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  enabled: !readOnly,
                  label: Text(
                    'Description',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.grey.shade500),
                  ),
                ),
              ),
            ),
            if (!readOnly) Gap(40.h),
            if (!readOnly)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ElevatedButton(
                  onPressed: () async {
                    if (isEditing) {
                      bool isOk = await controller.updateTodo(Todo(
                          id: todo?.id,
                          name: controller.todoController.text,
                          description: controller.descriptionController.text,
                          isCompleted: todo?.isCompleted ?? false));

                      if (isOk && context.mounted) {
                        Navigator.of(context).pop();
                        await controller.getTodoList();
                        controller.clearFormData();
                      }
                    } else {
                      bool isOk = await controller.insertTodo();
                      if (isOk && context.mounted) {
                        Navigator.of(context).pop();
                        await controller.getTodoList();
                        controller.clearFormData();
                      }
                    }
                  },
                  child: Text(isEditing ? 'Modifier' : 'Ajouter'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
