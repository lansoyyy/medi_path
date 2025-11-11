import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:medi_path/screens/game_screens/color.dart';
import 'package:medi_path/screens/game_screens/number.dart';
import 'package:medi_path/screens/main_home_screen.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/text_widget.dart';

class MedTechScreen extends StatefulWidget {
  const MedTechScreen({super.key});

  @override
  State<MedTechScreen> createState() => _MedTechScreenState();
}

class _MedTechScreenState extends State<MedTechScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        showDoctorDialog(context);
      },
    );
  }

  void showDoctorDialog(BuildContext context) {
    // Add haptic feedback for immersion
    HapticFeedback.mediumImpact();

    // Random tip selection for variety
    final random = math.Random();
    final tips = [
      "Accuracy is crucial when measuring vital signs!",
      "Always calibrate equipment before use.",
      "Document all readings immediately to prevent errors.",
      "Maintain a clean and organized workspace for efficiency.",
      "Double-check patient information before recording data."
    ];
    final randomTip = tips[random.nextInt(tips.length)];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final Size screenSize = MediaQuery.of(context).size;
        final double dialogWidth =
            screenSize.width * 0.80 > 320 ? 320 : screenSize.width * 0.80;

        return Dialog(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 650),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Main dialog container with game-style design
                Container(
                  width: dialogWidth,
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9C27B0).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 1,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Mission title with game-style design
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Text(
                          'MISSION',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            shadows: [
                              Shadow(
                                  color: Colors.black54,
                                  offset: Offset(1, 1),
                                  blurRadius: 3),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Dialog bubble for medtech's speech
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Medtech icon
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9C27B0)
                                        .withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.biotech,
                                    color: Color(0xFF9C27B0),
                                    size: 14,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                // Medtech name with styling
                                const Text(
                                  'Medtech John',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xFF9C27B0),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Medtech's mission text
                            Text(
                              currentLevel == 3
                                  ? 'Critical situation! We need to monitor the patient continuously. Please get the patient monitor and check vital signs!'
                                  : 'Hello! Please check the patient\'s vital signs, including blood pressure, heart rate, xray and temperature.',
                              style: const TextStyle(
                                fontSize: 11,
                                height: 1.3,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            // Game tip with icon
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF9C4),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFFFD54F),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Icon(
                                      Icons.lightbulb,
                                      color: Color(0xFFFFB300),
                                      size: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      randomTip,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Color(0xFF5D4037),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Game-style accept button
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.8, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4CAF50),
                                    Color(0xFF2E7D32)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF4CAF50)
                                        .withOpacity(0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'ACCEPT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Medtech avatar with animation
                Positioned(
                  top: -50,
                  left: 0,
                  right: 0,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Colors.white, Color(0xFFE3F2FD)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: const Color(0xFF9C27B0),
                            width: 4,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/medtech.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Decorative elements (floating particles)
                ...List.generate(3, (index) {
                  return Positioned(
                    top: 80.0 + (index * 30),
                    right: 8.0 + (index * 5),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 500 + (index * 200)),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value * 0.5,
                          child: Transform.rotate(
                            angle: index * (math.pi / 6),
                            child: Icon(
                              [
                                Icons.favorite,
                                Icons.healing,
                                Icons.health_and_safety
                              ][index],
                              color: Colors.white.withOpacity(0.3),
                              size: 10 + (index * 2.0),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
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
                    "assets/images/MEDTECH ROOM.jpeg",
                  ),
                  fit: BoxFit.fitHeight),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 150,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const BloodTest(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 400,
                height: 150,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 600,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const XRay(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 150,
                height: 200,
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
          // Level 3 item - Patient Monitor
          if (currentLevel == 3)
            Positioned(
              bottom: 50,
              right: 50,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => const PatientMonitor(),
                      transition: Transition.circularReveal);
                },
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.transparent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class XRay extends StatelessWidget {
  const XRay({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final random = math.Random();
        int value = random.nextInt(2);

        if (value == 0) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ColorMatchingGame(item: 'X-Ray')));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NumberMatchingGame(item: 'X-Ray')));
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                    'assets/images/Screenshot_2025-01-27_221331-removebg-preview.png'))),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 50),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
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

class BloodTest extends StatefulWidget {
  const BloodTest({super.key});

  @override
  State<BloodTest> createState() => _BloodTestState();
}

class _BloodTestState extends State<BloodTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          final random = math.Random();
          int value = random.nextInt(2);

          if (value == 0) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    const ColorMatchingGame(item: 'Vital Signs Equipment')));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    NumberMatchingGame(item: 'Vital Signs Equipment')));
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/MEDTECH ROOM - Copy.png'))),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, right: 50),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
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
      ),
    );
  }
}

class PatientMonitor extends StatelessWidget {
  const PatientMonitor({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final random = math.Random();
        int value = random.nextInt(2);

        if (value == 0) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  const ColorMatchingGame(item: 'Patient Monitor')));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  NumberMatchingGame(item: 'Patient Monitor')));
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/new/tablet_pink.png'))),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 50),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
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
