import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../routes/routes.dart';
import '../utils/after_layout.dart';
import '../utils/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    // Show splash screen for 2 seconds.
    Future<void>.delayed(const Duration(seconds: 2)).then(
      (_) async {
        await Navigator.of(context).pushReplacementNamed(Routes.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'stream_logo',
              child: SvgPicture.asset(
                streamLogoAsset,
                semanticsLabel: 'Stream Logo',
                width: size.width * 0.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Stream Dog Fooding',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}