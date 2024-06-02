import 'package:flutter/material.dart';
import 'package:untitled3/screens/profile/ProfileEdit.dart';
import 'package:untitled3/screens/profile/birthInput.dart';
import 'package:untitled3/screens/profile/birthTimeInput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/models/Service/ApiService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main(){
  runApp(Profile());
}
String myname="";
String userbirthdate = "";
String userbirthtime = "";

class Profile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        primary: true,
        appBar: EmptyAppBar(),
        body: MyWidget(),
      ),
    );
  }
}

class MyWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyWidgetState();
  }
}

class _MyWidgetState extends State<MyWidget>{
  @override
  final apiService = ApiService();

  Future<void> getmyname() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token")!;
    var response = await apiService.getMemberName(token);
    if (response.statusCode == 200) {
      print("이름 받아옴");

      final responseBody = utf8.decode(response.bodyBytes);
      final responseData = jsonDecode(responseBody);
      String output = responseData['name'];
      setState(() {
        myname = output;
      });
      print(myname);
      //UI업뎃

    }
  }

  Future<void> getbirthdate() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token")!;
    var response = await apiService.getMemberBirthday(token);
    if (response.statusCode == 200) {
      print("생일 받아옴");
      final output = jsonDecode(response.body);
      userbirthdate = output['birth_date'];
      print(userbirthdate);
      //UI업뎃

    }
  }

  Future<void> getbirthtime() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token")!;
    var response = await apiService.getMemberBirthdayTime(token);
    if (response.statusCode == 200) {
      print("시간 받아옴");
      final output = jsonDecode(response.body);
      userbirthtime = output['birth_time'];
      print(userbirthtime);
      //UI업뎃

    }
  }

  @override
  void initState() {
    super.initState();
    getmyname();
    getbirthdate();
    getbirthtime();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(),
      body: Column(
        children: [
          Container(
            height: 304, // 첫 번째 부분의 높이
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 24,
                  top: 27,
                  child: Image.asset(
                    'assets/images/profileIcon.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Positioned(
                  left: 130,
                  top: 50,
                  child: Text(
                    '$myname님 \n 환영합니다',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Positioned(
                  left: 247,
                  top: 81,
                  child: GestureDetector(
                    onTap: () {
                      getmyname();
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileEdit())
                      );// 클릭한 이미지에 따라 다른 동작 수행 예를 들어, 다음 화면으로 이동하는 작업 수행
                    },
                    child: Image.asset(
                      'assets/images/click_image.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 151,
                  child: Image.asset(
                    'assets/images/birth_icon.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Positioned(
                  left: 92,
                  top: 154,
                  child: Text(
                    userbirthdate,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                Positioned(
                  left: 172,
                  top: 155,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent, // 터치 이벤트를 투명한 부분도 포함하여 처리
                    onTap: () {
                      getbirthdate();
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => birthInput())
                      );// 클릭한 이미지에 따라 다른 동작 수행 예를 들어, 다음 화면으로 이동하는 작업 수행
                    },
                    child: Image.asset(
                      'assets/images/click_image.png',
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 189,
                  child: Image.asset(
                    'assets/images/birth_time.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Positioned(
                  left: 118,
                  top: 193,
                  child: Text(
                    userbirthtime,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                Positioned(
                  left: 198,
                  top: 195,
                  child: GestureDetector(
                    onTap: () {
                      getbirthtime();
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => birthTimeInput())
                      );// 클릭한 이미지에 따라 다른 동작 수행 예를 들어, 다음 화면으로 이동하는 작업 수행
                    },
                    child: Image.asset(
                      'assets/images/click_image.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 23), // 위쪽 간격 추가
          Container(
              height: 140, // 두 번째 부분의 높이
              margin: EdgeInsets.symmetric(horizontal: 20), // 테두리와 좌우 간격 조절,width써도되긴함
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2), // 빨간색 테두리 설정
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 33,
                    top: 19,
                    child: Text(
                      '고객센터',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 33,
                    top: 57,
                    child: Text(
                      '자주 묻는 질문',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 29,
                    top: 62,
                    child: GestureDetector(
                      onTap: () {
                        print('not created');// 고객센터구현
                      },
                      child: Image.asset(
                        'assets/images/click_black.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 33,
                    top: 95,
                    child: Text(
                      '1:1 문의',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 29,
                    top: 105,
                    child: GestureDetector(
                      onTap: () {
                        print('not created');// 1대1문의 구현
                      },
                      child: Image(
                        image: AssetImage('assets/images/click_black.png'),
                        ),
                    ),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}

