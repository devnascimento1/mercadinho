import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mercado/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()), // Redireciona para MyApp
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 500,
            height: 300,
            child: Image.asset('assets/image/logo.png'),
          ),
          const SizedBox(height: 25),
          const Text(
            'Lista Plus',
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),
    );
  }
}
