import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_ai_bot/di/app_di.dart';
import 'package:open_ai_bot/features/Home/home_bloc.dart';
import 'package:open_ai_bot/features/Home/home_page.dart';
import 'package:open_ai_bot/di/app_di.dart' as di;

void main() async {
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenAI bot loves flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple, 
          background: Colors.black, 
          primary: Colors.white,
          secondary: Colors.white),
        useMaterial3: true,
      ),
      home: BlocProvider(create: (context) => HomeBloc(serviceLocator(), serviceLocator()),
       child: const HomePage(),
      )
    );
  }
}
