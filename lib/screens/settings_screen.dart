import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../widgets/text_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _DrillsPageState();
}

class _DrillsPageState extends State<SettingsScreen> {
  double val = 0;
  double val2 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  TextWidget(
                    text: 'Settings',
                    fontSize: 48,
                    fontFamily: 'Bold',
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: 'Volume',
                fontSize: 24,
                fontFamily: 'Bold',
              ),
              Slider(
                value: val,
                onChanged: (value) async {
                  await FlutterVolumeController.setVolume(value);

                  setState(() {
                    val = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: 'Brightness',
                fontSize: 24,
                fontFamily: 'Bold',
              ),
              Slider(
                value: val2,
                onChanged: (value) async {
                  setBrightness(value);
                  setState(() {
                    val2 = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      print(e);
      throw 'Failed to set brightness';
    }
  }
}
