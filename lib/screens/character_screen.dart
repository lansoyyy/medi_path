import 'package:flutter/material.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/button_widget.dart';
import 'package:medi_path/widgets/text_widget.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/characters/$character.PNG'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        width: 370,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: TextWidget(
                            text: 'Select a Character',
                            fontSize: 24,
                            fontFamily: 'Bold',
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 150,
                        width: 370,
                        child: Wrap(
                          children: [
                            for (int i = 1; i < 15; i++)
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      character = i;
                                    });
                                  },
                                  child: Image.asset(
                                    'assets/images/characters/$i.PNG',
                                    height: 60,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 75,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonWidget(
                            radius: 100,
                            color: Colors.grey,
                            width: 175,
                            label: 'Back',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ButtonWidget(
                            radius: 100,
                            color: Colors.red,
                            width: 175,
                            label: 'Save',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
