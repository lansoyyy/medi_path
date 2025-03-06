import 'dart:math';

import 'package:flutter/material.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/show_dialog.dart';
import 'package:medi_path/widgets/text_widget.dart';
import 'package:medi_path/widgets/toast_widget.dart';

class NumberMatchingGame extends StatefulWidget {
  String item;

  NumberMatchingGame({super.key, required this.item});

  @override
  State<NumberMatchingGame> createState() => _NumberMatchingGameState();
}

class _NumberMatchingGameState extends State<NumberMatchingGame> {
  final List<int> numbers = [1, 2, 3, 4];
  late List<int> shuffledNumbers;
  int? selectedNumber;
  int selectedIndex = -1;
  int matchedPairs = 0;

  @override
  void initState() {
    super.initState();
    _shuffleNumbers();
  }

  void _shuffleNumbers() {
    shuffledNumbers = List<int>.from(numbers + numbers);
    shuffledNumbers.shuffle(Random());
    matchedPairs = 0;
    selectedNumber = null;
    selectedIndex = -1;
  }

  void _onNumberSelected(int index) {
    setState(() {
      if (selectedNumber == null) {
        selectedNumber = shuffledNumbers[index];
        selectedIndex = index;
      } else {
        if (selectedNumber == shuffledNumbers[index] &&
            selectedIndex != index) {
          matchedPairs++;
          if (matchedPairs == numbers.length) {
            _showGameFinishedDialog();
          }
        }
        selectedNumber = null;
        selectedIndex = -1;
      }
    });
  }

  void _showGameFinishedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Completed!'),
        content: const Text('Congratulations! You matched all the numbers.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              setState(() {
                currentItems.add(widget.item);
                _shuffleNumbers();
              });

              showToast('${widget.item} is added to bag!');
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
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
      appBar: AppBar(title: const Text('Match the Numbers')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: shuffledNumbers.length,
        itemBuilder: (context, index) {
          bool isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => _onNumberSelected(index),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${shuffledNumbers[index]}',
                  style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
