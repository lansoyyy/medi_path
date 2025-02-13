import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_path/screens/bag_screen.dart';
import 'package:medi_path/screens/main_home/doctors_screen.dart';
import 'package:medi_path/screens/main_home/medtech_screen.dart';
import 'package:medi_path/screens/main_home/nurse_screen.dart';
import 'package:medi_path/screens/main_home/patients_screen.dart';
import 'package:medi_path/screens/main_home/pharmacy_screen.dart';
import 'package:medi_path/screens/main_home/reception_screen.dart';

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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        child: Image.asset(
          'assets/images/open-box.png',
          height: 50,
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
