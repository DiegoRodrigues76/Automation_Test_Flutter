// lib/data/models/size_model.dart

class SizeModel {
  SizeModel({
    required this.medium,
    this.minuscule,
    this.tiny,
    this.extraSmall,
    this.small,
    this.large,
    this.extraLarge,
    this.huge,
    this.giantic,
    this.extraGiantic,
  });
  final double? minuscule;
 
  final double? tiny;
  final double? extraSmall;
  final double? small;
  final double medium;
  final double? large;
  final double? extraLarge;
  final double? huge;
  final double? giantic;
  final double? extraGiantic;
}