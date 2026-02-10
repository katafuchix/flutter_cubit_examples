import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'constants/app_constants.dart';
import 'extensions/context_extension.dart';
import 'extensions/string_extension.dart';
import 'state/job_board_state.dart';
import 'job_board_cubit.dart';
import 'model/job.dart';
import 'repository/job_repository_impl.dart';
import 'translations/locale_keys.g.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Job Board"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<JobBoardCubit, JobBoardState>(
        // リスナが呼び出される条件
        listenWhen: (previous, current) => previous.screen != current.screen,
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
            return Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.black,
                  unselectedLabelColor: AppColors.black.withOpacity(0.5),
                  labelStyle: context.textTheme.displayMedium,
                  unselectedLabelStyle: context.textTheme.displayMedium,
                  //padding: EdgeInsets.only(top: AppSpacing.spacingMedium.h),
                  indicatorColor: AppColors.black,
                  //labelPadding: EdgeInsets.only(bottom: AppSpacing.spacingMedium.h),
                  tabs: [
                    Text(LocaleKeys.jobs.locale),
                    Text(LocaleKeys.acceptedJobs.locale),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: AppColors.white,
                    child:   //CircularProgressIndicator()
            state.screen.when(initial: () { return _buildLoading(); },
                loading: () { return _buildLoading(); },
                success: (List<Job> results) { return _buildLoading(); },
                error: (String message) { return _buildLoading(); })
                      
            /*BaseView<JobBoardViewModel>(
                      vmBuilder: (context) => JobBoardViewModel(JobBoardService()),
                      listener: (context, state) => debugPrint(state.runtimeType.toString()),
                      builder: (context, state) => _buildTabBarView(state as BaseCompletedState),
                      errorBuilder: (context, state) => TryAgainWidget(errorState: state), 
                    ),*/
                  ),
                ),
              ],
            );
          }
      )




                /*Expanded(
            child: Container(
              color: AppColors.white,
              child: BaseView<JobBoardViewModel>(
                vmBuilder: (context) => JobBoardViewModel(JobBoardService()),
                listener: (context, state) =>
                    debugPrint(state.runtimeType.toString()),
                builder: (context, state) =>
                    _buildTabBarView(state as BaseCompletedState),
                errorBuilder: (context, state) =>
                    TryAgainWidget(errorState: state),
              ),
            ),
          ),*/

    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  /*
  Widget _buildTabBarView(JobBoardState state) => TabBarView(
        controller: _tabController,
        children: [
          JobsView(jobs: (state.screen)[JobType.Normal]),
          JobsView(isAccepted: true, jobs: (state.data)[JobType.Accepted]),
        ],
      ); */
}
