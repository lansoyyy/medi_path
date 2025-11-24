import 'dart:math';

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

class _HangmanGameState extends State<HangmanGame> {
  final int _maxLives = 6;
  late int _wrongGuesses;
  late Set<String> _guessedLetters;
  late Map<String, String> _currentWordEntry;
  bool _isGameFinished = false;

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
    _startNewRound();
  }

  void _startNewRound() {
    _wrongGuesses = 0;
    _guessedLetters = <String>{};
    _isGameFinished = false;
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
      if (!_word.contains(letter)) {
        _wrongGuesses++;
      }

      if (_isWin) {
        _isGameFinished = true;
        _showResultDialog(true);
      } else if (_wrongGuesses >= _maxLives) {
        _isGameFinished = true;
        _showResultDialog(false);
      }
    });
  }

  void _showResultDialog(bool isWin) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF87CEEB),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2E86AB), Color(0xFF3498DB)],
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          isWin ? '🎉 WELL DONE! 🎉' : '⚠️ TRY AGAIN ⚠️',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isWin
                              ? 'You correctly guessed the medical word "${_word.toUpperCase()}"!'
                              : 'The correct word was "${_word.toUpperCase()}".',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2C3E50),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Hint: $_hint',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (isWin) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              setState(() {
                                currentItems.add(widget.item);
                              });
                              showToast(
                                  '${widget.item} has been added to the bag!');
                            } else {
                              Navigator.pop(context);
                              _startNewRound();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isWin ? const Color(0xFF2E86AB) : Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            isWin ? 'Continue' : 'Play Again',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWordDisplay() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: _word.split('').map((char) {
        final isLetter = RegExp(r'[A-Z]').hasMatch(char);
        final isGuessed = _guessedLetters.contains(char);
        return Container(
          width: 32,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            isLetter && isGuessed ? char : '_',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E86AB),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKeyboard() {
    final letters =
        List<String>.generate(26, (index) => String.fromCharCode(65 + index));

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.4,
      ),
      itemCount: letters.length,
      itemBuilder: (context, index) {
        final letter = letters[index];
        final isUsed = _guessedLetters.contains(letter);

        return GestureDetector(
          onTap: () => _onLetterTap(letter),
          child: Opacity(
            opacity: isUsed ? 0.3 : 1.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isUsed
                      ? [Colors.grey.shade400, Colors.grey.shade500]
                      : const [Color(0xFF3498DB), Color(0xFF2E86AB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  letter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
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
          text:
              'Guess the medical word! Use the hint and choose the correct letters.',
          fontSize: 14,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFF0F8FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hint',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E86AB),
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 400,
                          child: Text(
                            _hint,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF34495E),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Lives',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E86AB),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(_maxLives, (index) {
                            return Icon(
                              Icons.favorite,
                              size: 18,
                              color: index < (_maxLives - _wrongGuesses)
                                  ? Colors.red
                                  : Colors.grey.shade400,
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildWordDisplay(),
            const SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: _buildKeyboard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
