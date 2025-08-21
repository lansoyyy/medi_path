import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/text_widget.dart';

showImageDialog(String name) {
  Get.dialog(
    barrierDismissible: true,
    Container(
      height: 400,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: AssetImage(
            'assets/images/$name',
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 50),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            decoration:
                const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

showTaskDialog() {
  Get.dialog(
    barrierDismissible: true,
    Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 350,
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
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    // Decorative header with medical theme
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
                        child: Stack(
                          children: [
                            // Medical cross pattern
                            Positioned(
                              top: 10,
                              left: 20,
                              child: Icon(
                                Icons.medical_services,
                                color: Colors.white.withOpacity(0.3),
                                size: 30,
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 80,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red.withOpacity(0.4),
                                size: 25,
                              ),
                            ),
                            // Title
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 100, top: 50),
                              child: const Center(
                                child: Text(
                                  '📋 MISSION BRIEFING',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Enhanced character avatar
                    Positioned(
                      bottom: 190,
                      left: 40,
                      child: Container(
                        width: 90,
                        height: 93,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue[50]!,
                              Colors.blue[100]!,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: const Color(0xFF2E86AB),
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/images/characters/$character.PNG',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Enhanced task list container
                    Positioned(
                      top: 110,
                      left: 40,
                      child: Container(
                        width: 260,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: const Color(0xFF2E86AB).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Task list header
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFF0F8FF),
                                    Color(0xFFE3F2FD),
                                  ],
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(13),
                                  topRight: Radius.circular(13),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.assignment,
                                    color: Color(0xFF2E86AB),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'OBJECTIVES',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF2E86AB),
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Tasks list
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: currentLevel == 1
                                          ? [
                                              for (int i = 0;
                                                  i < levelOneTasks.length;
                                                  i++)
                                                _buildGameTaskItem(i,
                                                    levelOneTasks[i]['task']),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ]
                                          : [
                                              for (int i = 0;
                                                  i < levelTwoTasks.length;
                                                  i++)
                                                _buildGameTaskItem(
                                                    i, levelTwoTasks[i]['task'],
                                                    isLevelTwo: true),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Level indicator badge
                    Positioned(
                      top: 90,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFE74C3C),
                              Color(0xFFC0392B),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          'LEVEL $currentLevel',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Enhanced close button
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 50),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE74C3C),
                      Color(0xFFC0392B),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildGameTaskItem(int index, String taskText,
    {bool isLevelTwo = false}) {
  bool isCompleted = _checkTaskCompletion(index, isLevelTwo);

  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCompleted
              ? [
                  const Color(0xFF27AE60).withOpacity(0.1),
                  const Color(0xFF2ECC71).withOpacity(0.05),
                ]
              : [
                  Colors.grey.shade50,
                  Colors.grey.shade100,
                ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted ? const Color(0xFF27AE60) : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isCompleted
                ? const Color(0xFF27AE60).withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced checkbox with animation
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: isCompleted
                  ? const LinearGradient(
                      colors: [
                        Color(0xFF27AE60),
                        Color(0xFF2ECC71),
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.grey.shade100,
                      ],
                    ),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isCompleted
                    ? const Color(0xFF27AE60)
                    : Colors.grey.shade400,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isCompleted
                      ? const Color(0xFF27AE60).withOpacity(0.3)
                      : Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                    weight: 800,
                  )
                : null,
          ),
          const SizedBox(width: 10),

          // Task text with enhanced styling
          Expanded(
            child: Text(
              taskText,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w500,
                color: isCompleted
                    ? const Color(0xFF27AE60)
                    : const Color(0xFF2C3E50),
                decoration: isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: const Color(0xFF27AE60),
                decorationThickness: 2,
                height: 1.3,
              ),
            ),
          ),

          // Completion badge
          if (isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF27AE60),
                    Color(0xFF2ECC71),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '✓',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

bool _checkTaskCompletion(int index, bool isLevelTwo) {
  if (!isLevelTwo) {
    // Level 1 task completion logic
    switch (index) {
      case 0:
        return currentItems.contains('Pillow') && currentItems.contains('Food');
      case 1:
        return currentItems.contains('Medicine Prescriptions');
      case 2:
        return currentItems.contains('Vital Signs Equipment');
      case 3:
        return currentItems.contains('Prescribed Medicine (2)');
      default:
        return false;
    }
  } else {
    // Level 2 task completion logic
    switch (index) {
      case 0:
        return currentItems.contains('Pillow') && currentItems.contains('Food');
      case 1:
        return currentItems.contains('Medicine Prescriptions');
      case 2:
        return currentItems.contains('Vital Signs Equipment');
      case 3:
        return currentItems.contains('Prescribed Medicine (2)');
      case 4:
        return currentItems.contains('X-Ray');
      case 5:
        return currentItems.contains('Oximeter');
      default:
        return false;
    }
  }
}
