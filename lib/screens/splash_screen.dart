import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_novel_app/data/provider/category_provider.dart';
import 'package:flutter_novel_app/data/provider/novel_provider.dart';
import 'package:flutter_novel_app/main.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    
    await context.read<NovelProvider>().getFetchedNovels();
    await context.read<CategoryProvider>().getCategory();

    // Delay opsional supaya splash tetap kelihatan
    await Future.delayed(const Duration(seconds: 3));

    // Pindah ke MainScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F0),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mamam Novel logo image
              Image.asset(
                'assets/book_splash.png',
                width: 300,
                height: 300,
              ),

              const SizedBox(height: 10),

              // Mamam Novel text
              Text(
                'Mamam Novel',
                style: TextStyle(
                  color: Colors.teal.shade700,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for leaf design
class LeafPainter extends CustomPainter {
  final Color color;

  LeafPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..quadraticBezierTo(0, size.height / 2, size.width / 2, size.height)
      ..quadraticBezierTo(size.width, size.height / 2, size.width / 2, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
