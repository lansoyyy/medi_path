import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _MainHomeScreenState extends State<MainHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;
  bool _showRoomHints = false;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _floatAnimation = Tween<double>(
      begin: -5,
      end: 5,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        showTaskDialog();
        // Auto-hide room hints after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              _showRoomHints = false;
            });
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
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

  Widget _buildRoomButton({
    required String roomName,
    required VoidCallback onTap,
    required Widget targetScreen,
    required double bottom,
    required double left,
    required double width,
    required double height,
    IconData? icon,
    Color? accentColor,
  }) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: bottom + (_showRoomHints ? _floatAnimation.value : 0),
          left: left,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Get.to(() => targetScreen, transition: Transition.circularReveal);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: _showRoomHints
                    ? (accentColor ?? Colors.blue).withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: _showRoomHints
                    ? Border.all(
                        color: (accentColor ?? Colors.blue).withOpacity(0.3),
                        width: 2,
                      )
                    : null,
                boxShadow: _showRoomHints
                    ? [
                        BoxShadow(
                          color: (accentColor ?? Colors.blue).withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: _showRoomHints
                  ? Stack(
                      children: [
                        Center(
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (accentColor ?? Colors.blue)
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    icon ?? Icons.location_on,
                                    color: accentColor ?? Colors.blue,
                                    size: 24,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              roomName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        );
      },
    );
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
                gradient: const LinearGradient(
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
          // Enhanced background with subtle overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/8.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Subtle gradient overlay for better contrast
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.transparent,
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
          ),

          // Room buttons with enhanced UI
          _buildRoomButton(
            roomName: 'RECEPTION',
            onTap: () {},
            targetScreen: const ReceptionScreen(),
            bottom: 190,
            left: 20,
            width: 260,
            height: 160,
            icon: Icons.desk,
            accentColor: Colors.purple,
          ),

          _buildRoomButton(
            roomName: 'NURSE OFFICE',
            onTap: () {},
            targetScreen: const NurseScreen(),
            bottom: 220,
            left: 280,
            width: 220,
            height: 150,
            icon: Icons.medical_services,
            accentColor: Colors.green,
          ),

          _buildRoomButton(
            roomName: "DOCTOR'S ROOM",
            onTap: () {},
            targetScreen: const DoctorScreen(),
            bottom: 240,
            left: 460,
            width: 280,
            height: 150,
            icon: Icons.local_hospital,
            accentColor: Colors.blue,
          ),

          _buildRoomButton(
            roomName: 'MEDTECH LAB',
            onTap: () {},
            targetScreen: const MedTechScreen(),
            bottom: 10,
            left: 10,
            width: 350,
            height: 180,
            icon: Icons.biotech,
            accentColor: Colors.orange,
          ),

          _buildRoomButton(
            roomName: 'PATIENT ROOM',
            onTap: () {},
            targetScreen: const PatientScreen(),
            bottom: 20,
            left: 310,
            width: 240,
            height: 220,
            icon: Icons.bed,
            accentColor: Colors.red,
          ),

          _buildRoomButton(
            roomName: 'PHARMACY',
            onTap: () {},
            targetScreen: const PharmacyScreen(),
            bottom: 20,
            left: 510,
            width: 300,
            height: 250,
            icon: Icons.medication,
            accentColor: Colors.teal,
          ),

          // Level indicator
          Positioned(
            top: 60,
            left: 20,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value * 0.1 + 0.9,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          const Color(0xFF6A5ACD),
                          const Color(0xFF9370DB),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.stars,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'LEVEL $currentLevel',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Progress indicator
          Positioned(
            top: 60,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Builder(builder: (context) {
                List<String> requiredItems = currentLevel == 1
                    ? levelOneRequiredItems
                    : levelTwoRequiredItems;
                int completedItems = requiredItems
                    .where((item) => currentItems.contains(item))
                    .length;
                return Text(
                  '$completedItems/${requiredItems.length} TASKS',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
            ),
          ),

          // Hint toggle button
          Positioned(
            bottom: 120,
            right: 20,
            child: AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value * 0.5),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _showRoomHints = !_showRoomHints;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _showRoomHints
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFF757575),
                            _showRoomHints
                                ? const Color(0xFF66BB6A)
                                : const Color(0xFF9E9E9E),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_showRoomHints ? Colors.green : Colors.grey)
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _showRoomHints
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
