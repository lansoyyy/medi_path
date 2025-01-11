import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playAudio();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Get.dialog(
          barrierDismissible: true,
          Container(
            height: 400,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage(
                  'assets/images/Task sample.PNG',
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  late AudioPlayer player = AudioPlayer();
  playAudio() async {
    player.setReleaseMode(ReleaseMode.loop);
    player.setVolume(1);

    await player.setSource(
      AssetSource(
        'images/background.mp3',
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
                'assets/images/8.png',
              ),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
