import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/show_dialog.dart';
import 'package:medi_path/widgets/text_widget.dart';
import 'package:medi_path/widgets/toast_widget.dart';

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
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;

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

    // Heart animation for losing lives
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _heartAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
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
    _heartController.dispose();
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
        _heartController.forward().then((_) => _heartController.reset());
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
    final int livesRemaining = _maxLives - _wrongGuesses;

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
            child: Container(
              width: 340,
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isWin
                                ? const [Color(0xFF2E86AB), Color(0xFF3498DB)]
                                : const [Color(0xFFE74C3C), Color(0xFFC0392B)],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Decorative circles
                            Positioned(
                              top: -20,
                              right: -20,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isWin ? '🎉' : '💔',
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isWin ? 'WELL DONE!' : 'TRY AGAIN',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Word reveal
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                _word,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isWin
                                      ? const Color(0xFF2E86AB)
                                      : const Color(0xFFE74C3C),
                                  letterSpacing: 4,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              _hint,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF7F8C8D),
                                fontStyle: FontStyle.italic,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Stats row
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: (isWin
                                          ? const Color(0xFF2E86AB)
                                          : Colors.red)
                                      .withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatItem(
                                      '⏱', _formatTime(_timeElapsed), 'Time'),
                                  _buildStatItem('❤️',
                                      '$livesRemaining/$_maxLives', 'Lives'),
                                  _buildStatItem('📝',
                                      '${_guessedLetters.length}', 'Guesses'),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Action button
                            ElevatedButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                if (isWin) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  setState(() {
                                    currentItems.add(widget.item);
                                    unlockNotebookItem(widget.item);
                                    unlockNotebookItem(_word.toLowerCase());
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
                                    horizontal: 40, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 6,
                                shadowColor: (isWin
                                        ? const Color(0xFF2E86AB)
                                        : const Color(0xFFE74C3C))
                                    .withOpacity(0.4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isWin ? Icons.check_circle : Icons.refresh,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isWin ? 'Continue' : 'Play Again',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
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

  Widget _buildWordDisplay() {
    final wordChars = _word.split('');

    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
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
                width: 38,
                height: 48,
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
                    fontSize: 22,
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
              crossAxisCount: 9,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.3,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
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
          text: 'Medical Word Challenge',
          fontSize: 16,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
        actions: [
          // Timer and guesses display
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
                    _formatTime(_timeElapsed),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.text_fields, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '${_guessedLetters.length}',
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
          // Confetti overlay when game is won
          if (_isGameFinished && _isWin)
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

          SafeArea(
            child: Column(
              children: [
                // Progress and info card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.white, Color(0xFFF0F8FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress bar row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress: ${(_progress * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E86AB),
                            ),
                          ),
                          // Animated hearts
                          AnimatedBuilder(
                            animation: _heartAnimation,
                            builder: (context, child) {
                              return Row(
                                children: List.generate(_maxLives, (index) {
                                  final isLost =
                                      index >= (_maxLives - _wrongGuesses);
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Transform.scale(
                                      scale: isLost &&
                                              index ==
                                                  (_maxLives - _wrongGuesses)
                                          ? 1.0 - (_heartAnimation.value * 0.3)
                                          : 1.0,
                                      child: Icon(
                                        isLost
                                            ? Icons.favorite_border
                                            : Icons.favorite,
                                        size: 20,
                                        color: isLost
                                            ? Colors.grey.shade400
                                            : Colors.red,
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Animated progress bar
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade300,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: constraints.maxWidth * _progress,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF27AE60),
                                        Color(0xFF2ECC71)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Hint section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9E6),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFFFD54F),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.lightbulb,
                              color: Color(0xFFFFB300),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _hint,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF5D4037),
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Word display
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildWordDisplay(),
                ),

                const SizedBox(height: 16),

                // Keyboard
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: _buildKeyboard(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
