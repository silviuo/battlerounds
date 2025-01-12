import 'package:battlerounds/components/game_card.dart';
import 'package:battlerounds/components/hero_card.dart';

abstract class HeroPower {
  /// Executes the hero's power, which could modify stats or interact with other cards.
  void execute(HeroCard card, {List<GameCard>? target});

  /// Converts the power to a JSON-compatible string representation.
  String toJson();
}
