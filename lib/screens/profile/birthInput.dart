import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/screens/profile/Profile.dart';
import 'package:flutter/widgets.dart';
import '../../models/Service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/models/signup_data/SignUpData.dart';
import 'dart:convert';


String changedbirthday="";

class birthInput extends StatefulWidget {
  @override
  _birthInputState createState() => _birthInputState();
}

class _birthInputState extends State<birthInput> {
  String? _selectedYear;
  String? _selectedMonth;
  String? _selectedDay;
  bool isLunar = false;

  final List<String> years = List.generate(100, (index) => (DateTime.now().year - index).toString());
  final List<String> months = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> days = List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));
  final ApiService apiService = ApiService();

  Future<void> updatebirthday(String changedbirthday) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token")!;
    var response = await apiService.updatebirthday(changedbirthday, token);
    if (response.statusCode == 200) {
      print("생일 전달 성공");
    } else {
      print("생일 전달 실패: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('생일 입력'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              left: 20,
              top: 21,
              child: Text(
                '생년월일',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 60,
              child: Row(
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
                      items: years.map((String year) {
                        return DropdownMenuItem<String>(
                          value: year,
                          child: Text(
                            year,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedYear = value;
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
            ),
            Positioned(
              left: 20,
              top: 119,
              child: Row(
                children: [
                  Checkbox(
                    value: isLunar,
                    onChanged: (bool? value) {
                      setState(() {
                        isLunar = value!;
                      });
                    },
                  ),
                  Text(
                    '음력',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_selectedYear != null && _selectedMonth != null && _selectedDay != null) {
                    changedbirthday = '$_selectedYear-$_selectedMonth-$_selectedDay';
                    await updatebirthday(changedbirthday);
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('오류'),
                        content: Text('생년월일을 모두 선택하세요.'),
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
          ],
        ),
      ),
    );
  }
}
