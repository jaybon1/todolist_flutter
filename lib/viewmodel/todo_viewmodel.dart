import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:todolist/model/dto/common/response_dto.dart';
import 'package:todolist/model/dto/todo/req/insert_todo.dart';
import 'package:todolist/model/dto/todo/req/update_todo.dart';
import 'package:todolist/model/dto/todo/res/todo.dart';
import 'package:todolist/model/repository/todo_repository.dart';

class TodoViewmodel extends GetxController {
  static TodoViewmodel get to => Get.find();
  final TextEditingController textEditingController = TextEditingController();
  var logger = Logger();

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
  void _getList() async {
    //TodoRepository.getInstance.getList()에서 값을 가져오기 위해 async, await 사용
    ResponseDto<List<Todo>?> responseDto = await TodoRepository.getInstance.getList();

    if (responseDto.code != 0) {
      // 정상적으로 데이터가 들어오지 않았을경우, 백엔드와 상의해서 코드 수정가능
      Get.snackbar('알림', responseDto.message);
    }

    if (responseDto.data != null) {
      _todoList.value = responseDto.data!.where((element) => element.doneYn == "N").toList();
      _doneList.value = responseDto.data!.where((element) => element.doneYn == "Y").toList();
    }
  }

  // 할일등록
  Future<void> create() async {
    // 매개변수 받을 필요 없음
    final InsertTodo insertTodo = InsertTodo(
        // 객체생성
        content: textEditingController.text);
    // 통신
    ResponseDto<Todo?> responseDto = await TodoRepository.getInstance.insertTodo(insertTodo);
    if (responseDto.code != 0) {
      Get.snackbar('알림', responseDto.message);
    } else {
      _getList();
    }
    textEditingController.text = '';
  }

  // 할일완료
  void done(Todo todo) async {
    final UpdateTodo updateTodo = UpdateTodo(doneYn: todo.doneYn == "Y" ? "N" : "Y");
    // 통신
    ResponseDto<Todo?> responseDto = await TodoRepository.getInstance.updateTodo(todo.idx, updateTodo);
    if (responseDto.code != 0) {
      Get.snackbar('알림', responseDto.message);
    } else {
      _getList();
    }
  }

  // 할일삭제
  void delete(int idx) async {
    // 통신
    ResponseDto<dynamic> responseDto = await TodoRepository.getInstance.deleteTodo(idx);
    if (responseDto.code != 0) {
      Get.snackbar('알림', responseDto.message);
    } else {
      _getList();
    }
  }

  // List get checkedList => _checkedList;
  List<Todo> get todoList => _todoList.value;
  List<Todo> get doneList => _doneList.value;
}
