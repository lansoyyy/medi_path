import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:medi_path/screens/game_screens/number.dart';
import 'package:medi_path/widgets/text_widget.dart';

class MedTechScreen extends StatefulWidget {
  const MedTechScreen({super.key});

  @override
  State<MedTechScreen> createState() => _MedTechScreenState();
}

class _MedTechScreenState extends State<MedTechScreen> {
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
                          '🧑‍🔬 Medtech John: "Hello! Please check the patient’s vital signs, including blood pressure, heart rate, xray and temperature."',
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
                  child: Image.asset('assets/images/medtech.png'),
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
                    "assets/images/MEDTECH ROOM.png",
                  ),
                  fit: BoxFit.fitHeight),
            ),
          ),
          Positioned(
            bottom: 120,
            left: 200,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const BloodTest(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 350,
                height: 80,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            left: 620,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const XRay(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 60,
                height: 60,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
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

class XRay extends StatelessWidget {
  const XRay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                  'assets/images/Screenshot_2025-01-27_221331-removebg-preview.png'))),
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

class BloodTest extends StatefulWidget {
  const BloodTest({super.key});

  @override
  State<BloodTest> createState() => _BloodTestState();
}

class _BloodTestState extends State<BloodTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  NumberMatchingGame(item: 'Vital Signs Equipment')));
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/MEDTECH ROOM - Copy.png'))),
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
      ),
    );
  }
}
