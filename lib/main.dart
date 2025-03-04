import 'package:flutter/material.dart';
import 'package:programming_challenge/routes/routes.dart';
import 'package:programming_challenge/screens/clock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: 'Roboto'),
      themeMode: ThemeMode.dark,
      routes: routes,
      initialRoute: ClockPage.routeName,
    );
  }
}
