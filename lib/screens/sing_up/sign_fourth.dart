import 'package:flutter/material.dart';
import 'package:untitled3/screens/home/home.dart';
import 'package:untitled3/screens/sing_up/sign_second.dart';

class SignUpFourth extends StatefulWidget {
  @override
  _SignUpFourthState createState() => _SignUpFourthState();
}
class _SignUpFourthState extends State<SignUpFourth> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('회원가입'),
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       // 뒤로가기 버튼을 눌렀을 때 수행할 동작
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Text('환영합니다!',
                style: TextStyle(color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [

              Text('            애기동자와 함께\n 운명을 탐구해 볼 준비 되셨나요?',
                style: TextStyle(color: Colors.grey.withOpacity(0.5),
                    fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 20),
          Image(
            image: AssetImage('assets/images/talo.png'),
            width: 300,
            height: 300,),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  //  다음으로를 눌렀을때 작업해야할곳
                  Navigator.push(context, MaterialPageRoute(builder: (context) => (Home())),);
                  //
                },
                child: Text('시작하기'
                  ,style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 0으로 지정하면 모서리가 각진 사각형이 됩니다.
                  ),
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ],
      ),


    );
  }
}
