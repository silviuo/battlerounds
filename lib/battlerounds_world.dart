import 'dart:convert';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:battlerounds/battlerounds_game.dart';
import 'package:battlerounds/components/flat_button.dart';
import 'package:battlerounds/components/game_card.dart';
import 'package:battlerounds/components/hero_card_holder.dart';
import 'package:battlerounds/components/minion_card_holder.dart';
import 'package:battlerounds/enums/action.dart';
import 'package:battlerounds/enums/game_stage.dart';

class BattleroundsWorld extends World with HasGameReference<BattleroundsGame> {
  final cardGap = BattleroundsGame.cardGap;
  final topGap = BattleroundsGame.topGap;
  final cardSpaceWidth = BattleroundsGame.cardSpaceWidth;
  final cardSpaceHeight = BattleroundsGame.cardSpaceHeight;

  final topHeroCardHolder = HeroCardHolder(position: Vector2(0.0, 0.0));
  final bottomHeroCardHolder = HeroCardHolder(position: Vector2(0.0, 0.0));
  final List<MinionCardHolder> bottomCardHolders = [];
  final List<MinionCardHolder> topCardHolders = [];
  final List<GameCard> cardsPool = [];
  final List<GameCard> p1Minions = [];
  final List<GameCard> p2Minions = [];
  late Vector2 playAreaSize;

  late TextComponent gamePhaseText;
  late TextComponent playerHealthText;

  @override
  Future<void> onLoad() async {
    await Flame.images.loadAll([
      'board_background.png',
      'hourglass.png',
      'coin.png',
      'frame_blue.png',
      'frame_green.png',
      'minions/ebenezer_snowsnatch.png',
      'minions/gobbler_greedgift.png',
      'minions/grinchy_grouchsnatch.png',
      'minions/grumble_gravygnaw.png',
      'minions/holly_hugsalot.png',
      'minions/kris_krinklewink.png',
      'minions/peppermint_prancer.png',
      'minions/pukey_pineclaw.png',
      'minions/sludge_stocking-snatcher.png',
      'minions/sugarplum_sprinklewood.png',
      'heroes/human_queen.png',
      'heroes/human_tavern_keeper.png',
      'heroes/goblin_king.png',
      'heroes/goblin_tavern_keeper.png',
    ]);

    for (var i = 0; i < 7; i++) {
      var position =
          Vector2(i * cardSpaceWidth + cardGap, topGap + cardSpaceHeight);
      topCardHolders.add(
        MinionCardHolder(position: position),
      );
      position = Vector2(
          i * cardSpaceWidth + cardGap, topGap * 2 + cardSpaceHeight * 2);
      bottomCardHolders.add(
        MinionCardHolder(position: position),
      );
    }

    await initializeCardPool();
    addAll(cardsPool);

    addAll(topCardHolders);
    addAll(bottomCardHolders);

    playAreaSize = Vector2(
        7 * cardSpaceWidth + 2 * cardGap, 4 * cardSpaceHeight + 2 * topGap);
    final gameMidX = playAreaSize.x / 2;
    final gameMidY = playAreaSize.y / 2;

    final camera = game.camera;
    camera.viewfinder.visibleGameSize = playAreaSize;
    camera.viewfinder.position = Vector2(gameMidX, 0);
    camera.viewfinder.anchor = Anchor.topCenter;
  }

  void addButton(
      String label, double buttonX, double buttonY, ActionType action) {
    final button = FlatButton(
      label,
      size: Vector2(75, 25),
      position: Vector2(buttonX, buttonY),
      onReleased: () {
        executeAction(action);
      },
    );
    add(button);
  }

  void addCard(GameCard card, double x, double y) {
    card.position = Vector2(x, y);
    add(card);
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

  Future<void> initializeCardPool() async {
    final String jsonString =
        await rootBundle.loadString('assets/json/minions.json');
    final List<Map<String, dynamic>> cardDataList =
        List<Map<String, dynamic>>.from(jsonDecode(jsonString));

    // Initialize the card pool with all available cards.
    for (var cardData in cardDataList) {
      // Create a GameCard from the JSON data
      GameCard gameCard = GameCard.fromJson(cardData);
      // gameCard.position = Vector2(-150.0, 0.0);
      gameCard.position = Vector2(0.0, 0.0);

      // Add the appropriate number of copies based on the card's tier
      int copies = BattleroundsGame.cardCopiesPerTier[gameCard.tier.value] ?? 0;
      for (int i = 0; i < copies; i++) {
        // Create a new instance for each copy
        GameCard cardCopy = GameCard(
          name: gameCard.name,
          tier: gameCard.tier,
          race: gameCard.race,
          baseAttack: gameCard.baseAttack,
          baseHealth: gameCard.baseHealth,
          basePowers: List.from(gameCard.basePowers),
          basePowerDescriptions: List.from(gameCard.basePowerDescriptions),
          spritePath: gameCard.spritePath,
        );
        cardCopy.position = Vector2(0.0, 0.0);
        cardsPool.add(cardCopy);
      }
      print('Cards left in pool: ${cardsPool.length}');
    }

    cardsPool.shuffle(Random(Random().nextInt(BattleroundsGame.maxInt)));
  }

  Future<void> initializeRecruitingPhase() async {
    // Setup for the recruiting phase for the given player.

    addButton('Ready', playAreaSize.x - 190, 20, ActionType.endRound);
    addButton('End Game', playAreaSize.x - 110, 20, ActionType.endGame);
    dealCards();
  }

  void endRecruitingPhase() {
    // Clean up after the recruiting phase.
    if (game.currentStage == GameStage.recruitingPlayer1) {
      p1Minions.clear();
    }
    if (game.currentStage == GameStage.recruitingPlayer2) {
      p2Minions.clear();
    }

    // Add the player's minions to the player's minion list.
    for (final cardHolder in bottomCardHolders) {
      final card = cardHolder.heldCard;
      if (card != null) {
        addCardToPlayerMinionList(card);
      }
    }
    print('Player 1 minions: ${p1Minions.map((e) => e.name).toList()}');
    print('Player 2 minions: ${p2Minions.map((e) => e.name).toList()}');

    clearCards();
  }

  void dealCards() {
    for (final card in cardsPool) {
      card.priority = 1;
    }

    if (game.currentStage == GameStage.recruitingPlayer1) {
      dealCardsToPlayer(1);
    } else if (game.currentStage == GameStage.recruitingPlayer2) {
      dealCardsToPlayer(2);
    } else {
      dealCardsForCombat();
    }
  }

  void dealCardsToPlayer(int player) {
    // If dealing cards to a player, the top card holders are for tavern minions,
    // and the bottom card holders are for the player's minions.
    // Deal 7 cards to the top card holders from the card pool.
    print("---Dealing cards to player $player---");
    for (var i = 0; i < 7; i++) {
      final card = cardsPool.removeLast();
      print("Setting card to top holder: ${card.name} at index $i");
      topCardHolders[i].acquireCard(card);
    }
    print('Cards left in pool: ${cardsPool.length}');
    // Deal the player's cards to the bottom card holders.
    final playerMinions = player == 1 ? p1Minions : p2Minions;
    for (var i = 0; i < playerMinions.length; i++) {
      final card = playerMinions[i];
      print("Setting card to bottom holder: ${card.name} at index $i");
      card.position = bottomCardHolders[i].position;
      add(card);
      bottomCardHolders[i].acquireCard(card);
    }
  }

  void dealCardsForCombat() {
    print("---Dealing cards for combat---");
    // Deal 7 cards to the top card holder from the p2Minions.
    for (var i = 0; i < p2Minions.length; i++) {
      final card = p2Minions[i];
      print("Setting card to top holder: ${card.name} at index $i");
      card.position = topCardHolders[i].position;
      add(card);
      topCardHolders[i].acquireCard(card);
    }
    // Deal 7 cards to the bottom card holder from the p1Minions.
    for (var i = 0; i < p1Minions.length; i++) {
      final card = p1Minions[i];
      print("Setting card to bottom holder: ${card.name} at index $i");
      card.position = bottomCardHolders[i].position;
      add(card);
      bottomCardHolders[i].acquireCard(card);
    }
  }

  void addCardToPlayerMinionList(GameCard card) {
    if (game.currentStage == GameStage.recruitingPlayer1) {
      p1Minions.add(card);
      print("Added card to player 1's minions: ${card.name}");
    } else if (game.currentStage == GameStage.recruitingPlayer2) {
      p2Minions.add(card);
      print("Added card to player 2's minions: ${card.name}");
    }
  }

  Future<void> initializeCombatPhase() async {
    // Setup for the combat phase.
    // Create and add the combat phase text
    final combatText = TextComponent(
      text: 'Combat Phase',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 26.0,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    )
      ..position =
          Vector2(playAreaSize.x / 2, playAreaSize.y / 2) // Center of screen
      ..anchor = Anchor.center; // Center the text around its position

    add(combatText);

    // Remove the text after 2 seconds
    await Future.delayed(const Duration(seconds: 2), () {
      combatText.removeFromParent();
    });
    // TODO Implement auto-battle.
  }

  Future<void> endCombatPhase() async {}

  void simulateCombat() {
    // Perform combat logic, modify player health.
    game.player1Health -= 10; // Example damage.
    print('Player 1 health: ${game.player1Health}');
    game.player2Health -= 8; // Example damage.
    print('Player 2 health: ${game.player2Health}');
  }

  void clearCards() {
    // Clear any card components from the board.
    // removeAll(children.whereType<GameCard>());
    // removeAll(cardsPool);

    // Remove cards from top holders
    for (var holder in topCardHolders) {
      if (holder.heldCard != null) {
        holder.heldCard!.removeFromParent();
        holder.heldCard = null;
      }
    }

    // Remove cards from bottom holders
    for (var holder in bottomCardHolders) {
      if (holder.heldCard != null) {
        holder.heldCard!.removeFromParent();
        holder.heldCard = null;
      }
    }
  }

  // draw the background image
  @override
  void render(Canvas canvas) {
    Sprite sprite = Sprite(Flame.images.fromCache('board_background.png'));
    sprite.render(canvas, size: Vector2(playAreaSize.x, playAreaSize.y));
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
