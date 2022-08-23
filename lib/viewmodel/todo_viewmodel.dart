import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:todolist/model/dto/common/res_dto.dart';
import 'package:todolist/model/dto/todo/req/insert_todo.dart';
import 'package:todolist/model/dto/todo/req/update_todo.dart';
import 'package:todolist/model/dto/todo/res/todo.dart';
import 'package:todolist/model/repository/todo_repository.dart';
import 'package:todolist/utils/utils.dart';

class TodoViewmodel extends GetxController {
  static TodoViewmodel get to => Get.find();
  final TextEditingController textEditingController = TextEditingController();

  final TodoRepository todoRepository = Get.put(TodoRepository());

  // 할일리스트
  final RxList<Todo> _todoList = <Todo>[].obs;

  // 할일완료
  final RxList<Todo> _doneList = <Todo>[].obs;

  @override
  void onInit() {
    _getList(); // 할일리스트 초기화
    super.onInit();
  }

  // 할일 가져오기
  Future<void> _getList() async {
    final ResDto<List<Todo>?> resDto = await todoRepository.getList();

    if (resDto.code == 0) {
      _todoList.value = resDto.data!.where((element) => element.doneYn == "N").toList();
      _doneList.value = resDto.data!.where((element) => element.doneYn == "Y").toList();
    }
    // 특별한 에러처리
    // else if (responseDto.code == 1) {
    //
    // }
  }

  // 할일등록
  Future<void> create() async {
    final InsertTodo insertTodo = InsertTodo(content: textEditingController.text);
    // 통신
    final ResDto<Todo?> resDto = await todoRepository.insertTodo(insertTodo);

    if (resDto.code == 0) {
      _getList();
    }
    // 특별한 에러처리
    // else if (responseDto.code == 1) {
    //
    // }

    textEditingController.text = '';
  }

  // 할일완료
  Future<void> done(Todo todo) async {
    final UpdateTodo updateTodo = UpdateTodo(doneYn: todo.doneYn == "Y" ? "N" : "Y");
    // 통신
    final ResDto<Todo?> resDto = await todoRepository.updateTodo(todo.idx, updateTodo);
    if (resDto.code == 0) {
      _getList();
    }
    // 특별한 에러처리
    // else if (responseDto.code == 1) {
    //
    // }
  }

  // 할일삭제
  Future<void> delete(int idx) async {
    final ResDto<dynamic> resDto = await todoRepository.deleteTodo(idx);
    if (resDto.code == 0) {
      _getList();
    }
    // 특별한 에러처리
    // else if (responseDto.code == 1) {
    //
    // }
  }

  // List get checkedList => _checkedList;
  List<Todo> get todoList => _todoList.value;

  List<Todo> get doneList => _doneList.value;
}
