import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'constants/app_constants.dart';
import 'extensions/string_extension.dart';
import 'state/job_board_state.dart';
import 'job_board_cubit.dart';
import 'model/job.dart';
import 'repository/job_repository_impl.dart';
import 'constants/locale_keys.dart';
import 'view/jobs_view.dart';

class JobBoardScreen extends StatelessWidget {
  const JobBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JobBoardCubit(JobRepositoryImpl(Dio())),
      child: const JobBoardPage(),
    );
  }
}

class JobBoardPage extends StatefulWidget {
  const JobBoardPage({super.key});

  @override
  State<JobBoardPage> createState() => JobBoardPageState();
}

class JobBoardPageState extends State<JobBoardPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    context.read<JobBoardCubit>().fetchJobs();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Job Board"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: BlocConsumer<JobBoardCubit, JobBoardState>(
            // リスナが呼び出される条件
            listenWhen: (previous, current) =>
                previous.screen != current.screen,
            listener: (context, state) {
              // ローディング制御
              final isScreenLoading = state.screen is ScreenLoading;
              if (isScreenLoading) {
                SmartDialog.showLoading(msg: '検索中...');
              } else {
                SmartDialog.dismiss();
              }
            },
            builder: (context, state) {
              print('builder');
              return Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.black,
                    unselectedLabelColor: AppColors.black.withOpacity(0.5),
                    //labelStyle: context.textTheme.bodyLarge,
                    labelStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    //unselectedLabelStyle: context.textTheme.bodyLarge,
                    unselectedLabelStyle: const TextStyle(fontSize: 16),
                    padding: EdgeInsets.only(top: AppSpacing.spacingMedium.h),
                    //indicatorColor: AppColors.black,
                    indicator: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                        width: 0,
                        color: Colors.white,
                      )),
                    ),
                    labelPadding:
                        EdgeInsets.only(bottom: AppSpacing.spacingMedium.h),
                    tabs: [
                      Text(LocaleKeys.jobs),
                      Text(LocaleKeys.acceptedJobs),
                    ],
                  ),
                  Expanded(
                    child: Container(
                        color: AppColors.white,
                        child: state.screen.when(initial: () {
                          return _buildLoading();
                        }, loading: () {
                          return _buildLoading();
                        }, success: (List<Job> results) {
                          return TabBarView(
                            controller: _tabController,
                            children: [
                              JobsView(
                                  key: UniqueKey(),
                                  jobs: results
                                      .where((element) =>
                                          element.jobType == JobType.Normal)
                                      .toList()),
                              JobsView(
                                  key: UniqueKey(),
                                  isAccepted: true,
                                  jobs: results
                                      .where((element) =>
                                          element.jobType == JobType.Accepted)
                                      .toList()),
                            ],
                          );
                        }, error: (String message) {
                          return _buildLoading();
                        })),
                  ),
                ],
              );
            }));
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
