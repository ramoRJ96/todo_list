import 'package:get/get.dart';

import 'todo_controller.dart';

class TodoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      TodoController(),
    );
  }
}
