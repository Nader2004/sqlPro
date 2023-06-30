import 'package:flutter/material.dart';
import 'package:sqlpro/pages/start_page.dart';

void main() {
  runApp(const SQLPro());
}

class SQLPro extends StatelessWidget {
  const SQLPro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartPage(),
      },
    );
  }
}
