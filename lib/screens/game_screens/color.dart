import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _confettiController;
  late Animation<double> _confettiAnimation;

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

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _confettiAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOut,
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

    HapticFeedback.lightImpact(); // Add haptic feedback

    setState(() {
      if (selectedMedicine == null) {
        selectedMedicine = shuffledMedicines[index];
        selectedIndex = index;
        _bounceController.forward().then((_) => _bounceController.reset());
      } else {
        moves++;
        if (selectedMedicine == shuffledMedicines[index] &&
            selectedIndex != index) {
          // Match found
          matchedPairs++;
          HapticFeedback.heavyImpact(); // Success haptic

          // Mark matched cards as empty
          shuffledMedicines[selectedIndex] = '';
          shuffledMedicines[index] = '';

          _fadeController.forward();

          if (matchedPairs == medicineImages.length) {
            _stopTimer();
            isGameFinished = true;
            _confettiController.forward();
            Future.delayed(const Duration(milliseconds: 500), () {
              _showGameFinishedDialog();
            });
          }
        } else {
          // No match
          HapticFeedback.mediumImpact(); // Error haptic
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
    _bounceController.dispose();
    _fadeController.dispose();
    _confettiController.dispose();
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF0F8FF), // Light medical theme background
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E86AB), Color(0xFF3498DB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E86AB).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
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
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          showTaskDialog();
        },
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF2E86AB),
        elevation: 0,
        title: TextWidget(
          text:
              'Find matching pairs of medicines. Tap on two cards to see if they match!',
          fontSize: 14,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
        actions: [
          // Enhanced game stats
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3498DB), Color(0xFF2E86AB)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    _formatTime(timeElapsed),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.swap_horiz, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
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
      body: Stack(
        children: [
          // Confetti effect overlay
          if (isGameFinished)
            AnimatedBuilder(
              animation: _confettiAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _confettiAnimation.value,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.2),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                );
              },
            ),

          Column(
            children: [
              // Enhanced progress indicator at top
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFF0F8FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress: $matchedPairs / ${medicineImages.length}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E86AB),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${((matchedPairs / medicineImages.length) * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.grey.shade300,
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: matchedPairs / medicineImages.length,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Game grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Better layout for tablets
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: shuffledMedicines.length,
                    itemBuilder: (context, index) {
                      bool isSelected = index == selectedIndex;
                      bool isEmpty = shuffledMedicines[index] == '';

                      if (isEmpty) {
                        // Enhanced empty slot with fade animation
                        return AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: const Color(0xFF27AE60),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF27AE60),
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return GestureDetector(
                        onTap: () => _onMedicineSelected(index),
                        child: AnimatedBuilder(
                          animation: Listenable.merge(
                              [_pulseAnimation, _bounceAnimation]),
                          builder: (context, child) {
                            return Transform.scale(
                              scale: isSelected ? _pulseAnimation.value : 1.0,
                              child: Transform.rotate(
                                angle: isSelected
                                    ? _bounceAnimation.value * 0.1
                                    : 0.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        medicineColors[
                                                shuffledMedicines[index]]!
                                            .withOpacity(0.9),
                                        medicineColors[
                                            shuffledMedicines[index]]!,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(3, 3),
                                        spreadRadius: 1,
                                      ),
                                      if (isSelected)
                                        BoxShadow(
                                          color: medicineColors[
                                                  shuffledMedicines[index]]!
                                              .withOpacity(0.4),
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                        ),
                                    ],
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.6),
                                      width: isSelected ? 3 : 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        shuffledMedicines[index],
                                        height: 80,
                                        color: shuffledMedicines[index] ==
                                                'assets/images/new/tablet_pink.png'
                                            ? Colors.white
                                            : null,
                                      ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
