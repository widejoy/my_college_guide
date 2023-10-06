import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/home_screen.dart';
import 'package:project_one/screens/authentication/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    super.initState();
    getLoggedInState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: userIsLoggedIn ? const HomeScreen() : const SignIn(),
    );
  }

  Future<void> getLoggedInState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool('userLoggedIn');

    if (value != null) {
      setState(
        () {
          userIsLoggedIn = value;
        },
      );
    }
  }
}
