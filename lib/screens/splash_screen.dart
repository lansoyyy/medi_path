import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_path/screens/home_screen.dart';
import 'package:medi_path/widgets/text_widget.dart';

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
      Get.off(() => const HomeScreen(),
          transition: Transition.leftToRightWithFade);
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
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Game logo.PNG',
              height: 150,
            ),
            SizedBox(
              height: 12.5,
            ),
            TextWidget(
              text: 'by: ROOSTERCAT LLC GAMES',
              fontSize: 12,
              color: Colors.white,
              fontFamily: 'Bold',
            ),
          ],
        ),
      ),
    );
  }
}
