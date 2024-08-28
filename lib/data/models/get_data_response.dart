
import '../../domain/models/cell.dart';

final class GetDataResponse {
  final bool error;
  final String message;
  final List<RemoteData> data;

  const GetDataResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory GetDataResponse.fromMap(Map<String, dynamic> map) {
    return GetDataResponse(
      error: map['error'] as bool,
      message: map['message'] as String,
      data: (map['data'] as List<dynamic>).cast<Map<String, dynamic>>().map(
        (e) {
          return RemoteData.fromMap(e);
        },
      ).toList(),
    );
  }
}

final class RemoteData {
  final String id;
  final List<String> field;
  final Cell start;
  final Cell end;

  RemoteData({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  factory RemoteData.fromMap(Map<String, dynamic> map) {
    return RemoteData(
      id: map['id'] as String,
      field: (map['field'] as List<dynamic>).cast<String>(),
      start: Cell.fromJson(map['start'] as Map<String, dynamic>),
      end: Cell.fromJson(map['end'] as Map<String, dynamic>),
    );
  }
}


