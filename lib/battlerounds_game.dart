import 'dart:ui';

import 'package:battlerounds/battlerrounds_world.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

class BattleroundsGame extends FlameGame<BattleroundsWorld> {
  // This BattleroundsGame constructor also initiates the first BattleroundsWorld.
  BattleroundsGame() : super(world: BattleroundsWorld());
}
