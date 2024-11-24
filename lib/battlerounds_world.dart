import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'package:battlerounds/battlerounds_game.dart';
import 'package:battlerounds/components/card.dart';
import 'package:battlerounds/components/flat_button.dart';
import 'package:battlerounds/enums/action.dart';

class BattleroundsWorld extends World with HasGameReference<BattleroundsGame> {
  final cardGap = BattleroundsGame.cardGap;
  final topGap = BattleroundsGame.topGap;
  final cardSpaceWidth = BattleroundsGame.cardSpaceWidth;
  final cardSpaceHeight = BattleroundsGame.cardSpaceHeight;

  // final topHeroCardHolder = CardHolder(position: Vector2(0.0, 0.0));
  // final bottomHeroCardHolder= = CardHolder(position: Vector2(0.0, 0.0));
  // final List<BottomCardHolder> bottomCardHolders = [];
  // final List<TopCardHolder> topCardHolders = [];
  final List<MinionCard> cardsPool = [];
  late Vector2 playAreaSize;

  late TextComponent gamePhaseText;
  late TextComponent playerHealthText;

  @override
  Future<void> onLoad() async {
    await Flame.images.load('board_background.png');

    // TODO Remove test placeholders
    gamePhaseText = TextComponent(
      text: 'Phase: Main Menu',
      position: Vector2(-120, -200),
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 24, color: Colors.white) as TextStyle?,
      ),
    );
    add(gamePhaseText);

    playerHealthText = TextComponent(
      text: 'P1: 30 HP | P2: 30 HP',
      position: Vector2(-120, -100),
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
    add(playerHealthText);

    addButton('Ready', -120, 0, ActionType.endRound);
    addButton('End Game', 120, 0, ActionType.endGame);
  }

  void addButton(
      String label, double buttonX, double buttonY, ActionType action) {
    final button = FlatButton(
      label,
      size: Vector2(100, 50),
      position: Vector2(buttonX, buttonY),
      onReleased: () {
        executeAction(action);
      },
    );
    add(button);
  }

  void executeAction(ActionType action) {
    switch (action) {
      case ActionType.endRound:
        game.playerReady();
        break;
      case ActionType.endGame:
        game.endGame();
        break;
      default:
        break;
    }
  }

  void initializeRecruitingPhase({required int player}) {
    // Setup for the recruiting phase for the given player.
    clearCards();
    if (player == 1) {
      // Show cards for player 1.
    } else {
      // Show cards for player 2.
    }
  }

  void initializeCombatPhase() {
    // Setup for the combat phase.
    clearCards();
    // Prepare the board for auto-battle.
  }

  void simulateCombat() {
    // Perform combat logic, modify player health.
    game.player1Health -= 10; // Example damage.
    game.player2Health -= 8; // Example damage.
  }

  void clearCards() {
    // Clear any card components from the board.
    removeAll(children.whereType<MinionCard>());
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

  @override
  void update(double dt) {
    super.update(dt);

    // Update game phase and health dynamically
    gamePhaseText.text = 'Phase: ${game.currentStage.name}';
    playerHealthText.text =
        'P1: ${game.player1Health} HP | P2: ${game.player2Health} HP';
  }
}
