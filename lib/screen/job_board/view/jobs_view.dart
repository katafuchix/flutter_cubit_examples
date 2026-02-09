import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_board/screens/job_board/viewmodels/job_board_viewmodel.dart';
import '../../../base/constants/app_constants.dart';
import '../../../core_widgets/no_job_widget.dart';
import '../../../domain/dtos/job_dto.dart';
import '../widgets/job_widget.dart';

class JobsView extends StatelessWidget {
  final bool isAccepted;
  final List<JobResponse> jobs;

  const JobsView({Key? key, this.isAccepted: false, this.jobs: const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vm = context.read<JobBoardViewModel>();
    return Container(
      padding: EdgeInsets.all(AppSpacing.spacingMedium.h),
      color: AppColors.white,
      child: jobs.isEmpty
          ? NoJobWidget()
          : RefreshIndicator(
              onRefresh: () async {
                await vm.init();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int index = 0; index < jobs.length; index++)
                      JobWidget(
                        key: ValueKey<int>(jobs[index].id!),
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
