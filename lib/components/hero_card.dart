import 'dart:ui';

import 'package:battlerounds/battlerounds_game.dart';
import 'package:battlerounds/battlerounds_world.dart';
import 'package:battlerounds/components/hero_powers.dart';
import 'package:battlerounds/models/card_holder.dart';
import 'package:battlerounds/models/hero_power.dart';
import 'package:battlerounds/models/race.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';

class HeroCard extends PositionComponent
    with
        TapCallbacks,
        HasWorldReference<BattleroundsWorld>,
        HasGameReference<BattleroundsGame> {
  final String name;
  final Race race;
  final HeroPower heroPower;
  final String heroPowerDescription;
  String spritePath;

  CardHolder? cardHolder;

  late final Sprite cardPortrait;

  HeroCard({
    required this.name,
    required this.race,
    required this.heroPower,
    required this.heroPowerDescription,
    required this.spritePath,
  }) : super(
          size: BattleroundsGame.cardSize,
        );

  //#region Serialization

  /// Converts the HeroCard object to JSON.
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "race": race,
      "heroPower": heroPower,
      "heroPowerDescription": heroPowerDescription,
      "spritePath": spritePath,
    };
  }

  /// Factory method to create a HeroCard from JSON.
  factory HeroCard.fromJson(Map<String, dynamic> json) {
    return HeroCard(
      name: json["name"],
      race: _raceFromJson(json["race"]),
      heroPower: _powerFromJson(json["heroPower"]),
      heroPowerDescription: json["heroPowerDescription"],
      spritePath: json["spritePath"],
    );
  }

  /// Helper method to convert the "race" field to the Race enum
  static Race _raceFromJson(String race) {
    switch (race.toLowerCase()) {
      case 'human':
        return Race.human;
      case 'goblin':
        return Race.goblin;
      default:
        throw Exception('Unknown race: $race');
    }
  }

  /// Helper method to deserialize powers.
  static HeroPower _powerFromJson(String powerName) {
    switch (powerName) {
      case "Inspire":
        return InspirePower();
      case "Bloodlust":
        return BloodlustPower();
      default:
        throw Exception("Unknown power: $powerName");
    }
  }

  @override
  String toString() {
    return '''
    $name (Race: ${race.name})
    Power: $heroPower
    Description: $heroPowerDescription
    Sprite Path: $spritePath
    ''';
  }

  //#endregion

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await Flame.images.load(spritePath);

    cardPortrait = loadCardPortrait(spritePath);
  }

  //#region Rendering

  @override
  void render(Canvas canvas) {
    _renderCard(canvas);
  }

  Sprite loadSprite(
      String spritePath, double x, double y, double width, double height) {
    return Sprite(
      game.images.fromCache(spritePath),
      srcPosition: Vector2(x, y),
      srcSize: Vector2(width, height),
    );
  }

  static final Paint backBackgroundPaint = Paint()
    ..color = const Color(0xff380c02);
  static final Paint backBorderPaint1 = Paint()
    ..color = const Color(0xffdbaf58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final Paint backBorderPaint2 = Paint()
    ..color = const Color(0x5CEF971B)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final RRect cardRRect = RRect.fromRectAndRadius(
    BattleroundsGame.cardSize.toRect(),
    const Radius.circular(BattleroundsGame.cardRadius),
  );
  // static final RRect backRRectInner = cardRRect.deflate(40);

  static Sprite loadCardPortrait(String spritePath) {
    return Sprite(
      Flame.images.fromCache(spritePath),
      srcSize: Vector2(1024, 1024),
    );
  }

  void _renderCard(Canvas canvas) {
    // Save canvas state
    canvas.save();

    // Draw background
    canvas.drawRRect(cardRRect, backBackgroundPaint);

    // Clip with rounded corners
    canvas.clipRRect(cardRRect);

    // Draw sprite
    cardPortrait.render(canvas, size: size);

    // Restore canvas to remove clipping
    canvas.restore();

    // Draw border on top
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

  //#endregion

  //#region Card-Tapping

  // Tap a card to show hero information.

  @override
  void onTapCancel(TapCancelEvent event) {
    // TODO hide card details on tap cancel
  }

  @override
  void onTapUp(TapUpEvent event) {
    handleTapUp();
  }

  void handleTapUp() {
    // TODO show card details on tap
  }

  //#endRegion
}
