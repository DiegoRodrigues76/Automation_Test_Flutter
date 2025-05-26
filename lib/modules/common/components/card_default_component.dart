import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';

class CardDefaultComponent extends StatefulWidget {
  final double? width;
  final double? height;
  final Widget child;

  const CardDefaultComponent({
    super.key,
    this.width = double.infinity,
    this.height,
    required this.child,
  });

  @override
  State<CardDefaultComponent> createState() => _CardDefaultComponentState();
}

class _CardDefaultComponentState extends State<CardDefaultComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: ZemaColors.lightGrey,
        borderRadius: BorderRadius.circular(ZemaSizes.radius.small ?? 0),
      ),
      child: widget.child,
    );
  }
}
