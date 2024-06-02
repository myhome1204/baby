import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled3/screens/profile/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:untitled3/models/Service/ApiService.dart';

String changedbirthtime = "";

class birthTimeInput extends StatefulWidget {
  @override
  _birthTimeInput createState() => _birthTimeInput();
}

class _birthTimeInput extends State<birthTimeInput>{
  int selectedHour = 0;
  int selectedMinute = 0;
  final ApiService apiService = ApiService();

  Future<void> updatebirthtime(String changedbirthtime) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token")!;
    var response = await apiService.updatebirthtime(changedbirthtime, token);
    if (response.statusCode == 200) {
      print("시간 전달 성공");
    } else {
      print("시간 전달 실패: ${response.statusCode}");
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


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('태어난 시 입력'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1.0,
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
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  DateTime now = DateTime.now();
                  DateTime selectedTime = DateTime(now.year, now.month, now.day, selectedHour, selectedMinute);

                  // ISO 8601 형식으로 변환합니다.
                  String formattedTime = DateFormat('HH:mm:ss.SSS').format(selectedTime) + 'Z';
                  // API에 전달
                  await updatebirthtime(formattedTime);

                  // Profile 페이지로 이동합니다.
                  Navigator.pop(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
                child: Text(
                  '저장하기',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 0으로 지정하면 모서리가 각진 사각형이 됩니다.
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