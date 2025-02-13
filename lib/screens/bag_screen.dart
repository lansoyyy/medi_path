import 'package:flutter/material.dart';
import 'package:medi_path/utils/data.dart';
import 'package:medi_path/widgets/text_widget.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({super.key});

  @override
  State<BagScreen> createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
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
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  currentItems.remove(currentItems[index]);
                });
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}
