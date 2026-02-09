import 'package:dio/dio.dart';
import 'job_repository.dart';
import '../model/job.dart';

class JobRepositoryImpl implements JobRepository {
  final Dio _dio;

  JobRepositoryImpl(this._dio);

  @override
  Future<List<Job>> getJobs() async {
    final response =
        await _dio.get("https://6169a28b09e030001712c4dc.mockapi.io/jobs");

    if (response.statusCode != 200) throw Exception('HTTP Error');

    return response.data.map<Job>((item) {
      return Job.fromJson(item);
    }).toList();

    // こういう書き方でもOK
    // return (response.data as List).map((item) => Job.fromJson(item)).toList();

    // 安全な書き方
    // 最も安全で推奨される書き方
    // final list = response.data as List<dynamic>; // まずListであることを保証
    // return list.map((item) => Job.fromJson(item as Map<String, dynamic>)).toList();
  }
}
