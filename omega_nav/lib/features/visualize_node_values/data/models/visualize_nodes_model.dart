import 'package:equatable/equatable.dart';

class VisualizeNodesModel extends Equatable {
  final DateTime startTime;
  final DateTime endTime;
  final List<List<double>> nodeSpeedValues;

  const VisualizeNodesModel(
      {required this.startTime,
      required this.endTime,
      required this.nodeSpeedValues});

  @override
  List<Object?> get props => [startTime, endTime, nodeSpeedValues];

  factory VisualizeNodesModel.fromJson(Map<String, dynamic> json) {
    return VisualizeNodesModel(
        startTime: json["startTime"],
        endTime: json["endTime"],
        nodeSpeedValues: json["nodeSpeedValues"]);
  }
}
