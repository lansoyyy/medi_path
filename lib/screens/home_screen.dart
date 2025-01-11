import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_path/screens/main_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playAudio();
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

  bool isMuted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                backgroundColor: Colors.white,
                child: Icon(
                  !isMuted ? Icons.volume_mute_sharp : Icons.volume_off,
                  color: Colors.red,
                ),
                onPressed: () async {
                  setState(() {
                    isMuted = !isMuted;

                    if (isMuted) {
                      player.stop();
                    } else {
                      player.resume();
                    }
                  });
                },
              ),
              const SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.settings,
                  color: Colors.red,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/3.png',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 140,
            left: 250,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const MainHomeScreen(),
                    transition: Transition.leftToRightWithFade);
              },
              child: Container(
                width: 300,
                height: 60,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 68,
            left: 250,
            child: GestureDetector(
              onTap: () {
                print('asdasd');
              },
              child: Container(
                width: 300,
                height: 60,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
