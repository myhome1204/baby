import 'package:flutter/material.dart';

import 'package:untitled3/screens/chatting/chat.dart';
import 'package:untitled3/screens/profile/Profile.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    Chat(),
    Profile(),
  ];
  @override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      bottomNavigationBar:BottomNavigationBar (
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/chatting_icon.png'),
              // size: 24, // 이미지 사이즈 조정이 필요하다면 이 부분을 사용할 수 있습니다.
            ),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/profile_icon.png'),
              // size: 24, // 이미지 사이즈 조정이 필요하다면 이 부분을 사용할 수 있습니다.
            ),
            label: '마이페이지',

          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
