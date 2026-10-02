import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const HousingApp());
}

class HousingApp extends StatelessWidget {
  const HousingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Housing.com Property Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
      routes: {
        '/': (context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
