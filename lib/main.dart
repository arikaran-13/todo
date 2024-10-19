import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/pages/home.dart';
import 'package:todo/provider/task_provider.dart';
import 'package:todo/routes/routes.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=>TaskProvider()),
    ],
      child: TodoApp(),
    )
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: TodoAppRoutes.routes,
      theme: ThemeData(
        primarySwatch: Colors.yellow
      ),
    );
  }
}
