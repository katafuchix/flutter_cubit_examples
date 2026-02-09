import '../model/job.dart';

abstract class JobRepository {
  Future<List<Job>> getJobs();
}
