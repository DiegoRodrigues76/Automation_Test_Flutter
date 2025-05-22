import 'package:automation_test_flutter/presentation/components/scaffold_component.dart';
import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:flutter/material.dart';

class LoadingHelper extends StatefulWidget {
  const LoadingHelper({
    super.key,
  });

  @override
  State<LoadingHelper> createState() => _LoadingHelperState();
}

class _LoadingHelperState extends State<LoadingHelper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.repeat();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZemaScaffoldComponent(
      showAppBar: false,
      bodyBackgroundColor: ZemaColors.primary,
      bodyRadiusType: BodyRadiusType.linear,
      child: Align(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.scale(
              scale: _controller.value,
              child: child,
            );
          },
          child: Icon(
            Icons.star,
            color: Colors.yellow,
          ),
        ),
      ),
    );
  }
}
