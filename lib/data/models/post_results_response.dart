class PostResultResponse {
  bool error;
  String message;
  List<Data>? data;

  PostResultResponse({
    required this.error,
    required this.message,
    this.data,
  });

  factory PostResultResponse.fromMap(Map<String, dynamic> json) =>
      PostResultResponse(
        error: json["error"],
        message: json["message"],
        data: List<Data>.from((json["data"] as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .map((x) => Data.fromMap(x))),
      );
}

class Data {
  String id;
  bool correct;

  Data({
    required this.id,
    required this.correct,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        correct: json["correct"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "correct": correct,
      };
}
