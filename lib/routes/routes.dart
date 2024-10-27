
import 'package:flutter/cupertino.dart';
import 'package:todo/pages/completed_tasks.dart';
import 'package:todo/pages/create_task.dart';
import 'package:todo/pages/home.dart';

class TodoAppRoutes{

  static const String home = "/";
  static const String newTask = "/newTask";
  static const String completedTask = "/completedTask";

  static Map<String,WidgetBuilder> routes = {
    home : (context) => const Home(),
    newTask : (context)=> const CreateTask(),
    completedTask : (context) => const CompletedTasks()
  };



}