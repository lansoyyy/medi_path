import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
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
            bottom: 175,
            left: 140,
            child: GestureDetector(
              onTap: () {
                Get.dialog(
                  barrierDismissible: true,
                  Container(
                    height: 400,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage(
                          'assets/images/Task sample.PNG',
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 35,
                          left: 305,
                          child: Container(
                            width: 200,
                            height: 165,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
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
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                width: 50,
                height: 75,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 350,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const Pillow(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 580,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const Fridge(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 150,
                height: 200,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 605,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 125,
                height: 50,
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
    return Container(
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
    );
  }
}

class Pillow extends StatelessWidget {
  const Pillow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
