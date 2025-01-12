import 'package:battlerounds/components/game_card.dart';
import 'package:battlerounds/components/hero_card.dart';
import 'package:battlerounds/models/hero_power.dart';

class InspirePower implements HeroPower {
  @override
  void execute(HeroCard card, {List<GameCard>? target}) {
    print('${card.name} triggers Inspire!');
    // TODO Implement logic for "Inspire" hero power.
  }

  @override
  String toJson() => "InspirePower";
}

class BloodlustPower implements HeroPower {
  @override
  void execute(HeroCard card, {List<GameCard>? target}) {
    print('${card.name} triggers Bloodlust!');
    // TODO Implement logic for "Bloodlust" hero power.
  }

  @override
  String toJson() => "BloodlustPower";
}
