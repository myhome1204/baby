import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:untitled3/models/Service/ApiService.dart';

void main() => runApp(Chat());

String _name = "Jerry";
const String yourname = "애기동자";
String userMessage = "";
String aiMessage = "";

class Chat extends StatelessWidget {
  get context => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FriendlychatApp",
      home: ChatScreen(),
    );
  }

  Future<void> saveMessagesForUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final chatScreenState = context.findAncestorStateOfType<ChatScreenState>();
    if (chatScreenState != null) {
      await chatScreenState.saveMessagesForUser(userId);
    }
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
  String? _userId; // 사용자 ID를 저장할 변수

  Future<void> makeChatroom() async {
    print("makeChatroom 함수는 시작됨");
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token")!;
    print("token : ${token}");
    final response = await apiService.chatrooms(token);
    if (response.statusCode == 200) {
      print("makeChatroom!!");
    } else {
      print("Error: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }

  Future<void> sendMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token")!;
    var response = await apiService.sendMessage(message, token);
    if (response.statusCode == 200) {
      print("ai한테 메시지 전달 성공");
    }
  }

  Future<void> receivedMessage() async {
    print("received 함수는 실행됨");
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token")!;
    var response = await apiService.receivedMessage(token);
    if (response.statusCode == 200) {
      print("ai한테 답 받아옴");

      // 응답 본문을 UTF-8로 디코딩
      final responseBody = utf8.decode(response.bodyBytes);
      final responseData = jsonDecode(responseBody);
      String output = responseData['message'];
      aiMessage = output;
      print("aiMessage : $aiMessage");

      var message = ChatMessage(
        text: aiMessage,
        isUserMessage: false,
      );
      setState(() {
        _messages.insert(0, message);
      });
      _saveMessages();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
    makeChatroom();
    _loadMessages();
  }

  Future<void> _loadUserId() async {
    _prefs = await SharedPreferences.getInstance();
    _userId = _prefs?.getString('user_id');
    _name = _userId!!;
  }

  Future<void> _loadMessages() async {
    _prefs = await SharedPreferences.getInstance();
    String? messagesString = _prefs?.getString('messages_$_userId');
    if (messagesString != null) {
      List<dynamic> messagesJson = jsonDecode(messagesString);
      setState(() {
        _messages.addAll(messagesJson.map((json) => ChatMessage.fromJson(json)).toList());
      });
    }
  }

  Future<void> _saveMessages() async {
    List<Map<String, dynamic>> messagesJson = _messages.map((message) => message.toJson()).toList();
    await _prefs?.setString('messages_$_userId', jsonEncode(messagesJson));
  }

  // 사용자가 로그아웃할 때 호출하여 메시지 저장
  Future<void> saveMessagesForUser(String userId) async {
    _prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> messagesJson = _messages.map((message) => message.toJson()).toList();
    await _prefs?.setString('messages_$userId', jsonEncode(messagesJson));
  }

  Future<void> _handleSubmitted(String text) async {
    _textController.clear();
    var message = ChatMessage(
      text: text,
      isUserMessage: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    userMessage = text;
    await sendMessage(userMessage);
    await receivedMessage();
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
    return {
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
