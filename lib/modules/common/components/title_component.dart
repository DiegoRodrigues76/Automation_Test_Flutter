import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';

class ZemaTitleComponent extends StatelessWidget {
  final String title;
  final bool hasPadding;
  final TextAlign? textAlign;

  const ZemaTitleComponent({
    required this.title,
    this.textAlign = TextAlign.center,
    this.hasPadding = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: hasPadding ? ZemaSizes.padding.extraLarge ?? 0 : 0,
      ),
      child: Text(
        title,
        textAlign: textAlign,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ZemaSizes.font.extraLarge ?? 0,
        ),
      ),
    );
  }
}
