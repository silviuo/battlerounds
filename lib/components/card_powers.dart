import 'package:battlerounds/components/card_power.dart';
import 'package:battlerounds/components/game_card.dart';

class DivineShieldPower implements CardPower {
  @override
  void execute(GameCard card, {GameCard? target}) {
    print('${card.name} gains Divine Shield!');
    // Implement logic to add a "Divine Shield" status to the card.
  }

  @override
  String toJson() => "DivineShieldPower";
}

class TauntPower implements CardPower {
  @override
  void execute(GameCard card, {GameCard? target}) {
    print('${card.name} gains Taunt!');
    // Implement logic to add a "Taunt" status to the card.
  }

  @override
  String toJson() => "TauntPower";
}

class DeathrattlePower implements CardPower {
  @override
  void execute(GameCard card, {GameCard? target}) {
    print('${card.name} triggers its Deathrattle!');
    // Implement logic to trigger the card's Deathrattle effect.
  }

  @override
  String toJson() => "DeathrattlePower";
}

class BattlecryPower implements CardPower {
  @override
  void execute(GameCard card, {GameCard? target}) {
    print('${card.name} triggers its Battlecry!');
    // Implement logic to trigger the card's Battlecry effect.
  }

  @override
  String toJson() => "BattlecryPower";
}

class RebornPower implements CardPower {
  @override
  void execute(GameCard card, {GameCard? target}) {
    print('${card.name} gains Reborn!');
    // Implement logic to add a "Reborn" status to the card.
  }

  @override
  String toJson() => "RebornPower";
}
