import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:automation_test_flutter/modules/common/theme/icons/zema_icons.dart';
import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';

enum CardType { warning }

const Map<CardType, Color> cardColors = {
  CardType.warning: ZemaColors.lightYellow,
};

const Map<CardType, Color> iconColors = {
  CardType.warning: ZemaColors.darkYellow,
};

class CardWarningComponent extends StatelessWidget {
  const CardWarningComponent({
    super.key,
    required this.child,
    this.cardType = CardType.warning,
  });

  final Widget child;
  final CardType cardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColors[cardType],
        borderRadius: BorderRadius.circular(ZemaSizes.radius.extraSmall ?? 0),
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: ZemaSizes.padding.extraLarge ?? 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ZemaSizes.padding.extraLarge ?? 0),
              child: CircleAvatar(
                backgroundColor: iconColors[cardType],
                radius: ZemaSizes.radius.extraLarge ?? 0,
                child: const Icon(
                  ZemaIcons.info,
                  color: ZemaColors.white,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: child,
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
