import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:medi_path/screens/game_screens/color.dart';
import 'package:medi_path/screens/game_screens/number.dart';
import 'package:medi_path/screens/main_home_screen.dart';
import 'package:medi_path/widgets/show_dialog.dart';
import 'package:medi_path/widgets/text_widget.dart';

class NurseScreen extends StatefulWidget {
  const NurseScreen({super.key});

  @override
  State<NurseScreen> createState() => _NurseScreenState();
}

class _NurseScreenState extends State<NurseScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        showDoctorDialog(context);
      },
    );
  }

  void showDoctorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 60), // Space for the doctor's image
                    TextWidget(
                      text:
                          '👩‍⚕️ Nurse Anna: Hi! Please get a pillow and some food for the patient.',
                      fontSize: 14,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it!'),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -60,
                left: 80,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/images/nurse.png'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/NURSE ROOM.png',
                  ),
                  fit: BoxFit.fitHeight),
            ),
          ),
          Positioned(
            bottom: 150,
            left: 120,
            child: GestureDetector(
              onTap: () {
                showTaskDialog();
              },
              child: Container(
                width: 120,
                height: 150,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 300,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const Pillow(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 175,
                height: 175,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 70,
            left: 530,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const Fridge(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 200,
                height: 300,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 500,
            child: GestureDetector(
              onTap: () {
                Get.off(() => const MainHomeScreen(),
                    transition: Transition.leftToRightWithFade);
              },
              child: Container(
                width: 280,
                height: 100,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Fridge extends StatelessWidget {
  const Fridge({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NumberMatchingGame(item: 'Food')));
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                    'assets/images/Screenshot_2025-01-31_221338-removebg-preview.png'))),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 50),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
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
}

class Pillow extends StatelessWidget {
  const Pillow({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ColorMatchingGame(item: 'Pillow')));
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage('assets/images/NURSE ROOM - Copy.png'))),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 50),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
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
}
