import 'package:flutter/material.dart';
import 'package:untitled3/screens/profile/ProfileEdit.dart';


class MailEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('이메일 관리'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '현재 이메일',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),

              Spacer(),//텍스트와 버튼 사이에 공간 추가
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //  다음으로를 눌렀을때 작업해야할곳
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => (ProfileEdit())),
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
