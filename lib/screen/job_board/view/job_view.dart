import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_board/domain/dtos/job_dto.dart';
import 'package:job_board/utils/extensions/context_extension.dart';
import 'package:job_board/utils/extensions/string_extension.dart';
import 'package:job_board/utils/extensions/datetime_extension.dart';
import '../../../base/constants/app_constants.dart';
import '../../../core_widgets/button_widget.dart';
import '../../../translations/locale_keys.g.dart';

class JobWidget extends StatelessWidget {
  final JobResponse job;
  final bool showButtons;
  final Function? primaryAction;
  final Function? secondaryAction;

  const JobWidget({
    Key? key,
    required this.job,
    this.showButtons: false,
    this.primaryAction,
    this.secondaryAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.0)),
        side: BorderSide(color: AppColors.primary, width: 1),
      ),
      child: Container(
        width: context.width,
        padding: EdgeInsets.all(AppSpacing.spacingMedium.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText(Text(job.title ?? "-",
                style: context.textTheme.subtitle1
                    ?.copyWith(fontWeight: AppFontUtils.medium))),
            _buildText(
              Text(
                "${LocaleKeys.pickUp.locale}: ${job.pickup?.addressLine1 ?? "-"}, ${job.pickup?.postcode ?? "-"}",
                style: context.textTheme.bodyText1,
              ),
            ),
            _buildText(
              Text(
                "${LocaleKeys.dropOff.locale}: ${job.dropOff?.addressLine1 ?? "-"}, ${job.dropOff?.postcode ?? "-"}",
                style: context.textTheme.bodyText1,
              ),
            ),
            _buildText(
              Text(
                "${LocaleKeys.deliveryDate.locale}: ${job.expectedDeliveryDate.dateString}",
                style: context.textTheme.bodyText1
                    ?.copyWith(color: AppColors.secondary),
              ),
            ),
            if (showButtons) _buildButtons(context)
          ],
        ),
      ),
    );
  }

  Widget _buildText(Widget child) => Container(
        margin: EdgeInsets.only(bottom: AppSpacing.spacingXSmall.h),
        child: child,
      );

  Widget _buildButtons(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ButtonWidget(
            onPressed: secondaryAction,
            title: LocaleKeys.reject.locale,
            textStyle: context.textTheme.button,
            borderColor: AppColors.primary,
          ),
          SizedBox(width: AppSpacing.spacingSmall.w),
          ButtonWidget(
            onPressed: primaryAction,
            title: LocaleKeys.accept.locale,
            textStyle:
                context.textTheme.button?.copyWith(color: AppColors.white),
            backgroundColor: AppColors.black,
          ),
        ],
      );
}
