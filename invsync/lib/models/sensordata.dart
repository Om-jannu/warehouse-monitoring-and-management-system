// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SensorData {
  final String timestamp;
  final double temperature;
  final int humidity;
  final int co2Level;

  SensorData({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    required this.co2Level,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timestamp': timestamp,
      'temperature': temperature,
      'humidity': humidity,
      'co2Level': co2Level,
    };
  }

  factory SensorData.fromMap(Map<String, dynamic> map) {
    return SensorData(
      timestamp: map['timestamp'] as String,
      temperature: map['temperature'] as double,
      humidity: map['humidity'] as int,
      co2Level: map['co2Level'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SensorData.fromJson(String source) =>
      SensorData.fromMap(json.decode(source) as Map<String, dynamic>);
}
