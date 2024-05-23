import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('홈입니다.'),
        ),
        body: TextButton(
          onPressed: (){


          },
          child: Text('프로필이니다.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),),
        )
    );
  }
}
