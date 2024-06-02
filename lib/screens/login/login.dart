import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/screens/sign_up/sign_first.dart';
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
    _loadAutoLoginInfo();
  }

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final apiService = ApiService();

  void logInUser(String id, String password) async {
    final response = await apiService.logIn(id, password);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('로그인성공')));
      final responseData = jsonDecode(response.body);
      final token = responseData['access_token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_id', id);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('아이디비밀번호가 일치하지 않습니다.')));
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
      if (token != null) {
        final response = await apiService.checkTokenValidity(token);
        if (response.statusCode == 200) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          prefs.remove('token');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset('assets/images/candle.png', width: 50, height: 50),
                  SizedBox(height: 10),
                  Text(
                    '애기동자와 함께\n나의 사주 알아보기',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 60),
                  Container(
                    height: 50,
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
                        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                            _saveAutoLoginInfo();
                          });
                        },
                        checkColor: Colors.black,
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.grey.withOpacity(0.5);
                            }
                            return Colors.grey.withOpacity(0.1);
                          },
                        ),
                      ),
                      Text(
                        '자동로그인',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          if (_userIdController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('아이디를 입력하세요')));
                            return;
                          }
                          if (_passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('비밀번호를 입력하세요')));
                            return;
                          }
                          logInUser(_userIdController.text, _passwordController.text);
                        },
                        child: Text('로그인하기', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                        onPressed: () {
                          // 아이디/비밀번호 찾기 기능
                        },
                        child: Text('아이디 찾기', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ),
                      Text('|', style: TextStyle(fontSize: 10)),
                      TextButton(
                        onPressed: () {
                          // 아이디/비밀번호 찾기 기능
                        },
                        child: Text('비밀번호 찾기', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ),
                      Text('|', style: TextStyle(fontSize: 10)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpFirst()));
                        },
                        child: Text('회원가입', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('간편로그인', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Image.asset('assets/images/kakao_login_medium_narrow.png'),
                        iconSize: 30.0,
                        onPressed: () {
                          // 카카오톡 간편로그인 버튼
                          // signWithKakao();
                        },
                      )
                    ],
                  ),
                  SizedBox(width: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: Text('임시버튼입니다. 이거눌러주세요', style: TextStyle(fontSize: 20, color: Colors.red)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
