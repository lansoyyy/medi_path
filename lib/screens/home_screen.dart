import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_path/screens/character_screen.dart';
import 'package:medi_path/screens/main_home_screen.dart';
import 'package:medi_path/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _GameButton extends StatelessWidget {
  const _GameButton({
    required this.icon,
    required this.onPressed,
    this.size = 58,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF5F6D), // red pink
                Color(0xFFFFC371), // orange
              ],
            ),
            border: Border.all(color: Colors.white24, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF5F6D).withOpacity(0.45),
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: size * 0.5),
          ),
        ),
      ),
    );
  }
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Tooltip(
              message:
                  isMuted ? 'Unmute background music' : 'Mute background music',
              child: _GameButton(
                icon: isMuted ? Icons.volume_off : Icons.volume_up,
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
            ),
            const SizedBox(height: 12),
            Tooltip(
              message: 'Settings',
              child: _GameButton(
                icon: Icons.settings,
                onPressed: () {
                  Get.to(() => const SettingsScreen(),
                      transition: Transition.leftToRightWithFade);
                },
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/3_new.png',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 140,
            left: 165,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const MainHomeScreen(),
                    transition: Transition.leftToRightWithFade);
              },
              child: Container(
                width: 500,
                height: 80,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 68,
            left: 165,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const CharacterScreen(),
                    transition: Transition.leftToRightWithFade);
              },
              child: Container(
                width: 500,
                height: 70,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
