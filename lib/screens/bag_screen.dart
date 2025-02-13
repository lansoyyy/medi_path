import 'package:flutter/material.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/text_widget.dart';

class BagScreen extends StatelessWidget {
  const BagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: currentItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(
              'assets/images/${currentItems[index]}.png',
              height: 50,
            ),
            title: TextWidget(
              text: currentItems[index],
              fontSize: 18,
              fontFamily: 'Bold',
            ),
          );
        },
      ),
    );
  }
}
