import 'dart:ui';
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
  bool isMuted = false;
  double _prevVolume = 0.5;

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  Future<void> _initSettings() async {
    try {
      final vol = await FlutterVolumeController.getVolume();
      double currentBright;
      try {
        // Prefer new API on newer plugin versions
        currentBright = await ScreenBrightness().application;
      } catch (_) {
        try {
          // Fallback for older plugin versions
          // ignore: deprecated_member_use
          currentBright = await ScreenBrightness().current;
        } catch (_) {
          currentBright = 0.7; // sensible default
        }
      }
      setState(() {
        val = (vol ?? 0.5).clamp(0.0, 1.0).toDouble();
        val2 = currentBright.clamp(0.0, 1.0).toDouble();
        isMuted = val <= 0.001;
        _prevVolume = val > 0 ? val : _prevVolume;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      iconSize: 28,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.settings,
                            color: Colors.black87, size: 28),
                        const SizedBox(width: 8),
                        TextWidget(
                          text: 'Settings',
                          fontSize: 36,
                          fontFamily: 'Bold',
                          color: Colors.black87,
                        ),
                      ],
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 16),

                // Glass panel
                Expanded(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: 720,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.black.withValues(alpha: 0.04),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.1),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Volume block
                              _sectionHeader(
                                icon: Icons.volume_up,
                                title: 'Game Volume',
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Switch(
                                    value: isMuted,
                                    activeColor: Colors.amber,
                                    onChanged: (v) async {
                                      setState(() => isMuted = v);
                                      if (v) {
                                        _prevVolume =
                                            val > 0.01 ? val : _prevVolume;
                                        await FlutterVolumeController.setVolume(
                                            0);
                                        setState(() => val = 0);
                                      } else {
                                        await FlutterVolumeController.setVolume(
                                            _prevVolume);
                                        setState(() => val = _prevVolume);
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  TextWidget(
                                    text: 'Mute',
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  const Spacer(),
                                  _pill('${(val * 100).round()}%'),
                                ],
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.amber,
                                  inactiveTrackColor: Colors.black12,
                                  thumbColor: Colors.amber,
                                  overlayColor:
                                      Colors.amber.withValues(alpha: 0.2),
                                ),
                                child: Slider(
                                  min: 0,
                                  max: 1,
                                  value: val,
                                  onChanged: (value) async {
                                    await FlutterVolumeController.setVolume(
                                        value);
                                    setState(() {
                                      val = value;
                                      isMuted = value <= 0.001;
                                      if (!isMuted) _prevVolume = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Brightness block
                              _sectionHeader(
                                icon: Icons.brightness_6,
                                title: 'Screen Brightness',
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const SizedBox(width: 8),
                                  const Icon(Icons.wb_sunny,
                                      color: Colors.black54),
                                  const SizedBox(width: 8),
                                  TextWidget(
                                    text: 'Adjust brightness',
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  const Spacer(),
                                  _pill('${(val2 * 100).round()}%'),
                                ],
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.lightBlueAccent,
                                  inactiveTrackColor: Colors.black12,
                                  thumbColor: Colors.lightBlueAccent,
                                  overlayColor: Colors.lightBlueAccent
                                      .withValues(alpha: 0.2),
                                ),
                                child: Slider(
                                  min: 0,
                                  max: 1,
                                  value: val2,
                                  onChanged: (value) async {
                                    await setBrightness(value);
                                    setState(() {
                                      val2 = value;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      // defaults
                                      await FlutterVolumeController.setVolume(
                                          0.5);
                                      await setBrightness(0.7);
                                      setState(() {
                                        val = 0.5;
                                        val2 = 0.7;
                                        isMuted = false;
                                        _prevVolume = 0.5;
                                      });
                                    },
                                    child: TextWidget(
                                      text: 'Reset to defaults',
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'Back to game',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _sectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, color: Colors.black87, size: 22),
        const SizedBox(width: 8),
        TextWidget(
          text: title,
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.black87,
        ),
      ],
    );
  }

  Future<void> setBrightness(double brightness) async {
    try {
      // Prefer new API; fallback to deprecated for older plugin versions
      await ScreenBrightness().setApplicationScreenBrightness(brightness);
    } catch (e) {
      try {
        // ignore: deprecated_member_use
        await ScreenBrightness().setScreenBrightness(brightness);
      } catch (_) {
        // ignore error in UI layer
      }
    }
  }
}
