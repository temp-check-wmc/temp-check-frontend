class SensorData {

  late DateTime dateTime;
  late double temperature;  //Celsius
  late double humdity;      // % in gramm/m3 air
  late double pressure;     // Milibars

  SensorData({required this.dateTime, required this.temperature, required this.humdity, required this.pressure});

  factory SensorData.fromJSON(Map<String, dynamic> json, DateTime time) {
    return SensorData(
        dateTime: time,
        temperature: json['temperature'],
        humdity: json['humidity'],
        pressure: json['pressure']);
  }

  @override
  bool operator ==(Object other) {
    var data = other as SensorData;
    return data.dateTime == dateTime;
  }

  @override
  int get hashCode => dateTime.hashCode;

}