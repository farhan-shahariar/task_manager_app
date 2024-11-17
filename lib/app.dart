import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/screens/splash_screen.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      home: const SplashScreen(),
      theme: lightThemeData(),
    );
  }

  ThemeData lightThemeData() {
    return ThemeData(
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey.shade400),
          fillColor: Colors.white,
          filled: true,
          border: const OutlineInputBorder(borderSide: BorderSide.none)),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
            color: Colors.grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.themeColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            foregroundColor: AppColors.whiteColor,
            fixedSize: const Size.fromWidth(double.maxFinite),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
