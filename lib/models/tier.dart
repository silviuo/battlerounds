class Tier {
  final int value;

  Tier._(this.value);

  // Factory constructor to enforce validation
  factory Tier(int value) {
    if (value < 1 || value > 6) {
      throw ArgumentError('Tier value must be between 1 and 6.');
    }
    return Tier._(value);
  }

  @override
  String toString() => 'Tier $value';
}
