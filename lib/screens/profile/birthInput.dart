import 'package:flutter/material.dart';
import 'package:untitled3/screens/profile/jerrymain.dart';

void main() {
  runApp(MyApp());
}

class birthInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('생일 입력'),
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
                '생년월일',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
              left: 40,
              top: 119,
              child: Text(
                '음력',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}