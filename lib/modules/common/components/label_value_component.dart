import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';

class ZemaLabelValueComponent extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? widgetValue;
  final bool withBottomPadding;

  const ZemaLabelValueComponent({
    required this.label,
    this.value,
    this.withBottomPadding = true,
    this.widgetValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: withBottomPadding ? ZemaSizes.padding.medium : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ZemaColors.grey,
              fontSize: ZemaSizes.font.medium,
              overflow: TextOverflow.ellipsis,
            ),
            softWrap: true,
            maxLines: 1,
          ),
          widgetValue ??
              Text(
                value ?? '',
                style: TextStyle(
                  fontSize: ZemaSizes.font.large,
                  overflow: TextOverflow.ellipsis,
                ),
                softWrap: true,
                maxLines: 2,
              ),
        ],
      ),
    );
  }
}
