import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/screens/sing_up/sign_fourth.dart';


class SignUpThird extends StatefulWidget {
  @override
  _SignUpThirdState createState() => _SignUpThirdState();
}


class _SignUpThirdState extends State<SignUpThird> {
  int selectedHour = 0;
  int selectedMinute = 0;
  void onTimerDurationChanged(Duration duration) {
    setState(() {
      selectedHour = duration.inHours; // 선택한 시간을 시간으로 변환하여 저장
      selectedMinute = duration.inMinutes.remainder(60); // 선택한 시간을 분으로 변환하여 저장
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
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로가기 버튼을 눌렀을 때 수행할 동작
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
            children: <Widget> [
              SizedBox(width: 15),
              Text('3/3',
                style: TextStyle(color: Colors.grey.withOpacity(0.5),
                    fontSize: 15),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              SizedBox(width: 15),
              Text('태어난시',
                style: TextStyle(color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,),
              ),
            ],
          ),
          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              SizedBox(width: 10),
              Text('태어난 시간을 입력하면 \n더 자세히 분석해 드릴 수 있어요!.',
                style: TextStyle(color: Colors.grey.withOpacity(0.8),
                    fontSize: 15),
              ),
            ],
          ),
          SizedBox(height: 50),
          Stack(
            children: [
              Container(
                width:  MediaQuery.of(context).size.width * 0.9,
                color: Color.fromRGBO(240, 240, 240, 1.0),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '선택한 시간: $selectedHour 시 $selectedMinute 분',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 5,
                left: 270 ,
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
                  //  다음으로를 눌렀을때 작업해야할곳
                  Navigator.push(context, MaterialPageRoute(builder: (context) => (SignUpFourth())),);
                  //
                },
                child: Text('다음으로'
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

        ],
      ),


    );
  }
}
