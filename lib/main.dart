import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reimagine/widgets/bottombar.dart';
import 'Pages/street_view_test.dart';

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
      // Keep the existing BottomBarWidget as the main content but wrap it so
      // we can quickly open the Street View API test page via a FAB.
      home: HomeWithTest(),
      routes: {'/street-view-test': (context) => const StreetViewTestPage()},
    );
  }
}

class HomeWithTest extends StatelessWidget {
  const HomeWithTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const BottomBarWidget(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed('/street-view-test'),
        icon: const Icon(Icons.map),
        label: const Text('Street View Test'),
      ),
    );
  }
}
