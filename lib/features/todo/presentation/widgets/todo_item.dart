import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../data/data_sources/todo.dart';
import '../controllers/todo_controller.dart';
import 'todo_bottom_sheet.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.todo,
    required this.controller,
    this.onCompleted,
  });

  final Todo todo;
  final void Function(bool?)? onCompleted;
  final TodoController controller;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: ValueKey(todo.id),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),
        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(onDismissed: () async {
          if (todo.id != null) {
            await controller.deleteTodo(todo.id!);
          }
        }),
        // All actions are defined in the children parameter.
        children: [
          SlidableAction(
            onPressed: (context) async {
              if (todo.id != null) {
                await controller.deleteTodo(todo.id!);
              }
            },
            backgroundColor: Colors.red.shade500,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            icon: Icons.delete,
            autoClose: true,
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: GestureDetector(
        onTap: () async {
          controller.getCurrentTodo(todo);
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
                    readOnly: true,
                  ));
            },
          );
          controller.clearFormData();
        },
        child: Card(
          color: Colors.white,
          shadowColor: Colors.grey.shade100,
          elevation: 0.5,
          child: Container(
            padding: EdgeInsets.all(8.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: todo.isCompleted,
                      shape: const CircleBorder(),
                      onChanged: onCompleted,
                      side: WidgetStateBorderSide.resolveWith(
                        (states) => BorderSide(
                          color: todo.isCompleted
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                          strokeAlign: 3.5,
                          width: 1.5.w,
                        ),
                      ),
                      fillColor: WidgetStateColor.resolveWith((states) {
                        return todo.isCompleted
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent;
                      }),
                      checkColor: todo.isCompleted
                          ? Colors.white
                          : Colors.transparent,
                      
                    ),
                    Text(
                      todo.name ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 33.sp,
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () async {
                    controller.getCurrentTodo(todo);
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
                              isEditing: true,
                              todo: todo,
                            ));
                      },
                    );
                    controller.clearFormData();
                  },
                  icon: const Icon(
                    Icons.edit,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
