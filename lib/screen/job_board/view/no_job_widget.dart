import 'package:flutter/material.dart';
import 'package:job_board/translations/locale_keys.g.dart';
import 'package:job_board/utils/extensions/context_extension.dart';
import 'package:job_board/utils/extensions/string_extension.dart';
import '../base/constants/app_constants.dart';

class NoJobWidget extends StatelessWidget {
  const NoJobWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off, color: AppColors.black),
        Text(
          LocaleKeys.noJobsMessage.locale,
          style: context.textTheme.bodyText1,
        )
      ],
    );
  }
}
