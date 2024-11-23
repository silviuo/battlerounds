import 'dart:ui';

import 'package:battlerounds/battlerounds_world.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

class BattleroundsGame extends FlameGame<BattleroundsWorld> {
  static const double cardGap = 175.0;
  static const double topGap = 500.0;
  static const double cardHeight = 1400.0;
  static const double cardWidth = 1000.0;
  static const double cardRadius = 100.0;
  static const double cardSpaceWidth = cardWidth + cardGap;
  static const double cardSpaceHeight = cardHeight + cardGap;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);
  static final cardRRect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(0, 0, cardWidth, cardHeight),
    const Radius.circular(cardRadius),
  );

  /// Constant used to decide when a short drag is treated as a TapUp event.
  static const double dragTolerance = cardWidth / 5;

  /// Constant used when creating Random seed.
  static const int maxInt = 0xFFFFFFFE; // = (2 to the power 32) - 1
  // This BattleroundsGame constructor also initiates the first BattleroundsWorld.
  BattleroundsGame() : super(world: BattleroundsWorld());

  void initializeGame() {
    world = BattleroundsWorld();
  }

  void reset() {
    // Game restart logic here.
  }

  void endGame() {
    overlays.add('GameOver');
  }

  @override
  void update(double dt) {
    // Future.delayed(Duration(seconds: 3), () {
    //   overlays.add('GameOver');
    // });

    super.update(dt);
  }
}
