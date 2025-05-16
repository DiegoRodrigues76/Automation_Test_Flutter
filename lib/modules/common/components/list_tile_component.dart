import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';

enum LisTileType {
  payments,
  pendencies,
  pixKey,
  transactions,
  bankStatement,
}

const double _elevationListTile = 1.0;

class ZemaListTileComponent extends StatelessWidget {
  final bool enable;
  final String title;
  final bool hasDecoration;
  final LisTileType listTileType;
  final IconData? icon;
  final String? subTitle;
  final VoidCallback? action;
  final IconData? iconTrailing;
  final String? transactionValue;
  final String? date;
  final TextStyle? transactionValueTextStyle;

  const ZemaListTileComponent({
    this.enable = true,
    required this.title,
    this.hasDecoration = false,
    required this.listTileType,
    this.icon,
    this.subTitle,
    this.action,
    this.iconTrailing,
    this.transactionValue,
    super.key,
    this.date,
    this.transactionValueTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return switch (listTileType) {
      LisTileType.payments => _paymentsListTile,
      LisTileType.pendencies => _pendenciesListTile,
      LisTileType.pixKey => _pixKeyListTile,
      LisTileType.transactions => _transactionsListTile,
      LisTileType.bankStatement => _bankStatementListTile,
    };
  }

  Widget get _pixKeyListTile {
    return GestureDetector(
      onTap: action,
      child: Container(
        margin: EdgeInsets.only(
          bottom: ZemaSizes.padding.medium,
        ),
        padding: EdgeInsets.all(
          ZemaSizes.padding.medium,
        ),
        decoration: hasDecoration != false
            ? BoxDecoration(
                color: ZemaColors.lightGrey,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    ZemaSizes.radius.extraSmall ?? 0,
                  ),
                ),
              )
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  subTitle ?? '',
                  style: TextStyle(
                    color: ZemaColors.grey,
                    fontSize: ZemaSizes.font.medium,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(
              iconTrailing,
              size: ZemaSizes.icons.small,
              color: ZemaColors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Material get _paymentsListTile {
    return Material(
      color: ZemaColors.lightGrey,
      elevation: _elevationListTile,
      borderRadius: BorderRadius.all(
        Radius.circular(ZemaSizes.radius.extraSmall ?? 0),
      ),
      child: InkWell(
        onTap: action,
        child: Container(
          alignment: Alignment.center,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: ZemaColors.darkYellow,
              child: Icon(
                icon,
                size: ZemaSizes.sizeComponents.giantic,
                color: ZemaColors.white,
              ),
            ),
            title: Text(
              title,
              style: _textStyleFontNormal,
            ),
          ),
        ),
      ),
    );
  }

  Material get _pendenciesListTile {
    return Material(
      color: ZemaColors.lightGrey,
      elevation: _elevationListTile,
      borderRadius: BorderRadius.all(
        Radius.circular(ZemaSizes.radius.extraSmall ?? 0),
      ),
      child: InkWell(
        onTap: action,
        child: Container(
          alignment: Alignment.center,
          child: ListTile(
            leading: Icon(
              icon,
              size: ZemaSizes.sizeComponents.giantic,
              color: ZemaColors.primary,
            ),
            title: Text(
              title,
              style: _textStyleFontBold,
            ),
            trailing: _trailingIcon,
          ),
        ),
      ),
    );
  }

  Column get _bankStatementListTile {
    return Column(
      children: [
        ListTile(
          onTap: action,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                date ?? '',
                style: TextStyle(
                  fontSize: ZemaSizes.font.medium,
                  color: ZemaColors.grey,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: ZemaSizes.font.large,
                  fontWeight: FontWeight.bold,
                  color: ZemaColors.darkGrey,
                ),
              ),
              Text(transactionValue ?? '',
                  style: transactionValueTextStyle ?? _textStyleFontBold),
              Text(
                subTitle ?? '',
                style: TextStyle(
                  fontSize: ZemaSizes.font.large,
                  color: ZemaColors.darkGrey,
                ),
              ),
            ],
          ),
          trailing: const Icon(
            Icons.chevron_right_outlined,
            color: ZemaColors.grey,
          ),
        ),
        const Divider(
          color: ZemaColors.lightGrey,
        ),
      ],
    );
  }

  InkWell get _transactionsListTile {
    return InkWell(
      onTap: action,
      child: Container(
        color: ZemaColors.lightGrey,
        alignment: Alignment.center,
        child: ListTile(
          leading: Icon(
            icon,
            size: ZemaSizes.sizeComponents.giantic,
            color: ZemaColors.primary,
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: _textStyleFontBold,
              ),
              Text(
                subTitle ?? '',
                style: _textStyleFontNormal,
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                transactionValue ?? '',
                style: transactionValueTextStyle ?? _textStyleFontBold,
              ),
              _trailingIcon,
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _textStyleFontBold {
    return TextStyle(
      fontSize: ZemaSizes.font.extraLarge,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get _textStyleFontNormal {
    return TextStyle(
      fontSize: ZemaSizes.font.extraLarge,
      fontWeight: FontWeight.normal,
    );
  }

  Icon get _trailingIcon {
    return Icon(
      Icons.arrow_forward_ios,
      color: ZemaColors.darkGrey,
      size: ZemaSizes.sizeComponents.huge,
    );
  }
}
