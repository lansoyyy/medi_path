import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:medi_path/screens/game_screens/color.dart';
import 'package:medi_path/screens/game_screens/number.dart';
import 'package:medi_path/screens/game_screens/hangman.dart';
import 'package:medi_path/screens/main_home_screen.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/show_dialog.dart';

class ReceptionScreen extends StatelessWidget {
  const ReceptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/RECEPTION.png',
                  ),
                  fit: BoxFit.fitHeight),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 375,
            child: GestureDetector(
              onTap: () {
                showTaskDialog();
              },
              child: Container(
                width: 180,
                height: 150,
                color: Colors.transparent,
              ),
            ),
          ),
          if (currentLevel == 4)
            Positioned(
              bottom: 120,
              right: 260,
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    () => const ReceptionMedicalRecordsItem(),
                    transition: Transition.circularReveal,
                  );
                },
                child: Container(
                  width: 180,
                  height: 150,
                  color: Colors.transparent,
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 500,
            child: GestureDetector(
              onTap: () {
                Get.off(() => const MainHomeScreen(),
                    transition: Transition.leftToRightWithFade);
              },
              child: Container(
                width: 280,
                height: 100,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReceptionMedicalRecordsItem extends StatelessWidget {
  const ReceptionMedicalRecordsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final random = math.Random();
        int value = random.nextInt(3);

        if (value == 0) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  const ColorMatchingGame(item: 'Medical Records'),
            ),
          );
        } else if (value == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NumberMatchingGame(item: 'Medical Records'),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HangmanGame(item: 'Medical Records'),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: AssetImage(
              'assets/images/file1.png',
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 50),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
