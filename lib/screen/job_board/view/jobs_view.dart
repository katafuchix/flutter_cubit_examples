import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_examples/screen/job_board/job_board_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_constants.dart';
import '../model/job.dart';
import 'job_view.dart';
import 'no_job_widget.dart';

class JobsView extends StatelessWidget {
  final bool isAccepted;
  final List<Job> jobs;

  const JobsView({super.key, this.isAccepted = false, this.jobs = const []});

  @override
  Widget build(BuildContext context) {
    var vm = context.read<JobBoardCubit>();
    print("vm");
    print(vm);
    print(isAccepted);
    return Container(
      padding: EdgeInsets.all(AppSpacing.spacingMedium.h),
      color: AppColors.white,
      child: jobs.isEmpty
          ? const NoJobWidget()
          : RefreshIndicator(
              onRefresh: () async {
                //await vm.init();
                await context.read<JobBoardCubit>().fetchJobs();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int index = 0; index < jobs.length; index++)
                      JobWidget(
                        key: ValueKey<int>(jobs[index].id),
                        job: jobs[index],
                        showButtons: !isAccepted,
                        primaryAction: () =>
                            vm.changeTypeOfJob(index, JobType.Accepted),
                        secondaryAction: () =>
                            vm.changeTypeOfJob(index, JobType.Rejected),
                      )
                  ],
                ),
              ),
            ),
    );
  }
}
