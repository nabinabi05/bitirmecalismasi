import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/inference_result.dart';

class InferenceService {
  // Cloud Run servis adresi. Yerel test için --dart-define=MODEL_API_URL=http://...
  // ile override edilebilir; aksi halde production Cloud Run adresi kullanılır.
  static const String _apiUrlFromEnv = String.fromEnvironment(
    'MODEL_API_URL',
    defaultValue: 'https://plant-api-gateway-243711871542.europe-west1.run.app',
  );

  String get _baseUrl => _apiUrlFromEnv;

  Future<InferenceResult> predictFromImage(String imagePath) async {
    final uri = Uri.parse('$_baseUrl/predict');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', imagePath));

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 120),
    );

    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200) {
      throw Exception(
        'Tahmin servisi hatası (${streamedResponse.statusCode}): $responseBody',
      );
    }

    final Map<String, dynamic> json =
        jsonDecode(responseBody) as Map<String, dynamic>;
    return InferenceResult.fromJson(json);
  }
}
