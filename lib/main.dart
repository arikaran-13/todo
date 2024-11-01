import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/notification/notification.dart';
import 'package:todo/provider/task_provider.dart';
import 'package:todo/routes/routes.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todoBox');
  NotificationService().initNotification();
  tz.initializeTimeZones();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=>TaskProvider()),
    ],
      child: const TodoApp(),
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
        primarySwatch: Colors.deepPurple
      ),
    );
  }
}
