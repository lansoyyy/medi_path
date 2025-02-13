import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

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
