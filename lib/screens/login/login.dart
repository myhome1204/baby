import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:untitled3/screens/home/home.dart';
import 'package:untitled3/screens/sing_up/sign_first.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var isChecked = false;
  Future<void> signWithKakao() async {
    // 카카오 로그인 구현 예제

// 카카오톡 실행 가능 여부 확인
// 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
    try {
    await UserApi.instance.loginWithKakaoTalk();
    print('카카오톡으로 로그인 성공');
    } catch (error) {
    print('카카오톡으로 로그인 실패 $error');

    // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
    // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
    if (error is PlatformException && error.code == 'CANCELED') {
    return;
    }
    // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
    try {
    await UserApi.instance.loginWithKakaoAccount();
    print('카카오계정으로 로그인 성공');
    } catch (error) {
    print('카카오계정으로 로그인 실패 $error');
    print(await KakaoSdk.origin);
    }
    }
    } else {
    try {
    await UserApi.instance.loginWithKakaoAccount();
    print('카카오계정으로 로그인 성공');
    } catch (error) {
    print('카카오계정으로 로그인 실패 $error');
    print(await KakaoSdk.origin);
    }
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child : Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/images/candle.png'),
                  width: 50,
                  height: 50,),
                SizedBox(height: 10),
                Text(
                  '애기동자와 함께\n나의 사주 알아보기',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle:FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 60),
                Container(
                  height: 50, // 원하는 높이 설정
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Color.fromRGBO(240, 240, 240, 1.0),
                      labelText: '아이디',
                      labelStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Color.fromRGBO(240, 240, 240, 1.0),
                      labelText: '비밀번호',
                      labelStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),),

                    obscureText: true,
                  ),
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
                      },checkColor: Colors.black, // 체크된 상태의 색상
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            // 체크된 상태일 때 색상 설정
                            return Colors.grey.withOpacity(0.5); // 흐릿한 회색 설정
                          }
                          // 체크되지 않은 상태일 때 색상 설정
                          return Colors.grey.withOpacity(0.1); // 흐릿한 회색 설정
                        },
                      ),
                    ),
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
                      child: Text('로그인하기'
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: (){
                        //아이디/비밀번호 찾기 기능
                      },
                      child: Text('아이디 찾기',
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
                        //아이디/비밀번호 찾기 기능
                      },
                      child: Text('비밀번호 찾기',
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => (SignUpFirst())),);
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
                        signWithKakao();
                      },
                    )
                  ],
                ),
                SizedBox(width: 20,)
                ,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => (Home())),);
                      },
                      child: Text('임시버튼입니다. 이거눌러주세요',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}
