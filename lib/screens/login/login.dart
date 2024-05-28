import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:untitled3/screens/home/home.dart';
import 'package:untitled3/screens/sign_up/sign_first.dart';
import 'package:firebase_core/firebase_core.dart ';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/Service/ApiService.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isChecked = false;
  @override
  void initState() {
    super.initState();
    // _loadAutoLoginInfo();
  }
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final apiService = ApiService();
  void logInUser(String id, String password) async {
    final apiService = ApiService();
    final response = await apiService.logIn(id,password);
    print("id : ${id}");
    print("password : ${password}");
    if (response.statusCode == 200) {
      // 로그인 성공
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('로그인성공')));
      print('로그인 성공');
      print(response.body);
      final responseData = jsonDecode(response.body);
      final token = responseData['access_token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      String? temp = prefs.getString('auth_token');
      // Navigator.push(context, MaterialPageRoute(builder: (context) => (Home())),);
    } else {
      // 로그인 실패
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('아이디비밀번호가 일치하지 않습니다.')));
      print('로그인 실패');
      print(response.body);
    }
  }
  Future<void> _saveAutoLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('autoLogin', isChecked);
  }
  Future<void> _loadAutoLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isChecked = prefs.getBool('autoLogin') ?? false;
    });
    if (isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('자동로그인체크되어있음.')));
      String? token = prefs.getString('auth_token');
      print("토큰값은 : ${token}");
      if (token != null) {
        final response = await apiService.checkTokenValidity(token);
        if (response.statusCode == 200) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          prefs.remove('token');
        }
      }
    }
  }

  Future<String> _sendAuthCodeToServer(String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse('https://createcutsomtoken-tippqbnqwq-uc.a.run.app'), // 파이어베이스 서버의 엔드포인트
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': accessToken}),
      );

      if (response.statusCode == 200) {
        print("서버 응답 성공: ${response.body}");

        return response.body;  // JSON 파싱 없이 응답 본문을 그대로 반환
      } else {
        print("서버 응답 오류: ${response.body}");
        throw Exception('서버로 인증 코드 전송 실패');
      }
    } catch (error) {
      print("HTTP 요청 오류: $error");
      throw Exception('HTTP 요청 실패');
    }
  }

  // final _firbaseAuthDataSource = FirebaseAuthRemoteDataSource();
  User? user;
  Future<void> signWithKakao() async {
    bool isInstalled = await isKakaoTalkInstalled();
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
          // 토큰을 받은 후의 로직 추가
          print('카카오계정으로 로그인 성공22');

        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          print(await KakaoSdk.origin);
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print("카카오톡 로그인 성공 ${token.accessToken}");

        // Firebase 서버로 인증 코드 전송
        final firebaseToken = await _sendAuthCodeToServer(token.accessToken);
        print("Firebase Custom Token 받음: $firebaseToken");

        // Firebase에 로그인
        await firebase.FirebaseAuth.instance.signInWithCustomToken(firebaseToken);
        print("Firebase 로그인 성공");

        // SharedPreferences에 액세스 토큰 저장
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('kakao_access_token', token.accessToken);
        print("액세스 토큰 저장 성공");
        String accessToken = token.accessToken;
        String? refreshToken = token.refreshToken;
        OAuthToken token1 = await UserApi.instance
            .loginWithKakaoAccount(prompts: [Prompt.login]);
        user = await UserApi.instance.me();

        // final customToken = await _firbaseAuthDataSource.createCustomToken({
        //   'uid' : user!.id.toString(),
        //   'displayName' : user!.kakaoAccount!.profile!.nickname,
        //   if (user!.kakaoAccount!.email != null)
        //     'email': '${user!.id}@example.com',
        //   if (user!.kakaoAccount!.profile!.profileImageUrl != null)
        //     'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
        // });
        // await firebase.FirebaseAuth.instance.signInWithCustomToken(customToken);
        print('로그인 성공 ${token1.accessToken}');
        print('카카오계정으로 로그인 성공33');
        AccessTokenInfo tokenInfo =
        await UserApi.instance.accessTokenInfo();
        print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
        print(accessToken);
        print(refreshToken);
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        print(await KakaoSdk.origin);
      }
    }
    // if (await AuthApi.instance.hasToken()) {
    //   try {
    //     AccessTokenInfo tokenInfo =
    //     await UserApi.instance.accessTokenInfo();
    //     print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
    //     print('토큰 정보 보기 성공'
    //         '\n회원정보: ${tokenInfo.id}'
    //         '\n만료시간: ${tokenInfo.expiresIn} 초');
    //   } catch (error) {
    //     if (error is KakaoException && error.isInvalidTokenError()) {
    //       print('토큰 만료 $error');
    //     } else {
    //       print('토큰 정보 조회 실패 $error');
    //     }
    //
    //     try {
    //       // 카카오계정으로 로그인
    //       OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
    //       print('로그인 성공 ${token.accessToken}');
    //     } catch (error) {
    //       print('로그인 실패 $error');
    //     }
    //   }
    // } else {
    //   print('발급된 토큰 없음');
    //   try {
    //     OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
    //     print('로그인 성공 ${token.accessToken}');
    //   } catch (error) {
    //     print('로그인 실패 $error');
    //   }
    // }
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
                    controller: _userIdController,
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
                    controller: _passwordController,
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
                          _saveAutoLoginInfo();
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
                        if(_userIdController.text.length ==0){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('아이디를 입력하세요')));
                          return ;
                        }
                        if(_passwordController.text.length ==0){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('비밀번호를 입력하세요')));
                          return ;
                        }
                        print(_userIdController.text);
                        print(_passwordController.text);
                        logInUser(_userIdController.text,_passwordController.text);
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