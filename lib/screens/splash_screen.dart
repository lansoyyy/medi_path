import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_path/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playAudio();
    Timer(const Duration(seconds: 4), () async {
      // Test if location services are enabled.
      Get.to(const HomeScreen(), transition: Transition.leftToRightWithFade);
    });
  }

  late AudioPlayer player = AudioPlayer();
  playAudio() async {
    player.setVolume(1);

    await player.setSource(
      AssetSource(
        'images/intro.wav',
      ),
    );

    await player.resume();
  }

  pauseAudio() async {
    await player.stop();
  }

  @override
  void dispose() {
    super.dispose();
    pauseAudio();

    player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/1.png',
              ),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
