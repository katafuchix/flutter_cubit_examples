import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/locale_keys.dart';
import '../extensions/context_extension.dart';
import '../constants/app_constants.dart';
import '../job_board_cubit.dart';
import 'button_widget.dart';

class TryAgainWidget extends StatelessWidget {
  final String message;

  const TryAgainWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.white, // ここで背景色を指定
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: context.textTheme.labelLarge),
            SizedBox(height: AppSpacing.spacingSmall.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonWidget(
                  title: LocaleKeys.tryAgain,
                  onPressed: () async {
                    await context.read<JobBoardCubit>().fetchJobs();
                  },
                  backgroundColor: AppColors.black,
                  useTimer: false,
                  textStyle: context.textTheme.bodyMedium
                      ?.copyWith(color: AppColors.white),
                ),
              ],
            ),
          ],
        ));
  }
}
