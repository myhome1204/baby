import 'package:flutter/material.dart';
import 'package:untitled3/screens/profile/jerrymain.dart';

void main() {
  runApp(MyApp());
}

class birthTimeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('태어난 시 입력'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              left: 20,
              top: 21,
              child: Text(
                '태어난 시',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}