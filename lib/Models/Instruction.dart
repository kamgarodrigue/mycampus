class Instruction {
  double distance, heading;
  List interval;
  List point;
  String text, street_name;
  int sign, time;
  Instruction(
      {this.distance,
      this.heading,
      this.interval,
      this.sign,
      this.street_name,
      this.text,
      this.point,
      this.time});
  factory Instruction.fromJson(Map<String, dynamic> json) => Instruction(
      distance: json['distance'],
      point: [],
      heading: json['heading'],
      interval: json['interval'],
      sign: json['sign'],
      street_name: json['street_name'],
      text: json['text'],
      time: json['time']);
  Map<String, dynamic> toJson() => {
        "distance": 39.744,
        "heading": 81.33,
        "sign": 0,
        "interval": [0, 1],
        "text": "Continue",
        "time": 23846,
        "street_name": ""
      };
}
