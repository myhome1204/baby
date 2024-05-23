import 'package:flutter/material.dart';
import 'package:untitled3/screens/profile/jerrymain.dart';
import 'package:untitled3/screens/profile/MailEdit.dart';

void main() {
  runApp(MyApp());
}

class ProfileEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('프로필 수정'),
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
              left: 131,
              top: 21,
              child: Image.asset(
                'assets/images/profile.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            Positioned(
              left: 195,
              top: 85,
              child: GestureDetector(
                onTap: () {
                  print('icon pressed');// 여기에 셀카 업로드 기능 구현
                },
                child: Image.asset(
                  'assets/images/upload_selfie.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Positioned(
              top: 166,
              left: 20,
              child: Text(
                '내 정보관리',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ),
            Positioned(
              top: 218,
              left: 20,
              child: Text(
                '이메일',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
              left: 300,
              top: 230,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MailEdit())
                  );// 클릭한 이미지에 따라 다른 동작 수행 예를 들어, 다음 화면으로 이동하는 작업 수행
                },
                child: Image.asset(
                  'assets/images/click_black.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Positioned(
              top: 284,
              left: 20,
              child: Text(
                '연동된 sns 계정',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
              left: 300,
              top: 287,
              child: GestureDetector(
                onTap: () {
                  print('not created');// 연동된 sns페이지 구현해야함
                },
                child: Image.asset(
                  'assets/images/click_black.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Positioned(
              left: 70,
              bottom: 69,
              child: Text(
                '로그아웃',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
              left: 170,
              bottom: 69,
              child: Text(
                '|',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
              left: 220,
              bottom: 69,
              child: Text(
                '회원탈퇴',
                style: TextStyle(
                  color: Colors.grey,
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