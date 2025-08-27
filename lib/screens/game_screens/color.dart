import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/show_dialog.dart';
import 'package:medi_path/widgets/text_widget.dart';
import 'package:medi_path/widgets/toast_widget.dart';
import 'package:medi_path/utils/colors.dart';

class ColorMatchingGame extends StatefulWidget {
  final String item;

  const ColorMatchingGame({super.key, required this.item});

  @override
  State<ColorMatchingGame> createState() => _ColorMatchingGameState();
}

class _ColorMatchingGameState extends State<ColorMatchingGame>
    with TickerProviderStateMixin {
  final List<String> medicineImages = [
    'assets/images/new/capsule_red_blue.png',
    'assets/images/new/capsule_green_yellow.png',
    'assets/images/new/tablet_white.png',
    'assets/images/new/tablet_pink.png',
    'assets/images/new/syrup_bottle.png',
    'assets/images/new/injection_vial.png'
  ];

  final Map<String, Color> medicineColors = {
    'assets/images/new/capsule_red_blue.png': Colors.redAccent,
    'assets/images/new/capsule_green_yellow.png': Colors.greenAccent,
    'assets/images/new/tablet_white.png': Colors.white,
    'assets/images/new/tablet_pink.png': Colors.pinkAccent,
    'assets/images/new/syrup_bottle.png': Colors.brown,
    'assets/images/new/injection_vial.png': Colors.blueAccent,
  };

  late List<String> shuffledMedicines;
  String? selectedMedicine;
  int selectedIndex = -1;
  int matchedPairs = 0;
  int moves = 0;
  int timeElapsed = 0;
  late Timer gameTimer;
  bool isGameFinished = false;

  // Animation controllers
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _shuffleMedicines();
    _startTimer();

    // Initialize animations
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _shuffleMedicines() {
    shuffledMedicines = List<String>.from(medicineImages + medicineImages);
    shuffledMedicines.shuffle(Random());
    matchedPairs = 0;
    selectedMedicine = null;
    selectedIndex = -1;
    moves = 0;
    timeElapsed = 0;
    isGameFinished = false;
  }

  void _startTimer() {
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isGameFinished) {
        setState(() {
          timeElapsed++;
        });
      }
    });
  }

  void _stopTimer() {
    gameTimer.cancel();
  }

  void _onMedicineSelected(int index) {
    if (isGameFinished || shuffledMedicines[index] == '') return;

    setState(() {
      if (selectedMedicine == null) {
        selectedMedicine = shuffledMedicines[index];
        selectedIndex = index;
      } else {
        moves++;
        if (selectedMedicine == shuffledMedicines[index] &&
            selectedIndex != index) {
          // Match found
          matchedPairs++;
          // Mark matched cards as empty
          shuffledMedicines[selectedIndex] = '';
          shuffledMedicines[index] = '';

          if (matchedPairs == medicineImages.length) {
            _stopTimer();
            isGameFinished = true;
            _showGameFinishedDialog();
          }
        }
        selectedMedicine = null;
        selectedIndex = -1;
      }
    });
  }

  void _showGameFinishedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF87CEEB), // Sky blue matching your theme
                Color(0xFF98D8E8),
                Color(0xFFB0E0E6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // Decorative header
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2E86AB),
                          Color(0xFF3498DB),
                        ],
                      ),
                    ),
                    child: const Stack(
                      children: [
                        // Title
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              '🎉 GAME COMPLETED! 🎉',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.only(
                      top: 100, left: 20, right: 20, bottom: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Great job! You have successfully matched all medicines.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2C3E50),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Stats
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF2E86AB).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem('⏱', '$timeElapsed s', 'Time'),
                              _buildStatItem('🔄', '$moves', 'Moves'),
                              _buildStatItem(
                                  '⭐', '${medicineImages.length}', 'Pairs'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Continue button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            setState(() {
                              currentItems.add(widget.item);
                              _shuffleMedicines();
                              _startTimer();
                            });

                            showToast(
                                '${widget.item} has been added to the bag!');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E86AB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
      ),
    );
  }

  Widget _buildStatItem(String icon, String value, String label) {
    return Column(
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF7F8C8D),
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        child: Badge(
          backgroundColor: Colors.red,
          label: TextWidget(
            text: 'Task',
            fontSize: 12,
            color: Colors.white,
          ),
          child: Image.asset(
            'assets/images/Task sample.PNG',
            height: 50,
          ),
        ),
        onPressed: () {
          showTaskDialog();
        },
      ),
      appBar: AppBar(
        title: TextWidget(
          text:
              'Find matching pairs of medicines. Tap on two cards to see if they match!',
          fontSize: 14,
          fontFamily: 'Bold',
        ),
        actions: [
          // Game stats
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(timeElapsed),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.swap_horiz, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '$moves',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Game grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, // Reduced from 4 to 3 circles per row
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.0,
              ),
              itemCount: shuffledMedicines.length,
              itemBuilder: (context, index) {
                bool isSelected = index == selectedIndex;
                bool isEmpty = shuffledMedicines[index] == '';

                if (isEmpty) {
                  // Empty slot for matched pair
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () => _onMedicineSelected(index),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: isSelected ? _pulseAnimation.value : 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: medicineColors[shuffledMedicines[index]]!,
                            boxShadow: [
                              const BoxShadow(
                                color: Colors.black38,
                                blurRadius: 6,
                                offset: const Offset(3, 3),
                                spreadRadius: 2,
                              ),
                            ],
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.white.withOpacity(0.5),
                              width: isSelected ? 4 : 2,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                shuffledMedicines[index],
                                height:
                                    120, // Dramatically increased image size
                                color: shuffledMedicines[index] ==
                                        'assets/images/new/tablet_pink.png'
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Progress indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Progress: $matchedPairs / ${medicineImages.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: matchedPairs / medicineImages.length,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
