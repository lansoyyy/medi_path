import 'dart:math';

import 'package:flutter/material.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/show_dialog.dart';
import 'package:medi_path/widgets/text_widget.dart';
import 'package:medi_path/widgets/toast_widget.dart';

class ColorMatchingGame extends StatefulWidget {
  final String item;

  const ColorMatchingGame({super.key, required this.item});

  @override
  State<ColorMatchingGame> createState() => _ColorMatchingGameState();
}

class _ColorMatchingGameState extends State<ColorMatchingGame> {
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

  @override
  void initState() {
    super.initState();
    _shuffleMedicines();
  }

  void _shuffleMedicines() {
    shuffledMedicines = List<String>.from(medicineImages + medicineImages);
    shuffledMedicines.shuffle(Random());
    matchedPairs = 0;
    selectedMedicine = null;
    selectedIndex = -1;
  }

  void _onMedicineSelected(int index) {
    setState(() {
      if (selectedMedicine == null) {
        selectedMedicine = shuffledMedicines[index];
        selectedIndex = index;
      } else {
        if (selectedMedicine == shuffledMedicines[index] &&
            selectedIndex != index) {
          matchedPairs++;
          if (matchedPairs == medicineImages.length) {
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
      builder: (context) => AlertDialog(
        title: const Text('Game Completed!'),
        content: const Text(
            'Great job! You have successfully matched all medicines.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              setState(() {
                currentItems.add(widget.item);
                _shuffleMedicines();
              });

              showToast('${widget.item} has been added to the bag!');
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
      appBar: AppBar(title: const Text('Match the Medicines')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: shuffledMedicines.length,
        itemBuilder: (context, index) {
          bool isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => _onMedicineSelected(index),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: medicineColors[shuffledMedicines[index]],
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 4,
                ),
              ),
              child: Center(
                child: Image.asset(
                  shuffledMedicines[index],
                  height: 100,
                  color: shuffledMedicines[index] ==
                          'assets/images/new/tablet_pink.png'
                      ? Colors.white
                      : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
