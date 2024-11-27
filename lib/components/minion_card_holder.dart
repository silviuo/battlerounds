import 'dart:ui';

import 'package:battlerounds/battlerounds_game.dart';
import 'package:battlerounds/components/game_card.dart';
import 'package:battlerounds/models/card_holder.dart';
import 'package:flame/components.dart';

class MinionCardHolder extends PositionComponent implements CardHolder {
  MinionCardHolder({super.position}) : super(size: BattleroundsGame.cardSize);

  /// Which card is currently placed onto this holder.
  GameCard? _card;
  final Vector2 _fanOffset1 = Vector2(0, BattleroundsGame.cardHeight * 0.05);
  final Vector2 _fanOffset2 = Vector2(0, BattleroundsGame.cardHeight * 0.2);

  //#region GameCard API

  @override
  bool canMoveCard(GameCard card, MoveMethod method) => true;
  // No restrictions on moving cards from minion holder, e.g. selling minions.

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
    card.priority = 1;
    _card = card;
    placeCardOntoHolder();
  }

  //#endregion

  void dropCards(GameCard firstCard,
      [List<GameCard> attachedCards = const []]) {
    final cardList = [firstCard];
    cardList.addAll(attachedCards);
    Vector2 nextPosition = _cards.isEmpty ? position : _cards.last.position;
    var nCardsToMove = cardList.length;
    for (final card in cardList) {
      card.pile = this;
      card.priority = _cards.length;
      if (_cards.isNotEmpty) {
        nextPosition =
            nextPosition + (card.isFaceDown ? _fanOffset1 : _fanOffset2);
      }
      _cards.add(card);
      card.doMove(
        nextPosition,
        startPriority: card.priority,
        onComplete: () {
          nCardsToMove--;
          if (nCardsToMove == 0) {
            calculateHitArea(); // Expand the hit-area.
          }
        },
      );
    }
  }

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
