import 'package:flutter/material.dart';
import 'package:untitled3/screens/login/login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';




void main() async {
  KakaoSdk.init(
    nativeAppKey : '네이티브앱키',
    javaScriptAppKey: '자바스크립트앱키',
  );
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tab'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Login(), // Login() 위젯으로 변경
      ),
    );
  }
}
