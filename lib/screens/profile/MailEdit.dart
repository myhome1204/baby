import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled3/screens/profile/ProfileEdit.dart';
import 'package:untitled3/models/signup_data/SignUpData.dart';
import '../../models/Service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

String myemail = "";
String changedemail = "";

class MailEdit extends StatefulWidget {
  @override
  _MailEditState createState() => _MailEditState();
}

class _MailEditState extends State<MailEdit> {
  final TextEditingController _emailController = TextEditingController();
  String? _selectedDomain;
  final List<String> emailDomains = ['gmail.com', 'naver.com', 'daum.net'];
  final ApiService apiService = ApiService();

  Future<void> getmyemail() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token")!;
    var response = await apiService.getMemberEmail(token);
    if (response.statusCode == 200) {
      print("이메일 받아옴");
      final output = jsonDecode(response.body);
      setState(() {
        myemail = output['email'];
      });
      print(myemail);
    }
  }

  Future<void> updatemail(String changedemail) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token")!;
    var response = await apiService.update_email(changedemail, token);
    if (response.statusCode == 200) {
      print("이메일 전달 성공");
    } else {
      print("이메일 전달 실패: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    getmyemail();
  }

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
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 50,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Color.fromRGBO(240, 240, 240, 1.0),
                            labelText: myemail,
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                '변경할 이메일',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
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
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 50,
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
                    ),
                  ],
                ),
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    getmyemail();
                    if (_emailController.text.isNotEmpty && _selectedDomain != null) {
                      changedemail = '${_emailController.text}@$_selectedDomain';
                      await updatemail(changedemail);
                      Navigator.pop(
                        context,
                        MaterialPageRoute(builder: (context) => (ProfileEdit())),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('오류'),
                          content: Text('아이디와 도메인을 입력하세요.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('확인'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text(
                    '저장하기',
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
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
