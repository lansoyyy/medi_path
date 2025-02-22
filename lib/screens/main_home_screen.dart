import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_path/screens/bag_screen.dart';
import 'package:medi_path/screens/main_home/doctors_screen.dart';
import 'package:medi_path/screens/main_home/medtech_screen.dart';
import 'package:medi_path/screens/main_home/nurse_screen.dart';
import 'package:medi_path/screens/main_home/patients_screen.dart';
import 'package:medi_path/screens/main_home/pharmacy_screen.dart';
import 'package:medi_path/screens/main_home/reception_screen.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/show_dialog.dart';
import 'package:medi_path/widgets/text_widget.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        showTaskDialog();
      },
    );
  }

  getCompleted() {
    if (currentLevel == 1) {
      if (currentItems.contains('Pillow') &&
          currentItems.contains('Food') &&
          currentItems.contains('Medicine Prescriptions') &&
          currentItems.contains('Vital Signs Equipment') &&
          currentItems.contains('Prescribed Medicine (2)')) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                  title: const Text(
                    'Level Completed!',
                    style: TextStyle(
                        fontFamily: 'QBold', fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                    'You completed the Level 1 Challenge!',
                    style: TextStyle(fontFamily: 'QRegular'),
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () async {
                        setState(() {
                          currentLevel = 2;
                        });

                        Navigator.pop(context);
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //       builder: (context) => const LoginScreen()),
                        // );
                      },
                      child: const Text(
                        'Continue Next Level',
                        style: TextStyle(
                            fontFamily: 'QRegular',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ));
      }
    } else {
      if (currentItems.contains('Pillow') &&
          currentItems.contains('Food') &&
          currentItems.contains('Medicine Prescriptions') &&
          currentItems.contains('Vital Signs Equipment') &&
          currentItems.contains('Prescribed Medicine (2)') &&
          currentItems.contains('X-Ray') &&
          currentItems.contains('Oximeter')) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                  title: const Text(
                    'Level Completed!',
                    style: TextStyle(
                        fontFamily: 'QBold', fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                    'You completed the whole Challenge!',
                    style: TextStyle(fontFamily: 'QRegular'),
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //       builder: (context) => const LoginScreen()),
                        // );
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(
                            fontFamily: 'QRegular',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getCompleted();
      },
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        child: Badge(
          backgroundColor: Colors.red,
          label: TextWidget(
            text: 'Bag',
            fontSize: 12,
            color: Colors.white,
          ),
          child: Image.asset(
            'assets/images/open-box.png',
            height: 50,
          ),
        ),
        onPressed: () {
          Get.to(() => const BagScreen(),
              transition: Transition.leftToRightWithFade);
        },
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/8.png',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 190,
            left: 50,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const ReceptionScreen(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 225,
                height: 125,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 220,
            left: 300,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const NurseScreen(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 180,
                height: 125,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 240,
            left: 480,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const DoctorScreen(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 180,
                height: 125,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 50,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const MedTechScreen(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 300,
                height: 125,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 70,
            left: 350,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const PatientScreen(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 180,
                height: 125,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: 520,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const PharmacyScreen(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 250,
                height: 125,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
