import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medi_path/screens/game_screens/color.dart';
import 'package:medi_path/screens/game_screens/number.dart';
import 'package:medi_path/screens/game_screens/hangman.dart';
import 'package:medi_path/screens/main_home_screen.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/show_dialog.dart';

class ReceptionScreen extends StatefulWidget {
  const ReceptionScreen({super.key});

  @override
  State<ReceptionScreen> createState() => _ReceptionScreenState();
}

class _ReceptionScreenState extends State<ReceptionScreen>
    with TickerProviderStateMixin {
  late AnimationController _arrowController;
  late AnimationController _pulseController;
  late Animation<double> _arrowAnimation;
  late Animation<double> _pulseAnimation;
  final _storage = GetStorage();

  @override
  void initState() {
    super.initState();

    // Arrow bounce animation
    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _arrowAnimation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

    // Pulse animation for folder highlight
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _arrowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

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
          // Task Folder with Visual Guide
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 100 + (_pulseAnimation.value - 1) * 5,
                left: 375,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    showTaskDialog();
                  },
                  child: Container(
                    width: 180,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF3498DB)
                            .withOpacity(0.6 + _pulseAnimation.value * 0.2),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3498DB).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Animated pointing arrow
                        Positioned(
                          top: -40,
                          left: 0,
                          right: 0,
                          child: AnimatedBuilder(
                            animation: _arrowAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, -_arrowAnimation.value),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3498DB),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF3498DB)
                                            .withOpacity(0.4),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_downward,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'MISSIONS',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Click here hint
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Click for Tasks',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
          padding: const EdgeInsets.only(top: 20, right: 20),
          child: Align(
            alignment: Alignment.topRight,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Get.back();
                },
                customBorder: const CircleBorder(),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
