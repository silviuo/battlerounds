import 'package:battlerounds/components/game_card.dart';

abstract class CardPower {
  /// Executes the card's power, which could modify stats or interact with other cards.
  void execute(GameCard card, {GameCard? target});

  /// Converts the power to a JSON-compatible string representation.
  String toJson();
}
