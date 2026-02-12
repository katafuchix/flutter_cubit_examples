import 'package:flutter/material.dart';
import '../extensions/context_extension.dart';
import '../constants/app_constants.dart';
import '../constants/locale_keys.dart';

class NoJobWidget extends StatelessWidget {
  const NoJobWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_off,
          color: AppColors.black,
        ),
        Text(
          LocaleKeys.noJobsMessage,
          style: context.textTheme.bodyLarge,
        )
      ],
    );
  }
}
