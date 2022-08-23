import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:todolist/model/repository/todo_repository.dart';
import 'package:todolist/view/modules/todo_list/todo_list_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'totoList',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white)),
        home: TodoListPage());
  }
}
