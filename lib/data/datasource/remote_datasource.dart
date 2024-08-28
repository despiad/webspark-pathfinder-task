import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:webspark_task/data/models/get_data_response.dart';
import 'package:webspark_task/data/models/post_result_payload.dart';
import 'package:webspark_task/data/models/post_results_response.dart';

final class RemoteDatasource {
  Future<GetDataResponse> getData(String url) async {
    log('Making GET request to $url');
    final rawResponse = await http.get(Uri.parse(url));
    if (rawResponse.statusCode == HttpStatus.methodNotAllowed) {
      throw Exception("Method GET not allowed");
    }
    log('Got response ${rawResponse.body}');
    final decoded = jsonDecode(rawResponse.body);
    return GetDataResponse.fromMap(decoded);
  }

  Future<String> checkUrlAllowedMethods(String url) async {
    final client = http.Client();
    const method = 'OPTIONS';
    final uri = Uri.parse(url);
    final request = http.Request(method, uri);
    log('Making OPTIONS request to $url');
    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    log('Got response ${response.body}');
    if (response.statusCode != HttpStatus.ok) {
      throw Exception("Could not get allowed methods");
    }
    return response.body;
  }

  Future<PostResultResponse> sendResults(
    String url,
    List<PostResultPayload> results,
  ) async {
    log('Making POST request to $url');
    final encoded = jsonEncode(results);
    log(encoded);
    final rawResponse = await http.post(Uri.parse(url), body: encoded);
    if (rawResponse.statusCode == HttpStatus.methodNotAllowed) {
      throw Exception("Method POST not allowed");
    }
    log('Got response ${rawResponse.body}');
    final decoded = jsonDecode(rawResponse.body);
    return PostResultResponse.fromMap(decoded);
  }
}
