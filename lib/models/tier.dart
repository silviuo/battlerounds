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

  // Base cost mapping for each tier
  static const Map<int, int> _baseCosts = {
    2: 5,
    3: 7,
    4: 8,
    5: 11,
    6: 10,
  };

  // Method to get the base cost
  int get baseCost {
    if (value == 1) {
      throw StateError('Tier 1 does not have a base cost.');
    }
    return _baseCosts[value] ?? 0; // Default to 0 if no mapping exists
  }

  @override
  String toString() =>
      'Tier $value (Base Cost: ${value > 1 ? baseCost : 'N/A'})';
}
