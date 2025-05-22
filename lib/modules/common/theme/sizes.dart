import 'package:automation_test_flutter/data/models/size_model.dart';

class ZemaSizes {
  static SizeModel padding = SizeModel(
    tiny: 6,
    extraSmall: 8,
    small: 10,
    medium: 12,
    large: 14,
    extraLarge: 16,
    huge: 18,
    giantic: 20,
    extraGiantic: 30,
  );

  static SizeModel font = SizeModel(
    tiny: 7,
    extraSmall: 9,
    small: 11,
    medium: 13,
    large: 15,
    extraLarge: 17,
    huge: 19,
    giantic: 21,
    extraGiantic: 29,
  );

  static SizeModel icons = SizeModel(
    tiny: 14,
    extraSmall: 16,
    small: 18,
    medium: 20,
    large: 22,
    extraLarge: 24,
    huge: 26,
    giantic: 28,
    extraGiantic: 60,
  );

  static SizeModel images = SizeModel(
    minuscule: 100,
    tiny: 120,
    extraSmall: 140,
    small: 160,
    medium: 180,
    large: 200,
    extraLarge: 220,
    huge: 240,
    giantic: 260,
    extraGiantic: 400,
  );

  static SizeModel radius = SizeModel(
    tiny: 2,
    extraSmall: 8,
    small: 12,
    medium: 16,
    large: 20,
    extraLarge: 24,
    huge: 28,
    giantic: 32,
    extraGiantic: 100,
  );

  static SizeModel opacity = SizeModel(
    extraSmall: 0.2,
    small: 0.4,
    medium: 0.6,
    large: 0.8,
    extraLarge: 1,
  );

  static SizeModel sizeComponents = SizeModel(
    tiny: 0.6,
    extraSmall: 1,
    small: 2,
    medium: 4,
    large: 8,
    extraLarge: 12,
    huge: 18,
    giantic: 24,
    extraGiantic: 100,
  );
}
