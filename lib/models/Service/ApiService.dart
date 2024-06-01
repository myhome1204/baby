import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled3/models/signup_data/User.dart';

class ApiService {
  static const String baseUrl = 'https://port-0-baby-monk-rm6l2llwb02l9k.sel5.cloudtype.app'; // API 기본 URL

  Future<http.Response> createMember(User user) async {
    final url = Uri.parse('$baseUrl/members');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    return response;
  }

  Future<http.Response> checkUserIdDuplicate(String userId) async {
    final url = Uri.parse('$baseUrl/members/check-duplicate/$userId');
    final response = await http.get(url);
    return response;
  }

  Future<http.Response> logIn(String userId, String password) async {
    final url = Uri.parse('$baseUrl/members/log-in');
    final body = jsonEncode({
      'member_user_id': userId,
      'password': password,
    });
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    return response;
  }

  // 토큰 검사를 위한 엔드포인트가 별도로 존재하지 않아
  // 기존의 사용자 정보 조회 엔드포인트를 활용하여 토큰의 유효성을 확인
  Future<http.Response> checkTokenValidity(String token) async {
    final url = Uri.parse('$baseUrl/members/member-info');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<http.Response> giveEight(Map<String, String> eight, String token) async {
    final url = Uri.parse('$baseUrl/saju/save-text');
    final body = jsonEncode({
      'eight': eight
    });

    // eight 값 출력하여 확인
    print("Sending eight: $eight");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    return response;
  }

  Future<http.Response> getMemberInfo(String token) async {
    final url = Uri.parse('$baseUrl/members/member-info');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
  Future<http.Response> getMemberName(String token) async {
    final url = Uri.parse('$baseUrl/members/member-name');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
  Future<http.Response> getMemberEmail(String token) async {
    final url = Uri.parse('$baseUrl/members/member-email');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
  Future<http.Response> getMemberBirthday(String token) async {
    final url = Uri.parse('$baseUrl/members/member-birthday');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
  Future<http.Response> getMemberBirthdayTime(String token) async {
    final url = Uri.parse('$baseUrl/members/member-birthdaytime');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
}
