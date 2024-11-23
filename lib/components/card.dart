import 'dart:math';
import 'dart:ui';

import 'package:battlerounds/battlerounds_game.dart';
import 'package:battlerounds/battlerounds_world.dart';
import 'package:battlerounds/models/card_holder.dart';
import 'package:battlerounds/models/race.dart';
import 'package:battlerounds/models/tier.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/animation.dart';

class Card extends PositionComponent
    with DragCallbacks, TapCallbacks, HasWorldReference<BattleroundsWorld> {
  Card(Tier tier, Race race)
      : _tier = tier,
        _race = race,
        super(
          size: BattleroundsGame.cardSize,
        );

  final Tier _tier;
  final Race _race;
  // final CardHolder cardHolder;

  // A Base Card is rendered in outline only and is NOT playable. It can be
  // added to the base of a Pile (e.g. the Stock Pile) to allow it to handle
  // taps and short drags (on an empty Pile) with the same behavior and
  // tolerances as for regular cards (see BattleroundsGame.dragTolerance) and using
  // the same event-handling code, but with different handleTapUp() methods.
  // final bool isBaseCard;

  bool _isDragging = false;
  Vector2 _whereCardStarted = Vector2(0, 0);

  final List<Card> attachedCards = [];

  @override
  String toString() =>
      "Tier ${_tier.value} Race ${_race.name}"; // e.g. "Tier 1 Race human" or "Tier 3 Race goblin"

  //#region Rendering

  @override
  void render(Canvas canvas) {
    // if (isBaseCard) {
    //   _renderBaseCard(canvas);
    // }else {
    //   _renderCard(canvas);
    // }
  }

  static final Paint backBackgroundPaint = Paint()
    ..color = const Color(0xff380c02);
  static final Paint backBorderPaint1 = Paint()
    ..color = const Color(0xffdbaf58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final Paint backBorderPaint2 = Paint()
    ..color = const Color(0x5CEF971B)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 35;
  static final RRect cardRRect = RRect.fromRectAndRadius(
    BattleroundsGame.cardSize.toRect(),
    const Radius.circular(BattleroundsGame.cardRadius),
  );
  static final RRect backRRectInner = cardRRect.deflate(40);
  // static final Sprite cardFace = Sprite;

  void _renderCard(Canvas canvas) {
    canvas.drawRRect(cardRRect, backBackgroundPaint);
    canvas.drawRRect(cardRRect, backBorderPaint1);
    canvas.drawRRect(backRRectInner, backBorderPaint2);
    // cardFace.render(canvas, position: size / 2, anchor: Anchor.center);
  }

  void _renderBaseCard(Canvas canvas) {
    canvas.drawRRect(cardRRect, backBorderPaint1);
  }

  static final Paint frontBackgroundPaint = Paint()
    ..color = const Color(0xff000000);
  static final Paint redBorderPaint = Paint()
    ..color = const Color(0xffece8a3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final Paint blackBorderPaint = Paint()
    ..color = const Color(0xff7ab2e8)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final blueFilter = Paint()
    ..colorFilter = const ColorFilter.mode(
      Color(0x880d8bff),
      BlendMode.srcATop,
    );

  void _drawSprite(
    Canvas canvas,
    Sprite sprite,
    double relativeX,
    double relativeY, {
    double scale = 1,
    bool rotate = false,
  }) {
    if (rotate) {
      canvas.save();
      canvas.translate(size.x / 2, size.y / 2);
      canvas.rotate(pi);
      canvas.translate(-size.x / 2, -size.y / 2);
    }
    sprite.render(
      canvas,
      position: Vector2(relativeX * size.x, relativeY * size.y),
      anchor: Anchor.center,
      size: sprite.srcSize.scaled(scale),
    );
    if (rotate) {
      canvas.restore();
    }
  }

  //#endregion

  //#region Card-Dragging

  @override
  void onTapCancel(TapCancelEvent event) {
    // if (cardHolder is StockPile) {
    //   _isDragging = false;
    //   handleTapUp();
    // }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    // if (cardHolder is StockPile) {
    //   _isDragging = false;
    //   return;
    // }
    // // Clone the position, else _whereCardStarted changes as the position does.
    // _whereCardStarted = position.clone();
    // attachedCards.clear();
    // if (cardHolder?.canMoveCard(this, MoveMethod.drag) ?? false) {
    //   _isDragging = true;
    //   priority = 100;
    //   if (cardHolder is TableauPile) {
    //     final extraCards = (cardHolder! as TableauPile).cardsOnTop(this);
    //     for (final card in extraCards) {
    //       card.priority = attachedCards.length + 101;
    //       attachedCards.add(card);
    //     }
    //   }
    // }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_isDragging) {
      return;
    }
    final delta = event.localDelta;
    position.add(delta);
    attachedCards.forEach((card) => card.position.add(delta));
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!_isDragging) {
      return;
    }
    _isDragging = false;

    // If short drag, return card to Pile and treat it as having been tapped.
    final shortDrag =
        (position - _whereCardStarted).length < BattleroundsGame.dragTolerance;
    if (shortDrag && attachedCards.isEmpty) {
      doMove(
        _whereCardStarted,
        onComplete: () {
          // cardHolder!.returnCard(this);
          // Card moves to its Foundation Pile next, if valid, or it stays put.
          handleTapUp();
        },
      );
      return;
    }

    // Find out what is under the center-point of this card when it is dropped.
    // final dropPiles = parent!
    //     .componentsAtPoint(position + size / 2)
    //     .whereType<Pile>()
    //     .toList();
    // if (dropPiles.isNotEmpty) {
    //   if (dropPiles.first.canAcceptCard(this)) {
    //     // Found a Pile: move card(s) the rest of the way onto it.
    //     cardHolder!.removeCard(this, MoveMethod.drag);
    //     if (dropPiles.first is TableauPile) {
    //       // Get TableauPile to handle positions, priorities and moves of cards.
    //       (dropPiles.first as TableauPile).dropCards(this, attachedCards);
    //       attachedCards.clear();
    //     } else {
    //       // Drop a single card onto a FoundationPile.
    //       final dropPosition = (dropPiles.first as FoundationPile).position;
    //       doMove(
    //         dropPosition,
    //         onComplete: () {
    //           dropPiles.first.acquireCard(this);
    //         },
    //       );
    //     }
    //     return;
    //   }
    // }

    // Invalid drop (middle of nowhere, invalid pile or invalid card for pile).
    // doMove(
    //   _whereCardStarted,
    //   onComplete: () {
    //     cardHolder!.returnCard(this);
    //   },
    // );
    // if (attachedCards.isNotEmpty) {
    //   attachedCards.forEach((card) {
    //     final offset = card.position - position;
    //     card.doMove(
    //       _whereCardStarted + offset,
    //       onComplete: () {
    //         cardHolder!.returnCard(card);
    //       },
    //     );
    //   });
    //   attachedCards.clear();
    // }
  }

  //#endregion

  //#region Card-Tapping

  // Tap a face-up card to make it auto-move and go out (if acceptable), but
  // if it is face-down and on the Stock Pile, pass the event to that pile.

  @override
  void onTapUp(TapUpEvent event) {
    handleTapUp();
  }

  void handleTapUp() {
    // Can be called by onTapUp or after a very short (failed) drag-and-drop.
    // We need to be more user-friendly towards taps that include a short drag.
    // if (cardHolder?.canMoveCard(this, MoveMethod.tap) ?? false) {
    //   final suitIndex = _race.value;
    //   if (world.foundations[suitIndex].canAcceptCard(this)) {
    //     cardHolder!.removeCard(this, MoveMethod.tap);
    //     doMove(
    //       world.foundations[suitIndex].position,
    //       onComplete: () {
    //         world.foundations[suitIndex].acquireCard(this);
    //       },
    //     );
    //   }
    // } else if (cardHolder is StockPile) {
    //   world.stock.handleTapUp(this);
    // }
  }

  //#endRegion

  //#region Effects

  void doMove(
    Vector2 to, {
    double speed = 10.0,
    double start = 0.0,
    int startPriority = 100,
    Curve curve = Curves.easeOutQuad,
    VoidCallback? onComplete,
  }) {
    assert(speed > 0.0, 'Speed must be > 0 widths per second');
    final dt = (to - position).length / (speed * size.x);
    assert(dt > 0, 'Distance to move must be > 0');
    add(
      CardMoveEffect(
        to,
        EffectController(duration: dt, startDelay: start, curve: curve),
        transitPriority: startPriority,
        onComplete: () {
          onComplete?.call();
        },
      ),
    );
  }

  void doMoveAndFlip(
    Vector2 to, {
    double speed = 10.0,
    double start = 0.0,
    Curve curve = Curves.easeOutQuad,
    VoidCallback? whenDone,
  }) {
    assert(speed > 0.0, 'Speed must be > 0 widths per second');
    final dt = (to - position).length / (speed * size.x);
    assert(dt > 0, 'Distance to move must be > 0');
    priority = 100;
    add(
      MoveToEffect(
        to,
        EffectController(duration: dt, startDelay: start, curve: curve),
        onComplete: () {
          // turnFaceUp(
          //   onComplete: whenDone,
          // );
        },
      ),
    );
  }

  //#endregion
}

class CardMoveEffect extends MoveToEffect {
  CardMoveEffect(
    super.destination,
    super.controller, {
    super.onComplete,
    this.transitPriority = 100,
  });

  final int transitPriority;

  @override
  void onStart() {
    super.onStart(); // Flame connects MoveToEffect to EffectController.
    parent?.priority = transitPriority;
  }
}
