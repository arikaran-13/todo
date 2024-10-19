
import 'package:flutter/cupertino.dart';
import 'package:todo/pages/create_task.dart';
import 'package:todo/pages/home.dart';

class TodoAppRoutes{

  static const String home = "/";
  static const String newTask = "/newTask";

  static Map<String,WidgetBuilder> routes = {
    home : (context) => const Home(),
    newTask : (context)=> const CreateTask()
  };



}