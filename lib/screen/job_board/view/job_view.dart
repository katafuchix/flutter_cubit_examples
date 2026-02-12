import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extensions/context_extension.dart';
import '../extensions/datetime_extension.dart';
import '../constants/app_constants.dart';
import '../constants/locale_keys.dart';
import '../model/job.dart';
import 'button_widget.dart';

class JobWidget extends StatelessWidget {
  final Job job;
  final bool showButtons;
  final Function? primaryAction;
  final Function? secondaryAction;

  const JobWidget({
    super.key,
    required this.job,
    this.showButtons = false,
    this.primaryAction,
    this.secondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.0)),
        side: BorderSide(color: AppColors.primary, width: 1),
      ),
      child: Container(
        width: context.width,
        padding: EdgeInsets.all(AppSpacing.spacingMedium.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText(Text(job.title,
                style: context.textTheme.displayMedium
                    ?.copyWith(fontWeight: AppFontUtils.medium))),
            _buildText(
              Text(
                "${LocaleKeys.pickUp}: ${job.pickup.addressLine1}, ${job.pickup.postcode}",
                style: context.textTheme.bodyLarge,
              ),
            ),
            _buildText(
              Text(
                "${LocaleKeys.dropOff}: ${job.dropOff.addressLine1}, ${job.dropOff.postcode}",
                style: context.textTheme.bodyLarge,
              ),
            ),
            _buildText(
              Text(
                "${LocaleKeys.deliveryDate}: ${job.expectedDeliveryDate.dateString}",
                style: context.textTheme.bodyLarge
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
            title: LocaleKeys.reject,
            textStyle: context.textTheme.labelLarge,
            borderColor: AppColors.primary,
          ),
          SizedBox(width: AppSpacing.spacingSmall.w),
          ButtonWidget(
            onPressed: primaryAction,
            title: LocaleKeys.accept,
            textStyle:
                context.textTheme.labelLarge?.copyWith(color: AppColors.white),
            backgroundColor: AppColors.black,
          ),
        ],
      );
}
