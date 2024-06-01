
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'sign_second.dart';
import 'package:untitled3/models/signup_data/SignUpData.dart';
import '../../models/Service/ApiService.dart';

class SignUpFirst extends StatefulWidget {
  @override
  _SignUpFirstState createState() => _SignUpFirstState();
}

class _SignUpFirstState extends State<SignUpFirst> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ApiService apiService = ApiService();
  bool duplicateCheck_check = false;
  void check() async {
    final userId = _userIdController.text;
    final duplicateCheckResponse = await apiService.checkUserIdDuplicate(userId);
    print(duplicateCheckResponse.statusCode);
    if (duplicateCheckResponse.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('사용 가능한 아이디입니다')));
      duplicateCheck_check = true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('이미 사용 중인 아이디입니다')));
    }
  }

  String? _selectedDomain;
  List<String> emailDomains = [
    'naver.com',
    'daum.net',
    'gmail.com',
    // 다른 이메일 도메인 추가 가능
  ];

  void _nextPage() {
    if(duplicateCheck_check == false){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('아이디 중복체크를 해주세요')));
      return;
    }
    final signUpData = SignUpData(
      userId: _userIdController.text,
      password: _passwordController.text,
      email: _emailController.text + '@' + (_selectedDomain ?? ''),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpSecond(signUpData: signUpData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(onTap: () {
      FocusScope.of(context).unfocus();
    },
    child: SingleChildScrollView(
        child :
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),
              Text(
                '1/3',
                style: TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 15),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),
              Text(
                '가입정보',
                style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),
              Text(
                '아이디',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ],
          ),
          Container(
            height: 80,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
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
                Positioned(
                  right: 15.0,
                  top: 10.0,
                  child: IconButton(
                    icon: Image.asset('assets/images/duplicate_check.png', width: 80, height: 50),
                    iconSize: 30.0,
                    onPressed: () {
                      check();
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              Text(
                '4~12자/영문 대소문자, 숫자로 입력해 주세요.',
                style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 10),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),
              Text(
                '비밀번호',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ],
          ),
          Container(
            height: 80,
            child: Padding(
              padding: EdgeInsets.all(10.0),
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              Text(
                '영문, 숫자, 특수문자 포함 8자 이상으로 입력해 주세요.',
                style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 10),
              ),
            ],
          ),
          Container(
            height: 80,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Color.fromRGBO(240, 240, 240, 1.0),
                  labelText: '비밀번호 확인',
                  labelStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                ),
                obscureText: true,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),
              Text(
                '이메일',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Color.fromRGBO(240, 240, 240, 1.0),
                    labelText: '아이디',
                    labelStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                '@',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              SizedBox(width: 10),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.4,
                child: DropdownButtonFormField<String>(
                  value: _selectedDomain,
                  isExpanded: true,
                  items: emailDomains.map((String domain) {
                    return DropdownMenuItem<String>(
                      value: domain,
                      child: Text(
                        domain,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedDomain = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color.fromRGBO(240, 240, 240, 1.0),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _nextPage,
                child: Text(
                  '다음으로',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(300, 50),
                  backgroundColor: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    )
    );
  }
}
