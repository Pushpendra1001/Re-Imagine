import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reimagine/Pages/360VideoScreen.dart';
import 'package:reimagine/Pages/form.dart';
import 'package:reimagine/widgets/bottombar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BottomBarWidget());
  }
}
