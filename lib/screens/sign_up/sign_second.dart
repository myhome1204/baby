import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sign_third.dart';
import 'package:untitled3/models/signup_data/SignUpData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xml/xml.dart' as xml;

class SignUpSecond extends StatefulWidget {
  final SignUpData signUpData;

  SignUpSecond({required this.signUpData});

  @override
  _SignUpSecondState createState() => _SignUpSecondState();
}

class _SignUpSecondState extends State<SignUpSecond> {
  final TextEditingController _nameController = TextEditingController();
  bool _isMaleSelected = true;
  bool _isFemaleSelected = false;
  String? _selectedYear;
  String? _selectedMonth;
  String? _selectedDay;
  String _lunIljin = '';
  String _lunWolgeon = '';
  String _lunSecha = '';

  List<String> years = List.generate(75, (index) => (1950 + index).toString());
  List<String> months = List.generate(12, (index) => (1 + index).toString());
  List<String> days = List.generate(31, (index) => (1 + index).toString());
  String getResult(String day, String time) {
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

    int hour = int.parse(time.split('-')[0]);
    int minute = int.parse(time.split('-')[1]);

    String? timePeriod = getTimePeriod(hour, minute);
    if (timePeriod == null || !dayMapping.containsKey(day)) {
      return "Invalid input";
    }

    int dayIndex = dayMapping[day]!;
    return timeMapping[timePeriod]![dayIndex];
  }

  String? getTimePeriod(int hour, int minute) {
    if ((hour == 23 && minute >= 30) || (hour == 0 && minute < 30) || (hour == 1 && minute < 30)) {
      return "23:30 ~ 01:30";
    } else if ((hour == 1 && minute >= 30) || (hour == 2 && minute < 30) || (hour == 3 && minute < 30)) {
      return "01:30 ~ 03:30";
    } else if ((hour == 3 && minute >= 30) || (hour == 4 && minute < 30) || (hour == 5 && minute < 30)) {
      return "03:30 ~ 05:30";
    } else if ((hour == 5 && minute >= 30) || (hour == 6 && minute < 30) || (hour == 7 && minute < 30)) {
      return "05:30 ~ 07:30";
    } else if ((hour == 7 && minute >= 30) || (hour == 8 && minute < 30) || (hour == 9 && minute < 30)) {
      return "07:30 ~ 09:30";
    } else if ((hour == 9 && minute >= 30) || (hour == 10 && minute < 30) || (hour == 11 && minute < 30)) {
      return "09:30 ~ 11:30";
    } else if ((hour == 11 && minute >= 30) || (hour == 12 && minute < 30) || (hour == 13 && minute < 30)) {
      return "11:30 ~ 13:30";
    } else if ((hour == 13 && minute >= 30) || (hour == 14 && minute < 30) || (hour == 15 && minute < 30)) {
      return "13:30 ~ 15:30";
    } else if ((hour == 15 && minute >= 30) || (hour == 16 && minute < 30) || (hour == 17 && minute < 30)) {
      return "15:30 ~ 17:30";
    } else if ((hour == 17 && minute >= 30) || (hour == 18 && minute < 30) || (hour == 19 && minute < 30)) {
      return "17:30 ~ 19:30";
    } else if ((hour == 19 && minute >= 30) || (hour == 20 && minute < 30) || (hour == 21 && minute < 30)) {
      return "19:30 ~ 21:30";
    } else if ((hour == 21 && minute >= 30) || (hour == 22 && minute < 30) || (hour == 23 && minute < 30)) {
      return "21:30 ~ 23:30";
    } else {
      return null;
    }
  }

  Future<void> _fetchLunarInfo() async {
    String solYear = _selectedYear ?? '';
    String solMonth = _selectedMonth ?? '';
    String solDay = _selectedDay ?? '';

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
        });
      }
    } else {
      throw Exception('Failed to load lunar data');
    }
  }

  void _updateLunarInfo() async {
    if (_selectedYear != null && _selectedMonth != null && _selectedDay != null) {
      await _fetchLunarInfo();
    }
  }

  void _nextPage() {
    String month = "";
    String day = "";

    if (_selectedMonth.toString().length == 1) {
      String temp = _selectedMonth.toString();
      month = '0$temp';
    }else{
      month = _selectedMonth.toString();
    }
    if (_selectedDay.toString().length == 1) {
      print("_selectedDay : ${_selectedDay}");
      String temp = _selectedDay.toString();
      day = '0$temp';
      print("day : ${day}");
    }else{
      day = _selectedDay.toString();
    }
    widget.signUpData.name = _nameController.text;
    widget.signUpData.gender = _isMaleSelected ? 'M' : 'F';
    widget.signUpData.birthDate = '$_selectedYear-$month-$day';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpThird(signUpData: widget.signUpData),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),
              Text(
                '2/3',
                style: TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 15),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),
              Text(
                '프로필정보',
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
                '이름',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ],
          ),
          Container(
            height: 80,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Color.fromRGBO(240, 240, 240, 1.0),
                  labelText: '이름',
                  labelStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),
              Text(
                '성별',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isMaleSelected = true;
                    _isFemaleSelected = false;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 60,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: _isMaleSelected ? Colors.white : Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: _isMaleSelected ? Colors.red : Colors.transparent,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Center(
                    child: Text(
                      '남성',
                      style: TextStyle(color: _isFemaleSelected ? Colors.black : Colors.red),
                    ),
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isMaleSelected = false;
                    _isFemaleSelected = true;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 60,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: _isFemaleSelected ? Colors.white : Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: _isFemaleSelected ? Colors.red : Colors.transparent,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Center(
                    child: Text(
                      '여성',
                      style: TextStyle(color: _isFemaleSelected ? Colors.red : Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),
              Text(
                '생년월일',
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
                width: MediaQuery.of(context).size.width * 0.35,
                child: DropdownButtonFormField<String>(
                  value: _selectedYear,
                  hint: Text(
                    "YYYY",
                    style: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  ),
                  isExpanded: true,
                  items: years.map((String domain) {
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
                      _selectedYear = value!;
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
              SizedBox(width: 10),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.25,
                child: DropdownButtonFormField<String>(
                  value: _selectedMonth,
                  hint: Text(
                    "MM",
                    style: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  ),
                  isExpanded: true,
                  items: months.map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(
                        month,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedMonth = value;
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
              SizedBox(width: 10),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.25,
                child: DropdownButtonFormField<String>(
                  value: _selectedDay,
                  isExpanded: true,
                  hint: Text(
                    "DD",
                    style: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  ),
                  items: days.map((String day) {
                    return DropdownMenuItem<String>(
                      value: day,
                      child: Text(
                        day,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedDay = value;
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
          Text(
            'LunIljin: $_lunIljin',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 8.0),
          Text(
            'LunWolgeon: $_lunWolgeon',
            style: TextStyle(fontSize: 18.0),
          ),
          ElevatedButton(
            onPressed: () {
              _updateLunarInfo();
            },
            child: Text(
              '받아오기',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(100, 30),
              backgroundColor: Colors.deepOrange,
            ),
          ),
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
    );
  }
}
