import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:battlerounds/battlerounds_game.dart';

import 'overlays/game_over.dart';
import 'overlays/main_menu.dart';

Future<void> main() async {
  runApp(
    GameWidget<BattleroundsGame>.controlled(
      gameFactory: BattleroundsGame.new,
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'GameOver': (_, game) => GameOver(game: game),
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );
}
