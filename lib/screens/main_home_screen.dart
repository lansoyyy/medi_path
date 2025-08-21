import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_path/screens/bag_screen.dart';
import 'package:medi_path/screens/main_home/doctors_screen.dart';
import 'package:medi_path/screens/main_home/medtech_screen.dart';
import 'package:medi_path/screens/main_home/nurse_screen.dart';
import 'package:medi_path/screens/main_home/patients_screen.dart';
import 'package:medi_path/screens/main_home/pharmacy_screen.dart';
import 'package:medi_path/screens/main_home/reception_screen.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/show_dialog.dart';
import 'package:medi_path/widgets/text_widget.dart';

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

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        showTaskDialog();
      },
    );
  }

  getCompleted() {
    if (currentLevel == 1) {
      if (currentItems.contains('Pillow') &&
          currentItems.contains('Food') &&
          currentItems.contains('Medicine Prescriptions') &&
          currentItems.contains('Vital Signs Equipment') &&
          currentItems.contains('Prescribed Medicine (2)')) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                  title: const Text(
                    'Level Completed!',
                    style: TextStyle(
                        fontFamily: 'QBold', fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                    'You completed the Level 1 Challenge!',
                    style: TextStyle(fontFamily: 'QRegular'),
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () async {
                        setState(() {
                          currentLevel = 2;
                        });

                        Navigator.pop(context);
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //       builder: (context) => const LoginScreen()),
                        // );
                      },
                      child: const Text(
                        'Continue Next Level',
                        style: TextStyle(
                            fontFamily: 'QRegular',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ));
      }
    } else {
      if (currentItems.contains('Pillow') &&
          currentItems.contains('Food') &&
          currentItems.contains('Medicine Prescriptions') &&
          currentItems.contains('Vital Signs Equipment') &&
          currentItems.contains('Prescribed Medicine (2)') &&
          currentItems.contains('X-Ray') &&
          currentItems.contains('Oximeter')) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                  title: const Text(
                    'Level Completed!',
                    style: TextStyle(
                        fontFamily: 'QBold', fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                    'You completed the whole Challenge!',
                    style: TextStyle(fontFamily: 'QRegular'),
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //       builder: (context) => const LoginScreen()),
                        // );
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(
                            fontFamily: 'QRegular',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getCompleted();
      },
    );
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Enhanced coin display
          Builder(builder: (context) {
            int coins = 0;
            if (currentItems.contains('Pillow') &&
                currentItems.contains('Food')) {
              coins += 50;
            }
            if (currentItems.contains('Medicine Prescriptions')) {
              coins += 100;
            }
            if (currentItems.contains('Vital Signs Equipment')) {
              coins += 200;
            }
            if (currentItems.contains('Prescribed Medicine (2)')) {
              coins += 150;
            }
            if (currentItems.contains('X-Ray')) {
              coins += 300;
            }
            if (currentItems.contains('Oximeter')) {
              coins += 250;
            }

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFFC107), // Gold
                    const Color(0xFFFFB300), // Darker gold
                    const Color(0xFFF57F17), // Deep amber
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFC107).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Coin icon with glow effect
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/Medicoin 3d.PNG',
                        height: 38,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Coin amount with enhanced styling
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '$coins',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontFamily: 'Bold',
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                            Shadow(
                              color: const Color(0xFFF57F17).withOpacity(0.8),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(width: 20),

          // Enhanced medical bag button
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2E86AB), // Medical blue
                  Color(0xFF3498DB), // Lighter blue
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E86AB).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(26),
              child: InkWell(
                borderRadius: BorderRadius.circular(26),
                onTap: () {
                  // Add haptic feedback
                  // HapticFeedback.mediumImpact();
                  Get.to(() => const BagScreen(),
                      transition: Transition.leftToRightWithFade);
                },
                child: Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      // Medical bag with enhanced styling
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/open-box.png',
                            height: 32,
                            color: Colors.white.withOpacity(0.95),
                          ),
                        ),
                      ),

                      // Enhanced badge
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFE74C3C), // Medical red
                                Color(0xFFC0392B), // Darker red
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFE74C3C).withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          child: const Text(
                            'BAG',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Medical cross indicator
                      Positioned(
                        bottom: 2,
                        left: 2,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF27AE60), // Medical green
                                Color(0xFF2ECC71), // Lighter green
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF27AE60).withOpacity(0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.medical_services,
                            color: Colors.white,
                            size: 10,
                          ),
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
      body: Stack(
        children: [
          Container(
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
          Positioned(
            bottom: 190,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const ReceptionScreen(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 260,
                height: 160,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 220,
            left: 280,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const NurseScreen(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 220,
                height: 150,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 240,
            left: 460,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const DoctorScreen(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 280,
                height: 150,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const MedTechScreen(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 350,
                height: 180,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 310,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const PatientScreen(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 240,
                height: 220,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 510,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const PharmacyScreen(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 300,
                height: 250,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
