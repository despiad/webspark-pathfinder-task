final class Cell {
  final int x;
  final int y;
  final bool blocked;

  Cell({
    required this.x,
    required this.y,
    this.blocked = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cell &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          blocked == other.blocked;

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ blocked.hashCode;

  Cell copyWith({
    int? x,
    int? y,
    bool? blocked,
  }) {
    return Cell(
      x: x ?? this.x,
      y: y ?? this.y,
      blocked: blocked ?? this.blocked,
    );
  }

  factory Cell.fromJson(Map<String, dynamic> json) => Cell(
    x: json["x"],
    y: json["y"],
    blocked: json["blocked"] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    "x": x,
    "y": y,
    "blocked": blocked,
  };

  @override
  String toString() {
    return 'Cell {x: $x, y: $y, blocked: $blocked}';
  }
}
