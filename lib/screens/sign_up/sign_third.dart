import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/models/signup_data/SignUpData.dart';
import '../../models/signup_data/User.dart';
import 'sign_fourth.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xml/xml.dart' as xml;
import 'package:untitled3/models/Service/ApiService.dart';

class SignUpThird extends StatefulWidget {
  final SignUpData signUpData;

  SignUpThird({required this.signUpData});

  @override
  _SignUpThirdState createState() => _SignUpThirdState();
}

class _SignUpThirdState extends State<SignUpThird> {
  int selectedHour = 0;
  int selectedMinute = 0;
  String eight = '';
  String _lunIljin = '';
  String _lunWolgeon = '';
  String _lunSecha = '';
  Future<void> _fetchLunarInfo(String year, String month,String day) async {
    String solYear = year;
    String solMonth = month;
    String solDay = day;

    if (solDay.length == 1) {
      solDay = '0$solDay';
    }

    if (solMonth.length == 1) {
      solMonth = '0$solMonth';
    }

    String apiUrl = 'http://apis.data.go.kr/B090041/openapi/service/LrsrCldInfoService/getLunCalInfo';
    String apiKey = 'XLiG%2Fql98jEKQAw2GxNW%2BF5ySIBX5XkCuJ0E2%2FT0wczvrFg3gvxwLi2SZfXyb9o%2F3tol2PF9jYRzG8ZK6LpEdg%3D%3D';

    var response = await http.get(Uri.parse('$apiUrl?solYear=$solYear&solMonth=$solMonth&solDay=$solDay&ServiceKey=$apiKey'));

    if (response.statusCode == 200) {
      String jsonString = utf8.decode(response.bodyBytes);
      int startIndex = jsonString.indexOf('<?xml');
      if (startIndex != -1) {
        int endIndex = jsonString.indexOf('?>', startIndex);
        if (endIndex != -1) {
          jsonString = jsonString.substring(endIndex + 2);
        }
      }
      String xmlData = jsonString;
      var document = xml.XmlDocument.parse(xmlData);
      var lunIljin = document.findAllElements('lunIljin').single.text;
      var lunWolgeon = document.findAllElements('lunWolgeon').single.text;
      var lunSecha = document.findAllElements('lunSecha').single.text; // 년

      if (mounted) {
        setState(() {
          _lunIljin = lunIljin;
          _lunWolgeon = lunWolgeon;
          _lunSecha= lunSecha;

        });
      }
    } else {
      throw Exception('Failed to load lunar data');
    }
  }

  void onTimerDurationChanged(Duration duration) {
    setState(() {
      selectedHour = duration.inHours;
      selectedMinute = duration.inMinutes.remainder(60);
    });
  }

  void _showCupertinoTimerPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            onTimerDurationChanged: onTimerDurationChanged,
          ),
        );
      },
    );
  }
  String getResult(String day, String hour, String minute) {
    print("hour : ${hour}  minute  : ${minute}");
    Map<String, List<String>> timeMapping = {
      "23:30 ~ 01:30": ["갑자", "무자", "병자", "정자", "무자"],
      "01:30 ~ 03:30": ["을축", "경축", "정축", "신축", "계축"],
      "03:30 ~ 05:30": ["병인", "임인", "기인", "계인", "병인"],
      "05:30 ~ 07:30": ["정묘", "계묘", "신묘", "임묘", "계묘"],
      "07:30 ~ 09:30": ["무진", "갑진", "경진", "갑진", "병진"],
      "09:30 ~ 11:30": ["기사", "경사", "신사", "을사", "정사"],
      "11:30 ~ 13:30": ["경오", "을오", "병오", "정오", "무오"],
      "13:30 ~ 15:30": ["신미", "병미", "기미", "무미", "계미"],
      "15:30 ~ 17:30": ["임신", "갑신", "병신", "정신", "계신"],
      "17:30 ~ 19:30": ["계유", "을유", "병유", "정유", "무유"],
      "19:30 ~ 21:30": ["갑술", "무술", "병술", "정술", "계술"],
      "21:30 ~ 23:30": ["을해", "기해", "병해", "무해", "병해"]
    };

    Map<String, int> dayMapping = {
      "갑": 0,
      "을": 1,
      "병": 2,
      "정": 3,
      "무": 4,
      "기": 0,
      "경": 1,
      "신": 2,
      "임": 3,
      "계": 4
    };

    // int hour = int.parse(time.split('-')[0]);
    // int minute = int.parse(time.split('-')[1]);

    String? timePeriod = getTimePeriod(int.parse(hour),int.parse(minute));
    print("timePeriod : ${timePeriod}");
    if (timePeriod == null || !dayMapping.containsKey(day)) {
      return "Invalid input";
    }

    int dayIndex = dayMapping[day]!;
    return timeMapping[timePeriod]![dayIndex];
  }
  String? getTimePeriod(int hour, int minute) {
    if ((hour == 23 && minute >= 30) || (hour == 0 && minute < 30)) {
      return "23:30 ~ 01:30";
    } else if ((hour == 0 && minute >= 30) || (hour == 1 && minute < 30)) {
      return "23:30 ~ 01:30";
    } else if ((hour == 1 && minute >= 30) || (hour == 2 && minute < 30)) {
      return "01:30 ~ 03:30";
    } else if ((hour == 2 && minute >= 30) || (hour == 3 && minute < 30)) {
      return "01:30 ~ 03:30";
    } else if ((hour == 3 && minute >= 30) || (hour == 4 && minute < 30)) {
      return "03:30 ~ 05:30";
    } else if ((hour == 4 && minute >= 30) || (hour == 5 && minute < 30)) {
      return "03:30 ~ 05:30";
    } else if ((hour == 5 && minute >= 30) || (hour == 6 && minute < 30)) {
      return "05:30 ~ 07:30";
    } else if ((hour == 6 && minute >= 30) || (hour == 7 && minute < 30)) {
      return "05:30 ~ 07:30";
    } else if ((hour == 7 && minute >= 30) || (hour == 8 && minute < 30)) {
      return "07:30 ~ 09:30";
    } else if ((hour == 8 && minute >= 30) || (hour == 9 && minute < 30)) {
      return "07:30 ~ 09:30";
    } else if ((hour == 9 && minute >= 30) || (hour == 10 && minute < 30)) {
      return "09:30 ~ 11:30";
    } else if ((hour == 10 && minute >= 30) || (hour == 11 && minute < 30)) {
      return "09:30 ~ 11:30";
    } else if ((hour == 11 && minute >= 30) || (hour == 12 && minute < 30)) {
      return "11:30 ~ 13:30";
    } else if ((hour == 12 && minute >= 30) || (hour == 13 && minute < 30)) {
      return "11:30 ~ 13:30";
    } else if ((hour == 13 && minute >= 30) || (hour == 14 && minute < 30)) {
      return "13:30 ~ 15:30";
    } else if ((hour == 14 && minute >= 30) || (hour == 15 && minute < 30)) {
      return "13:30 ~ 15:30";
    } else if ((hour == 15 && minute >= 30) || (hour == 16 && minute < 30)) {
      return "15:30 ~ 17:30";
    } else if ((hour == 16 && minute >= 30) || (hour == 17 && minute < 30)) {
      return "15:30 ~ 17:30";
    } else if ((hour == 17 && minute >= 30) || (hour == 18 && minute < 30)) {
      return "17:30 ~ 19:30";
    } else if ((hour == 18 && minute >= 30) || (hour == 19 && minute < 30)) {
      return "17:30 ~ 19:30";
    } else if ((hour == 19 && minute >= 30) || (hour == 20 && minute < 30)) {
      return "19:30 ~ 21:30";
    } else if ((hour == 20 && minute >= 30) || (hour == 21 && minute < 30)) {
      return "19:30 ~ 21:30";
    } else if ((hour == 21 && minute >= 30) || (hour == 22 && minute < 30)) {
      return "21:30 ~ 23:30";
    } else if ((hour == 22 && minute >= 30) || (hour == 23 && minute < 30)) {
      return "21:30 ~ 23:30";
    } else {
      return null;
    }
  }


  Future<void> createSajuText() async {
    final birthTime = DateTime(
      0,
      1,
      1,
      selectedHour,
      selectedMinute,
      0,
    );
    final formattedTime = DateFormat.Hms().format(birthTime);
    final formattedBirthTime = '$formattedTime.728Z';
    widget.signUpData.birthTime = formattedBirthTime;
    widget.signUpData.birthTime = formattedBirthTime;
    await _fetchLunarInfo(widget.signUpData.birthDate!.split('-')[0],
        widget.signUpData.birthDate!.split('-')[1],
        widget.signUpData.birthDate!.split('-')[2]);
    print(_lunIljin);
    print(_lunWolgeon);
    print(_lunSecha);
    print((_lunIljin.substring(0, 1)));
    print(widget.signUpData.birthTime!.split(':')[0]);
    print( widget.signUpData.birthTime!.split(':')[1]);

    String result = getResult(_lunIljin.substring(0, 1),
        widget.signUpData.birthTime!.split(':')[0] ,
        widget.signUpData.birthTime!.split(':')[1]);
    print("result :${result}");
    eight ="${result}${_lunIljin.substring(0, 2)}${_lunWolgeon.substring(0, 2)}${_lunSecha.substring(0, 2)}";
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('eight', eight);
    String? temp = prefs.getString('eight');
    print("eight : ${temp}");
  }

  Map<String, String> changeEight(String eight) {
    Map<String, String> myMap = {};
    for (int i = 0; i < eight.length; i++) {
      myMap[(i + 1).toString()] = eight[i];
    }
    return myMap;
  }
  void _registerAndNextPage() async {
    // 시간 형식화
    final birthTime = DateTime(
      0,
      1,
      1,
      selectedHour,
      selectedMinute,
      0,
    );
    final formattedTime = DateFormat.Hms().format(birthTime);
    final formattedBirthTime = '$formattedTime.728Z';

    widget.signUpData.birthTime = formattedBirthTime;

    final apiService = ApiService();
    final user = User(
      userId: widget.signUpData.userId!,
      email: widget.signUpData.email!,
      password: widget.signUpData.password!,
      name: widget.signUpData.name!,
      gender: widget.signUpData.gender!,
      birthDate: widget.signUpData.birthDate!,
      birthTime: widget.signUpData.birthTime!,
    );
    print(user.userId);
    print(user.email);
    print(user.password);
    print(user.name);
    print(user.gender);
    print(user.birthDate);
    print(user.birthTime);

    final response = await apiService.createMember(user);
    var token = "";
    if (response.statusCode == 201) {
      // 회원가입 성공
      await createSajuText();
      final prefs = await SharedPreferences.getInstance();
      String saju = prefs.getString('eight')!!;
      // 토큰받아오기 로그인 API 사용
      final getToken = await apiService.logIn(user.userId,user.password);
      if (getToken.statusCode == 200) {
        print("로그인 토큰가져오기 성공");
        final responseData = jsonDecode(getToken.body);
        token = responseData['access_token'];
        await prefs.setString('auth_token', token);
        String? temp = prefs.getString('auth_token');
        print(temp);
        Map<String, String> sajuMap = changeEight(saju);
        final response_saju = await apiService.giveEight(sajuMap,token);
        if(response_saju.statusCode ==201){
          print("사주풀이 잘보냈습니다.");
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpFourth(),
        ),
      );
    } else {
      // 회원가입 실패
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원가입 실패')));
    }
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
            child : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 15),
                    Text(
                      '3/3',
                      style: TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 15),
                    Text(
                      '태어난시',
                      style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 10),
                    Text(
                      '태어난 시간을 입력하면 \n더 자세히 분석해 드릴 수 있어요!.',
                      style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      color: Color.fromRGBO(240, 240, 240, 1.0),
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '선택한 시간: ${selectedHour.toString().padLeft(2, '0')} 시 ${selectedMinute.toString().padLeft(2, '0')} 분',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 270,
                      child: GestureDetector(
                        onTap: () {
                          _showCupertinoTimerPicker(context);
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.access_time,
                            size: 40.0,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        _registerAndNextPage();
                      },
                      // _registerAndNextPage,
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