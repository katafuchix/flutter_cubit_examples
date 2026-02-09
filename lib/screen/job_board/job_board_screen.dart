import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_examples/core/colors.dart';
import 'package:flutter_cubit_examples/screen/job_board/state/job_board_state.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'job_board_cubit.dart';
import 'model/job.dart';
import 'repository/job_repository_impl.dart';

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
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: MyColors().black2,
            unselectedLabelColor: MyColors().black2.withOpacity(0.5),
            //labelStyle: context.textTheme.subtitle1,
            //unselectedLabelStyle: context.textTheme.subtitle1,
            padding: EdgeInsets.only(top: 10),
            indicatorColor: MyColors().black1,
            labelPadding: EdgeInsets.only(bottom: 10),
            tabs: [
              Text("JOBS"),
              Text("ACCEPTED JOBS"),
            ],
          ),
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
        ],
      ),
    );
  }

  Widget _buildTabBarView(JobBoardState state) => TabBarView(
        controller: _tabController,
        children: [
          //JobsView(jobs: (state.screen)[JobType.Normal]),
          //JobsView(isAccepted: true, jobs: (state.data)[JobType.Accepted]),
        ],
      );
}
