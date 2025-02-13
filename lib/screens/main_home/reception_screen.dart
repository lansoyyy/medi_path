import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

class ReceptionScreen extends StatelessWidget {
  const ReceptionScreen({super.key});

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
                    'assets/images/RECEPTION.png',
                  ),
                  fit: BoxFit.fitHeight),
            ),
          ),
          Positioned(
            bottom: 130,
            left: 433,
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
              child: Container(
                width: 50,
                height: 40,
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
