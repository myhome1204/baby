import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '로그인',
              style: TextStyle(
                  fontSize: 15
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[20],
                  labelText: '아이디'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[20],
                  labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 5.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Checkbox(value: isChecked,
                    onChanged: (value){
                      setState(() {
                        isChecked = value!;
                      });
                    }),
                Text(
                  '자동로그인',
                  style: TextStyle(
                      fontSize: 10
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    //  로그인 버튼을 눌렀을때 작업해야할곳
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 0으로 지정하면 모서리가 각진 사각형이 됩니다.
                    ),
                    minimumSize: Size(300, 50),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: (){
                    //아이디/비밀번호 찾기 기능
                  },
                  child: Text('아이디/비밀번호 찾기',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),),
                ),
                Text('|',
                  style: TextStyle(
                    fontSize: 10,
                  ),),
                TextButton(
                  onPressed: (){
                    //회원가입 기능
                  },
                  child: Text('회원가입',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('간편로그인',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Image.asset('assets/images/kakao_login_medium_narrow.png'),
                  iconSize: 30.0,
                  onPressed: (){
                    //카카오톡 간편로그인버튼
                  },
                )
              ],
            ),

          ],
        ),
      ),

    );
  }
}
