import 'dart:ui';

import 'package:flame/components.dart';

import 'package:battlerounds/battlerounds_game.dart';
import 'package:battlerounds/components/game_card.dart';
import 'package:battlerounds/models/card_holder.dart';

class MinionCardHolder extends PositionComponent implements CardHolder {
  MinionCardHolder({super.position}) : super(size: BattleroundsGame.cardSize);

  /// Which card is currently placed onto this holder.
  GameCard? _card;

  //#region GameCard API

  @override
  bool canMoveCard(GameCard card, MoveMethod method) => true;
  // No restrictions on moving cards from minion holder,
  // e.g. selling minions, changing their attack order.

  @override
  bool canAcceptCard(GameCard card) {
    return _card == null; // Only one card can be placed onto this holder.
  }

  @override
  void removeCard(GameCard card, MoveMethod method) {
    assert(_card == card);
    _card = null;
  }

  @override
  void returnCard(GameCard card) {
    card.priority = 1;
    placeCardOntoHolder();
  }

  @override
  void acquireCard(GameCard card) {
    card.cardHolder = this;
    _card = card;
    placeCardOntoHolder();
  }

  //#endregion

  void placeCardOntoHolder() {
    if (_card == null) {
      return;
    }
    _card!.position.setFrom(position);
    _card!.priority = 1;
  }

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
