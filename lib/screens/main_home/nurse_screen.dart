import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

class NurseScreen extends StatelessWidget {
  const NurseScreen({super.key});

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
