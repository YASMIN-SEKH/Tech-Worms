import 'package:http/http.dart' as http;
import 'dart:convert';

// Define the API key here
const String ambeeApiKey = 'e0c0f6c784b732e42cd47ff1faeceb6c3193ba2da273f4d5772997ff5cc6d30c'; // Replace with your actual API key

class PollenApi {
  static Future<PollenData> fetchPollenData(String lat, String lon) async {
    final url = 'https://api.getambee.com/pollen/v1/current/by-lat-lng?lat=$lat&lon=$lon&api_key=$ambeeApiKey';
    final response = await http.get(Uri. parse(url));

    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);

        // Check if the required fields are present
        if (jsonData.containsKey('pollen_count') && jsonData.containsKey('pollen_type')) {
          return PollenData.fromJson(jsonData);
        } else {
          throw Exception('Invalid JSON structure');
        }
      } catch (e) {
        throw Exception('Failed to parse JSON data: $e');
      }
    } else {
      throw Exception('Failed to load pollen data: ${response.statusCode}');
    }
  }
}

class PollenData {
  final int pollenCount;
  final String pollenType;

  PollenData({required this.pollenCount, required this.pollenType});

  factory PollenData.fromJson(Map<String, dynamic> json) {
    // Add default values or handle null cases
    return PollenData(
      pollenCount: json['pollen_count'] ?? 0,  // Default to 0 if the field is not present
      pollenType: json['pollen_type'] ?? 'Unknown',  // Default to 'Unknown' if the field is not present
    );
  }
}
