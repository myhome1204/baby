import 'package:flutter/material.dart';
import 'package:untitled3/screens/profile/jerrymain.dart';
import 'package:untitled3/screens/profile/Profile.dart';


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
            Center(
              child: ElevatedButton(
                onPressed: () {
                  //  다음으로를 눌렀을때 작업해야할곳
                  Navigator.pop(
                    context,
                    MaterialPageRoute(builder: (context) => (Profile())),
                  );
                  //
                },
                child: Text(
                  '저장하기',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 0으로 지정하면 모서리가 각진 사각형이 됩니다.
                  ),
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.deepOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}