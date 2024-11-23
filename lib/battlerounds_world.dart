import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'package:battlerounds/action.dart';
import 'package:battlerounds/battlerounds_game.dart';
import 'package:battlerounds/components/flat_button.dart';

class BattleroundsWorld extends World with HasGameReference<BattleroundsGame> {
  final cardGap = BattleroundsGame.cardGap;
  final topGap = BattleroundsGame.topGap;
  final cardSpaceWidth = BattleroundsGame.cardSpaceWidth;
  final cardSpaceHeight = BattleroundsGame.cardSpaceHeight;

  // final topHeroCardHolder = CardHolder(position: Vector2(0.0, 0.0));
  // final bottomHeroCardHolder= = CardHolder(position: Vector2(0.0, 0.0));
  // final List<BottomCardHolder> bottomCardHolders = [];
  // final List<TopCardHolder> topCardHolders = [];
  final List<Card> cardsPool = [];
  late Vector2 playAreaSize;

  @override
  Future<void> onLoad() async {
    await Flame.images.load('board_background.png');

    addButton('End Game', 0, 0, ActionType.endGame);
  }

  void addButton(
      String label, double buttonX, double buttonY, ActionType action) {
    final button = FlatButton(
      label,
      size: Vector2(100, 50),
      position: Vector2(buttonX, buttonY),
      onReleased: () {
        game.endGame();
      },
    );
    add(button);
  }

  // draw the background image
  @override
  void render(Canvas canvas) {
    Sprite sprite = Sprite(Flame.images.fromCache('board_background.png'));
    sprite.render(
      canvas,
      anchor: Anchor.center,
    );
  }
}
