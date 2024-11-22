import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'package:battlerounds/battlerounds_game.dart';

void main() {
  final game = BattleroundsGame();
  runApp(GameWidget(game: game));
}
