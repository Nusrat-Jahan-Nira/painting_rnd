
import 'package:flutter/material.dart';
import 'package:painting_rnd/pages/drawing_page.dart';
import 'package:painting_rnd/provider/drawing_data.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrawingData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Painting App',
        home: DrawingPage(),
      ),
    );
  }
}




