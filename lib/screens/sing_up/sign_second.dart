import 'package:flutter/material.dart';
import 'package:untitled3/screens/sing_up/sign_third.dart';

class SignUpSecond extends StatefulWidget {
  @override
  _SignUpSecondState createState() => _SignUpSecondState();
}
class _SignUpSecondState extends State<SignUpSecond> {

  bool _isMaleSelected = true;
  bool _isFemaleSelected = false;
  late List<bool> isSelected;
  String? _selectedYear;
  String? _selectedMonth ;
  String? _selectedDay ;
  List<String> years = List.generate(75, (index) => (1950 + index).toString());
  List<String> months=  List.generate(12, (index) => (1 + index).toString());
  List<String> days = List.generate(31, (index) => (1 + index).toString());
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
              Text('2/3',
                style: TextStyle(color: Colors.grey.withOpacity(0.5),
                    fontSize: 15),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              SizedBox(width: 15),
              Text('프로필정보',
                style: TextStyle(color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              SizedBox(width: 15),
              Text('이름',
                style: TextStyle(color: Colors.black,
                  fontSize: 15,
                ),
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
                    labelText: '이름',
                    labelStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  ),
                  obscureText: true,
                ),
              )
          ),
          
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              SizedBox(width: 15),
              Text('성별',
                style: TextStyle(color: Colors.black,
                  fontSize: 15,
                ),
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
                    child :Text(
                      '남성',
                      style: TextStyle(
                        color: _isFemaleSelected ? Colors.black : Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width:  MediaQuery.of(context).size.width * 0.05,),
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
                      child :Text(
                        '여성',
                        style: TextStyle(
                          color: _isFemaleSelected ? Colors.red : Colors.black,
                        ),
                      ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              SizedBox(width: 15),
              Text('생년월일',
                style: TextStyle(color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              Container(
                height: 50,
                // DropdownButtonFormField의 고정된 너비 설정
                // 아이디 입력 필드와 동일한 너비를 지정합니다.
                width: MediaQuery.of(context).size.width * 0.35,
                child: DropdownButtonFormField<String>(
                  value: _selectedYear,
                  hint: Text("YYYY",
                  style: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  ),
                  isExpanded: true,
                  items: years.map((String domain) {
                    return DropdownMenuItem<String>(
                      value: domain,
                      child: Text(domain,
                        overflow: TextOverflow.ellipsis,),
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
                // DropdownButtonFormField의 고정된 너비 설정
                // 아이디 입력 필드와 동일한 너비를 지정합니다.
                width: MediaQuery.of(context).size.width * 0.25,
                child: DropdownButtonFormField<String>(
                  value: _selectedMonth,
                  hint: Text("MM",
                    style: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  ),
                  isExpanded: true,
                  items: months.map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month,
                        overflow: TextOverflow.ellipsis,),
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
                // DropdownButtonFormField의 고정된 너비 설정
                // 아이디 입력 필드와 동일한 너비를 지정합니다.
                width: MediaQuery.of(context).size.width * 0.25,
                child: DropdownButtonFormField<String>(
                  value: _selectedDay,
                  isExpanded: true,
                  hint: Text("DD",
                    style: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  ),
                  items: days.map((String day) {
                    return DropdownMenuItem<String>(
                      value: day,
                      child: Text(day,
                        overflow: TextOverflow.ellipsis,),
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
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  //  다음으로를 눌렀을때 작업해야할곳
                  Navigator.push(context, MaterialPageRoute(builder: (context) => (SignUpThird())),);
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
