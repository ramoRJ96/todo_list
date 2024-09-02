import 'package:flutter/material.dart';

class AddTodoButton extends StatelessWidget {
  const AddTodoButton({
    super.key,
    this.onAdd,
  });

  final void Function()? onAdd;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onAdd,
      tooltip: 'Ajout d\'une tâche',
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }
}
