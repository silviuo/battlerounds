import 'dart:ui';

import 'package:flame/components.dart';

import 'package:battlerounds/battlerounds_game.dart';
import 'package:battlerounds/components/hero_card.dart';

class HeroCardHolder extends PositionComponent {
  HeroCardHolder({super.position}) : super(size: BattleroundsGame.cardSize);

  /// Which card is currently placed onto this holder.
  HeroCard? _card;

  //#region Rendering

  // TODO Replace border by border asset.
  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(BattleroundsGame.cardRRect, _borderPaint);
  }

  //#endregion
}
