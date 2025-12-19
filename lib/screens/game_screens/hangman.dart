import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/show_dialog.dart';
import 'package:medi_path/widgets/toast_widget.dart';
import 'package:get/get.dart';

class HangmanGame extends StatefulWidget {
  final String item;

  const HangmanGame({super.key, required this.item});

  @override
  State<HangmanGame> createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame>
    with TickerProviderStateMixin {
  final int _maxLives = 6;
  late int _wrongGuesses;
  late Set<String> _guessedLetters;
  late Map<String, String> _currentWordEntry;
  bool _isGameFinished = false;

  // Timer
  int _timeElapsed = 0;
  late Timer _gameTimer;

  // Animation controllers
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late AnimationController _confettiController;
  late Animation<double> _confettiAnimation;

  // Track which letter was just revealed for animation
  Set<int> _revealedIndices = {};

  final List<Map<String, String>> _wordBank = [
    {
      'word': 'nurse',
      'hint': 'A healthcare professional who takes care of patients.'
    },
    {
      'word': 'doctor',
      'hint': 'A medical professional who diagnoses and treats illnesses.'
    },
    {
      'word': 'virus',
      'hint': 'A tiny organism that can cause infectious diseases.'
    },
    {
      'word': 'oxygen',
      'hint': 'The gas in the air that our body needs to breathe.'
    },
    {
      'word': 'pharmacy',
      'hint': 'The place where medicines are prepared and given to patients.'
    },
    {
      'word': 'surgery',
      'hint': 'A medical procedure where doctors operate on the body.'
    },
    {
      'word': 'vitals',
      'hint': 'Important body measurements like heart rate and temperature.'
    },
    {
      'word': 'tablet',
      'hint': 'A small solid form of medicine that you swallow.'
    },
    {
      'word': 'capsule',
      'hint': 'Medicine in a small shell that dissolves in the stomach.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startNewRound();
    _startTimer();
  }

  void _initAnimations() {
    // Shake animation for wrong guesses
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    // Pulse animation for selected items
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Bounce animation for correct letters
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    // Confetti animation for winning
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _confettiAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _confettiController, curve: Curves.easeOut),
    );
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isGameFinished && mounted) {
        setState(() {
          _timeElapsed++;
        });
      }
    });
  }

  void _stopTimer() {
    _gameTimer.cancel();
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _pulseController.dispose();
    _bounceController.dispose();
    _confettiController.dispose();
    _stopTimer();
    super.dispose();
  }

  void _startNewRound() {
    _wrongGuesses = 0;
    _guessedLetters = <String>{};
    _isGameFinished = false;
    _revealedIndices = {};
    _timeElapsed = 0;
    _currentWordEntry = _wordBank[Random().nextInt(_wordBank.length)];
    setState(() {});
  }

  String get _word => _currentWordEntry['word']!.toUpperCase();
  String get _hint => _currentWordEntry['hint']!;

  bool get _isWin {
    final letters = _word.split("").toSet();
    final onlyLetters = letters.where((c) => RegExp(r'[A-Z]').hasMatch(c));
    return onlyLetters.every((c) => _guessedLetters.contains(c));
  }

  void _onLetterTap(String letter) {
    if (_isGameFinished || _guessedLetters.contains(letter)) return;

    HapticFeedback.lightImpact();

    setState(() {
      _guessedLetters.add(letter);

      if (_word.contains(letter)) {
        // Correct guess - trigger bounce animation and track revealed indices
        HapticFeedback.heavyImpact();
        _bounceController.forward().then((_) => _bounceController.reset());

        // Find indices where this letter appears
        for (int i = 0; i < _word.length; i++) {
          if (_word[i] == letter) {
            _revealedIndices.add(i);
          }
        }
      } else {
        // Wrong guess - trigger shake and heart animations
        _wrongGuesses++;
        HapticFeedback.mediumImpact();
        _shakeController.forward().then((_) => _shakeController.reset());
      }

      if (_isWin) {
        _stopTimer();
        _isGameFinished = true;
        _confettiController.forward();
        Future.delayed(const Duration(milliseconds: 500), () {
          _showResultDialog(true);
        });
      } else if (_wrongGuesses >= _maxLives) {
        _stopTimer();
        _isGameFinished = true;
        _shakeController.forward();
        Future.delayed(const Duration(milliseconds: 500), () {
          _showResultDialog(false);
        });
      }
    });
  }

  // Calculate progress percentage
  double get _progress {
    final totalLetters =
        _word.split('').where((c) => RegExp(r'[A-Z]').hasMatch(c)).toSet();
    final guessedCorrect =
        totalLetters.where((c) => _guessedLetters.contains(c));
    return guessedCorrect.length / totalLetters.length;
  }

  void _showResultDialog(bool isWin) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isWin
                      ? const [
                          Color(0xFF87CEEB),
                          Color(0xFF98D8E8),
                          Color(0xFFB0E0E6)
                        ]
                      : const [
                          Color(0xFFFFB6B6),
                          Color(0xFFFF9999),
                          Color(0xFFFFCCCC)
                        ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isWin ? const Color(0xFF2E86AB) : Colors.red)
                        .withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Row(
                  // Split dialog content for landscape
                  children: [
                    // Result Visual Side
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isWin
                                ? const [Color(0xFF2E86AB), Color(0xFF3498DB)]
                                : const [Color(0xFFE74C3C), Color(0xFFC0392B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isWin ? '🎉' : '💔',
                              style: const TextStyle(fontSize: 60),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isWin ? 'AWESOME!' : 'OH NO!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isWin ? 'You solved it!' : 'Try again?',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Stats & Action Side
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'THE WORD WAS',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _word,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: isWin
                                          ? const Color(0xFF27AE60)
                                          : const Color(0xFFE74C3C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Stats Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem(
                                  Icons.timer,
                                  _formatTime(_timeElapsed),
                                  'Time',
                                ),
                                _buildStatItem(
                                  Icons.error_outline,
                                  '$_wrongGuesses',
                                  'Mistakes',
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Get.back(); // Go back to home
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade200,
                                      foregroundColor: Colors.grey.shade700,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Exit'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      if (isWin) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        setState(() {
                                          currentItems.add(widget.item);
                                          unlockNotebookItem(widget.item);
                                          unlockNotebookItem(
                                              _word.toLowerCase());
                                        });
                                        showToast(
                                            '${widget.item} has been added to the bag!');
                                      } else {
                                        Navigator.pop(context);
                                        _startNewRound();
                                        _startTimer();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isWin
                                          ? const Color(0xFF2E86AB)
                                          : const Color(0xFFE74C3C),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      elevation: 4,
                                      shadowColor: (isWin
                                              ? const Color(0xFF2E86AB)
                                              : const Color(0xFFE74C3C))
                                          .withOpacity(0.4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      isWin ? 'Continue' : 'Play Again',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
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
      },
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF2E86AB), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildWordDisplay() {
    final wordChars = _word.split('');

    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: List.generate(wordChars.length, (index) {
            final char = wordChars[index];
            final isLetter = RegExp(r'[A-Z]').hasMatch(char);
            final isGuessed = _guessedLetters.contains(char);
            final isNewlyRevealed = _revealedIndices.contains(index);

            // Scale animation for newly revealed letters
            double scale = 1.0;
            if (isNewlyRevealed && _bounceAnimation.value < 1.0) {
              scale = 0.8 + (_bounceAnimation.value * 0.2);
            }

            return Transform.scale(
              scale: scale,
              child: Container(
                width: 32,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isGuessed
                        ? const [Color(0xFF27AE60), Color(0xFF2ECC71)]
                        : const [Colors.white, Color(0xFFF8F9FA)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: isGuessed
                          ? const Color(0xFF27AE60).withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: isGuessed ? 8 : 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: isGuessed
                        ? const Color(0xFF27AE60)
                        : const Color(0xFFE0E0E0),
                    width: 2,
                  ),
                ),
                child: Text(
                  isLetter && isGuessed ? char : '_',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isGuessed ? Colors.white : const Color(0xFF2E86AB),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildKeyboard() {
    final letters =
        List<String>.generate(26, (index) => String.fromCharCode(65 + index));

    return AnimatedBuilder(
      animation: Listenable.merge([_shakeAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            sin(_shakeAnimation.value * 15) * 3 * (1 - _shakeAnimation.value),
            0,
          ),
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1.0,
            ),
            itemCount: letters.length,
            itemBuilder: (context, index) {
              final letter = letters[index];
              final isUsed = _guessedLetters.contains(letter);
              final isCorrect = isUsed && _word.contains(letter);
              final isWrong = isUsed && !_word.contains(letter);

              return GestureDetector(
                onTap: () => _onLetterTap(letter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isCorrect
                          ? const [Color(0xFF27AE60), Color(0xFF2ECC71)]
                          : isWrong
                              ? const [Color(0xFFE74C3C), Color(0xFFC0392B)]
                              : isUsed
                                  ? [Colors.grey.shade400, Colors.grey.shade500]
                                  : const [
                                      Color(0xFF3498DB),
                                      Color(0xFF2E86AB)
                                    ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: isCorrect
                            ? const Color(0xFF27AE60).withOpacity(0.4)
                            : isWrong
                                ? const Color(0xFFE74C3C).withOpacity(0.4)
                                : isUsed
                                    ? Colors.transparent
                                    : const Color(0xFF2E86AB).withOpacity(0.3),
                        blurRadius: isUsed ? 0 : 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(isUsed ? 0.2 : 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isUsed ? 0.6 : 1.0,
                    child: Center(
                      child: Text(
                        letter,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          shadows: isUsed
                              ? null
                              : [
                                  const Shadow(
                                    color: Colors.black26,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
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
    );
  }

  Widget _buildHearts() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_maxLives, (index) {
        final isLost = index < _wrongGuesses;
        return AnimatedScale(
          scale: isLost ? 0.8 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              isLost ? Icons.favorite_border : Icons.favorite,
              color: isLost
                  ? Colors.grey.withOpacity(0.5)
                  : const Color(0xFFFF5F6D),
              size: 32,
            ),
          ),
        );
      }),
    );
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
                // LEFT PANEL: Stats, Hint, Character/Theme
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                                    'Medi-Word',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF2E86AB),
                                    ),
                                  ),
                                  Text(
                                    'Level 1',
                                    style: TextStyle(
                                      fontSize: 16,
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

                        const Spacer(),

                        // Hint Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2E86AB), Color(0xFF3498DB)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2E86AB).withOpacity(0.3),
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
                                    child: const Icon(Icons.lightbulb,
                                        color: Colors.yellow, size: 24),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'HINT',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _hint,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Bottom Stats Panel
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
                                  Row(
                                    children: [
                                      const Icon(Icons.timer_outlined,
                                          color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        _formatTime(_timeElapsed),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2C3E50),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F6F3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${(_progress * 100).toInt()}% Done',
                                      style: const TextStyle(
                                        color: Color(0xFF27AE60),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              _buildHearts(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // RIGHT PANEL: Game Board
                Expanded(
                  flex: 6,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),
                        // Word Display
                        _buildWordDisplay(),
                        const Spacer(flex: 3),
                        // Keyboard
                        _buildKeyboard(),
                        const Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Confetti overlay
          if (_isGameFinished && _isWin)
            IgnorePointer(
              child: AnimatedBuilder(
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
                            const Color(0xFF27AE60).withOpacity(0.1),
                            const Color(0xFF27AE60).withOpacity(0.2),
                          ],
                          stops: const [0.0, 0.5, 1.0],
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
