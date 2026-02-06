import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/show_dialog.dart';
import 'package:medi_path/widgets/toast_widget.dart';
import 'package:medi_path/utils/colors.dart';

class NumberMatchingGame extends StatefulWidget {
  String item;

  NumberMatchingGame({super.key, required this.item});

  @override
  State<NumberMatchingGame> createState() => _NumberMatchingGameState();
}

class _NumberMatchingGameState extends State<NumberMatchingGame>
    with TickerProviderStateMixin {
  final List<int> numbers = [1, 2, 3, 4, 5, 6];
  late List<int> shuffledNumbers;
  int? selectedNumber;
  int selectedIndex = -1;
  int matchedPairs = 0;
  int moves = 0;
  int timeElapsed = 0;
  late Timer gameTimer;
  bool isGameFinished = false;
  bool canFlip = true;

  // Track mismatch state for visual feedback
  bool _showMismatch = false;
  int _mismatchIndex1 = -1;
  int _mismatchIndex2 = -1;

  // Animation controllers
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
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
    _shuffleNumbers();
    _startTimer();

    // Initialize animations
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticOut,
    ));

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

  void _shuffleNumbers() {
    shuffledNumbers = List<int>.from(numbers + numbers);
    shuffledNumbers.shuffle(Random());
    matchedPairs = 0;
    selectedNumber = null;
    selectedIndex = -1;
    moves = 0;
    timeElapsed = 0;
    isGameFinished = false;
    canFlip = true;
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

  void _onNumberSelected(int index) {
    if (isGameFinished || !canFlip || shuffledNumbers[index] == -1) return;

    HapticFeedback.lightImpact(); // Add haptic feedback

    setState(() {
      if (selectedNumber == null) {
        selectedNumber = shuffledNumbers[index];
        selectedIndex = index;
        _flipController.forward();
        _bounceController.forward().then((_) => _bounceController.reset());
      } else {
        moves++;
        if (selectedNumber == shuffledNumbers[index] &&
            selectedIndex != index) {
          // Match found
          matchedPairs++;
          HapticFeedback.heavyImpact(); // Success haptic

          // Mark matched cards as empty (-1)
          shuffledNumbers[selectedIndex] = -1;
          shuffledNumbers[index] = -1;

          _fadeController.forward();

          if (matchedPairs == numbers.length) {
            _stopTimer();
            isGameFinished = true;
            _confettiController.forward();
            Future.delayed(const Duration(milliseconds: 500), () {
              _showGameFinishedDialog();
            });
          }
        } else {
          // No match - enhanced shake animation with visual feedback
          HapticFeedback.mediumImpact(); // Error haptic
          canFlip = false;
          _mismatchIndex1 = selectedIndex;
          _mismatchIndex2 = index;
          _showMismatch = true;
          _shakeController.forward().then((_) {
            _shakeController.reset();
            // Reset selection after a short delay
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                setState(() {
                  selectedNumber = null;
                  selectedIndex = -1;
                  canFlip = true;
                  _showMismatch = false;
                  _mismatchIndex1 = -1;
                  _mismatchIndex2 = -1;
                });
              }
            });
          });
        }
        selectedNumber = null;
        selectedIndex = -1;
        _flipController.reverse();
      }
    });
  }

  void _showGameFinishedDialog() {
    int baseScore = matchedPairs * 100;
    int timeBonus = max(0, 500 - (timeElapsed * 5));
    int moveBonus = max(0, 300 - (moves * 2));
    int totalScore = baseScore + timeBonus + moveBonus;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
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
                        Center(
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
                          'Great job! You have successfully matched all numbers.',
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
                              _buildStatItem('⭐', '$totalScore', 'Score'),
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
                              unlockNotebookItem(widget.item);
                              _shuffleNumbers();
                              _startTimer();
                            });

                            showToast('${widget.item} is added to bag!');
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
    _flipController.dispose();
    _shakeController.dispose();
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
      backgroundColor: const Color(0xFFF0F8FF),
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3498DB).withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF27AE60).withOpacity(0.1),
              ),
            ),
          ),

          SafeArea(
            child: Row(
              children: [
                // LEFT PANEL: Stats, Progress, Instructions
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Back Button & Header
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  color: const Color(0xFF2E86AB),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Number Match',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF2E86AB),
                                      ),
                                    ),
                                    Text(
                                      'Level 1',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Task Button
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3498DB),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF3498DB)
                                          .withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.assignment_outlined),
                                  color: Colors.white,
                                  tooltip: 'View Task',
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    showTaskDialog();
                                  },
                                ),
                              ),
                            ],
                          ),

                          // Game Instructions Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2E86AB), Color(0xFF3498DB)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF2E86AB).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.calculate,
                                          color: Colors.yellow, size: 24),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'HOW TO PLAY',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Find matching pairs of numbers! Tap two cards to see if they match.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    height: 1.4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Progress Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Progress',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C3E50),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F6F3),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${((matchedPairs / numbers.length) * 100).toInt()}% Done',
                                        style: const TextStyle(
                                          color: Color(0xFF27AE60),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.shade300,
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: matchedPairs / numbers.length,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF27AE60),
                                            Color(0xFF2ECC71)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '${matchedPairs} / ${numbers.length} Pairs',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Bottom Stats Panel
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.timer_outlined,
                                            color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatTime(timeElapsed),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2C3E50),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.swap_horiz_outlined,
                                            color: Colors.grey),
                                        const SizedBox(width: 8),
                                        Text(
                                          '$moves',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2C3E50),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // RIGHT PANEL: Game Board
                Expanded(
                  flex: 6,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 1),
                        // Game Grid
                        Expanded(
                          flex: 8,
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: shuffledNumbers.length,
                            itemBuilder: (context, index) {
                              bool isSelected = index == selectedIndex;
                              bool isEmpty = shuffledNumbers[index] == -1;

                              if (isEmpty) {
                                return AnimatedBuilder(
                                  animation: _fadeAnimation,
                                  builder: (context, child) {
                                    return Opacity(
                                      opacity: _fadeAnimation.value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF27AE60),
                                              Color(0xFF2ECC71)
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF27AE60)
                                                  .withOpacity(0.3),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }

                              final bool isMismatch = _showMismatch &&
                                  (index == _mismatchIndex1 ||
                                      index == _mismatchIndex2);

                              return GestureDetector(
                                onTap: () => _onNumberSelected(index),
                                child: AnimatedBuilder(
                                  animation: Listenable.merge([
                                    _flipAnimation,
                                    _shakeAnimation,
                                    _pulseAnimation,
                                    _bounceAnimation
                                  ]),
                                  builder: (context, child) {
                                    final double shakeOffset = isMismatch
                                        ? _shakeAnimation.value *
                                            (sin(_shakeAnimation.value * 20) *
                                                5)
                                        : 0.0;

                                    return Transform(
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..translate(shakeOffset),
                                      alignment: Alignment.center,
                                      child: Transform.scale(
                                        scale: isSelected
                                            ? _pulseAnimation.value
                                            : 1.0,
                                        child: Transform.rotate(
                                          angle: isSelected
                                              ? _bounceAnimation.value * 0.1
                                              : 0.0,
                                          child: Container(
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              gradient: isMismatch
                                                  ? const LinearGradient(
                                                      colors: [
                                                        Color(0xFFE74C3C),
                                                        Color(0xFFC0392B),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    )
                                                  : isSelected
                                                      ? const LinearGradient(
                                                          colors: [
                                                            Color(0xFF3498DB),
                                                            Color(0xFF2E86AB),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                        )
                                                      : LinearGradient(
                                                          colors: [
                                                            Colors.blueGrey
                                                                .shade400,
                                                            Colors.blueGrey
                                                                .shade600,
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                        ),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: isMismatch
                                                      ? const Color(0xFFE74C3C)
                                                          .withOpacity(0.5)
                                                      : Colors.black
                                                          .withOpacity(0.2),
                                                  blurRadius:
                                                      isMismatch ? 14 : 10,
                                                  offset: const Offset(3, 3),
                                                  spreadRadius:
                                                      isMismatch ? 2 : 1,
                                                ),
                                                if (isSelected && !isMismatch)
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xFF3498DB)
                                                            .withOpacity(0.4),
                                                    blurRadius: 20,
                                                    spreadRadius: 3,
                                                  ),
                                              ],
                                            ),
                                            child: Center(
                                              child: _flipAnimation.value > 0.5
                                                  ? Text(
                                                      '${shuffledNumbers[index]}',
                                                      style: const TextStyle(
                                                        fontSize: 28,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        shadows: [
                                                          Shadow(
                                                            color:
                                                                Colors.black26,
                                                            offset:
                                                                Offset(1, 1),
                                                            blurRadius: 2,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Icon(
                                                      Icons.help_outline,
                                                      size: 32,
                                                      color: Colors.white
                                                          .withOpacity(0.9),
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
                        const Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

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
        ],
      ),
    );
  }
}
