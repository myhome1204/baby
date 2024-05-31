import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:untitled3/models/Service/ApiService.dart';

void main() => runApp(Chat());

const String _name = "Jerry";
const String yourname = "other";
String userMessage = "";
String aiMessage = "";

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FriendlychatApp",
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final apiService = ApiService();
  final List<ChatMessage> _messages = <ChatMessage>[]; // 채팅 메시지를 저장하는 리스트
  final TextEditingController _textController = TextEditingController(); // 메시지 입력 필드의 텍스트를 제어하는 컨트롤러
  final FocusNode _focusNode = FocusNode(); // FocusNode를 추가하여 포커스 제어
  bool _isUserMessage = true; // 메시지가 사용자 메시지인지 여부를 나타내는 변수
  SharedPreferences? _prefs;

  @override
  void initState() {/*_loadMessages와 _saveMessages 메서드를 추가하여 메시지를 로드하고 저장
    _loadMessages는 SharedPreferences에서 메시지 리스트를 불러오고 _saveMessages는 메시지를 저장*/
    super.initState();
    _loadMessages();
  }

  //_isUserMessage 이새끼가 true인지부터 확인
  //그게 맞으면 sendMessage 실행 비동기로 해야 돼요

  void sendMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await apiService.sendMessage(message,token!!);
    if(response.statusCode == 200){
      aiMessage = response.body ;
      // aiMessage이거를 화면에 띄우는 작업 함수로만들던
      // 로그 저장하는 작업
      // _isUserMessage True false 바꾸기
    }
  }
  Future<void> _loadMessages() async {
    _prefs = await SharedPreferences.getInstance();
    String? messagesString = _prefs?.getString('messages');
    if (messagesString != null) {
      List<dynamic> messagesJson = jsonDecode(messagesString);
      setState(() {
        _messages.addAll(messagesJson.map((json) => ChatMessage.fromJson(json)).toList());
      });
    }
  }

  Future<void> _saveMessages() async {
    List<Map<String, dynamic>> messagesJson = _messages.map((message) => message.toJson()).toList();
    await _prefs?.setString('messages', jsonEncode(messagesJson));
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    var message = ChatMessage(
      text: text,
      isUserMessage: _isUserMessage,
    );//_handleSubmitted 메서드에서 메시지를 추가할 때마다 _saveMessages를 호출하여 로컬에 메시지를 저장
    setState(() {
      _messages.insert(0, message);
      _isUserMessage = !_isUserMessage;
    });
    _saveMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(134),
        child: AppBar(
          backgroundColor: Color(0xfff5deb3),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end, // 하단으로 정렬
            children: [
              Container(
                child: Image.asset(
                  'assets/images/icon_app.png', // 이미지 경로
                ),
              ),
              Text(
                '애기동자',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          shape: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 화면 터치 시 포커스 해제.키보드 숨기기
        },
        child: Container(
          color: Color(0xfff5deb3), // 배경색 지정
          child: Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: _buildTextComposer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: "메세지를 입력하세요",
                ),
                focusNode: _focusNode, // FocusNode를 TextField에 추가.
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.red),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({required this.text, required this.isUserMessage});
  final String text;
  final bool isUserMessage; // 사용자인지 상대인지 나타내는 변수

  Map<String, dynamic> toJson() {
    return {//ChatMessage 클래스에 toJson 및 fromJson 메서드를 추가하여 메시지를 JSON으로 변환하고 JSON에서 객체를 생성할 수 있도록 함
      'text': text,
      'isUserMessage': isUserMessage,
    };
  }

  static ChatMessage fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      isUserMessage: json['isUserMessage'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start, // 사용자 메시지는 오른쪽 정렬, 다른 메시지는 왼쪽 정렬
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!isUserMessage) // 사용자 메시지가 아닐 때만 아바타 표시
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(yourname[0])),
            ),
          Expanded( // Expanded 위젯으로 감싸서 부모 위젯의 가로 공간을 모두 사용
            child: Column(
              crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start, // 사용자 메시지는 오른쪽 정렬, 다른 메시지는 왼쪽 정렬
              children: <Widget>[
                Text(isUserMessage ? _name : yourname, style: Theme.of(context).textTheme.headlineSmall),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.all(10.0), // 메시지 박스의 패딩
                  decoration: BoxDecoration(
                    color: isUserMessage ? Colors.red : Colors.white, // 사용자 메시지는 빨간색, 상대 메시지는 흰색 박스
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isUserMessage ? Colors.white : Colors.black, // 사용자 메시지는 흰색, 다른 메시지는 검은색
                    ),
                    softWrap: true, // 텍스트 줄바꿈 설정
                  ),
                ),
              ],
            ),
          ),
          if (isUserMessage)
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: CircleAvatar(child: Text(_name[0])),
            ),
        ],
      ),
    );
  }
}
