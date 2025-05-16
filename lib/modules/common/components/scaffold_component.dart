import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:automation_test_flutter/modules/common/theme/icons/zema_icons.dart';
import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum BodyRadiusType {
  leftOnly,
  curved,
  linear,
}

class ZemaScaffoldComponent extends StatefulWidget {
  final Widget child;
  final bool hasDefaultPadding;
  final Color bodyBackgroundColor;
  final bool showAppBar;
  final BodyRadiusType bodyRadiusType;
  final Color scaffoldBackgroundColor;
  final Widget? title;
  final Widget? leading;
  final Color? appBarBackgroundColor;
  final List<Widget>? actions;
  final bool validateIdle;
  final bool showMenu;
  final bool isLoading;
  final bool resizeToAvoidBottomInset;

  const ZemaScaffoldComponent({
    required this.child,
    required this.bodyRadiusType,
    this.showAppBar = true,
    this.resizeToAvoidBottomInset = true,
    this.hasDefaultPadding = true,
    this.validateIdle = true,
    this.bodyBackgroundColor = ZemaColors.white,
    this.scaffoldBackgroundColor = ZemaColors.primary,
    this.title,
    this.leading,
    this.appBarBackgroundColor = ZemaColors.primary,
    this.actions,
    this.showMenu = true,
    this.isLoading = false,
    super.key,
  });

  @override
  State<ZemaScaffoldComponent> createState() => _ZemaScaffoldComponentState();
}

class _ZemaScaffoldComponentState extends State<ZemaScaffoldComponent> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool idleWasValidated = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: widget.scaffoldBackgroundColor,
            appBar: widget.showAppBar ? _getAppBar : null,
            drawerEnableOpenDragGesture: widget.showMenu,
            body: SafeArea(
              bottom: false,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.all(
                  widget.hasDefaultPadding ? ZemaSizes.padding.large! : 0,
                ),
                decoration: switch (widget.bodyRadiusType) {
                  BodyRadiusType.leftOnly => _boxDecorationLeftRadius,
                  BodyRadiusType.curved => _boxDecorationCurvedRadius,
                  BodyRadiusType.linear => _boxDecorationLinear,
                },
                child: Skeletonizer(
                  enabled: widget.isLoading,
                  containersColor: ZemaColors.lightGrey,
                  effect: ShimmerEffect(
                    baseColor: ZemaColors.grey.withAlpha(80),
                    highlightColor: ZemaColors.grey.withAlpha(60),
                  ),
                  child: widget.child,
                ),
              ),
            ),
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          ),
        ),
      );
  }


  AppBar get _getAppBar {
    return AppBar(
      centerTitle: true,
      title: widget.title,
      actions: widget.actions,
      leading: _getMenuButton,
      backgroundColor: widget.appBarBackgroundColor,
    );
  }

  Widget? get _getMenuButton {
    return widget.leading ??
        (widget.showMenu
            ? IconButton(
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
                icon: Icon(
                  ZemaIcons.menu,
                  size: ZemaSizes.icons.extraSmall,
                ),
              )
            : const SizedBox.shrink());
  }

  BoxDecoration get _boxDecorationLinear {
    return BoxDecoration(
      color: widget.bodyBackgroundColor,
    );
  }

  BoxDecoration get _boxDecorationLeftRadius {
    return BoxDecoration(
      color: widget.bodyBackgroundColor,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(
          _radiusCircular,
        ),
      ),
    );
  }

  BoxDecoration get _boxDecorationCurvedRadius {
    return BoxDecoration(
      color: widget.bodyBackgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(
          _radiusCircular,
        ),
        topRight: Radius.circular(
          _radiusCircular,
        ),
      ),
    );
  }

  double get _radiusCircular {
    return ZemaSizes.radius.large ?? 0;
  }
}
