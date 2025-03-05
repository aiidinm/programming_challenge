import 'package:flutter/material.dart';
import 'package:programming_challenge/routes/routes.dart';
import 'package:programming_challenge/screens/clock.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            fixedSize: WidgetStateProperty.all(Size(80, 35)),
            backgroundColor: WidgetStateProperty.all(Colors.green),
            padding: WidgetStateProperty.all(EdgeInsets.all(15)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      routes: routes,
      initialRoute: ClockPage.routeName,
    );
  }
}
