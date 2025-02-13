import 'dart:math';

import 'package:flutter/material.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/toast_widget.dart';

class ColorMatchingGame extends StatefulWidget {
  String item;

  ColorMatchingGame({super.key, required this.item});

  @override
  State<ColorMatchingGame> createState() => _ColorMatchingGameState();
}

class _ColorMatchingGameState extends State<ColorMatchingGame> {
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow
  ];
  late List<Color> shuffledColors;
  Color? selectedColor;
  int selectedIndex = -1;
  int matchedPairs = 0;

  @override
  void initState() {
    super.initState();
    _shuffleColors();
  }

  void _shuffleColors() {
    shuffledColors = List<Color>.from(colors + colors);
    shuffledColors.shuffle(Random());
    matchedPairs = 0;
    selectedColor = null;
    selectedIndex = -1;
  }

  void _onColorSelected(int index) {
    setState(() {
      if (selectedColor == null) {
        selectedColor = shuffledColors[index];
        selectedIndex = index;
      } else {
        if (selectedColor == shuffledColors[index] && selectedIndex != index) {
          matchedPairs++;
          if (matchedPairs == colors.length) {
            _showGameFinishedDialog();
          }
        }
        selectedColor = null;
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
        content: const Text('Congratulations! You matched all the colors.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              setState(() {
                currentItems.add(widget.item);
                _shuffleColors();
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
      appBar: AppBar(title: const Text('Match the Colors')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: shuffledColors.length,
        itemBuilder: (context, index) {
          bool isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => _onColorSelected(index),
            child: Container(
              decoration: BoxDecoration(
                color: shuffledColors[index],
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
