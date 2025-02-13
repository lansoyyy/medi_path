import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:medi_path/screens/game_screens/color.dart';
import 'package:medi_path/widgets/text_widget.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
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
                          '💊 Pharmacist Sarah: "Hi! Please get the prescribed medicine for the patient from the pharmacy shelves."',
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
                    "assets/images/PHARMACY ROOM.png",
                  ),
                  fit: BoxFit.fitHeight),
            ),
          ),
          Positioned(
            bottom: 280,
            left: 150,
            child: GestureDetector(
              onTap: () {
                Get.to(() => const Medicine(),
                    transition: Transition.circularReveal);
              },
              child: Container(
                width: 140,
                height: 200,
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            bottom: 5,
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

class Medicine extends StatelessWidget {
  const Medicine({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ColorMatchingGame(item: 'Prescribed Medicine (2)')));
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/Medicine bottles.PNG'))),
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
