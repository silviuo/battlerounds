import 'dart:ui';

import 'package:flame/game.dart';

import 'package:battlerounds/battlerounds_world.dart';
import 'package:battlerounds/enums/game_stage.dart';

class BattleroundsGame extends FlameGame<BattleroundsWorld> {
  static const double cardGap = 20.0;
  static const double topGap = 20.0;
  static const double cardHeight = 100.0;
  static const double cardWidth = 100.0;
  static const double cardRadius = 20.0;
  static const double cardSpaceWidth = cardWidth + cardGap;
  static const double cardSpaceHeight = cardHeight + cardGap;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);
  static final cardRRect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(0, 0, cardWidth, cardHeight),
    const Radius.circular(cardRadius),
  );
  static final Map<int, int> cardCopiesPerTier = {
    1: 16,
    2: 15,
    3: 13,
    4: 11,
    5: 9,
    6: 7,
  };

  GameStage currentStage = GameStage.mainMenu;

  // TODO Move to player objects.
  int player1Health = 30;
  int player2Health = 30;

  /// Constant used to decide when a short drag is treated as a TapUp event.
  static const double dragTolerance = cardWidth / 5;

  /// Constant used when creating Random seed.
  static const int maxInt = 0xFFFFFFFE; // = (2 to the power 32) - 1
  // This BattleroundsGame constructor also initiates the first BattleroundsWorld.
  BattleroundsGame() : super(world: BattleroundsWorld());

  void initializeGame() {
    world = BattleroundsWorld();
  }

  Future<void> startGame() async {
    currentStage = GameStage.recruitingPlayer1;
    overlays.remove('MainMenu');
  }

  void playerReady() {
    if (currentStage == GameStage.recruitingPlayer1) {
      currentStage = GameStage.recruitingPlayer2;
      world.initializeRecruitingPhase();
    } else if (currentStage == GameStage.recruitingPlayer2) {
      currentStage = GameStage.combat;
      world.initializeCombatPhase();
      handleCombatPhase();
    }
  }

  void handleCombatPhase() {
    // Simulate combat and determine outcomes.
    world.simulateCombat();
    if (player1Health <= 0 || player2Health <= 0) {
      currentStage = GameStage.gameOver;
      overlays.add('GameOver');
    } else {
      currentStage = GameStage.recruitingPlayer1;
      world.initializeRecruitingPhase();
    }
  }

  void reset() {
    player1Health = 30;
    player2Health = 30;
    currentStage = GameStage.mainMenu;
    initializeGame();
    overlays.add('MainMenu');
  }

  void endGame() {
    overlays.add('GameOver');
  }
}
