import 'package:dio/dio.dart';
import 'user_repository.dart';
import '../model/user.dart';

class UserRepositoryImpl implements UserRepository {
  final Dio _dio;

  UserRepositoryImpl(this._dio);

  @override
  Future<List<User>> getUsers() async {

    final response = await _dio.get("https://jsonplaceholder.typicode.com/users");

    if (response.statusCode != 200) throw Exception('HTTP Error');

    return response.data.map<User>((item) {
        return User.fromJson(item);
      }).toList();

    // こういう書き方でもOK
    // return (response.data as List).map((user) => User.fromJson(user)).toList();

    // 安全な書き方
    // 最も安全で推奨される書き方
    // final list = response.data as List<dynamic>; // まずListであることを保証
    // return list.map((item) => User.fromJson(item as Map<String, dynamic>)).toList();

  }

}