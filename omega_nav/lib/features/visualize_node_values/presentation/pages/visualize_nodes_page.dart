import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omega_nav/features/get_node_locations/presentation/manager/get_node_locations_bloc.dart';
import 'package:omega_nav/features/visualize_node_values/presentation/manager/visualize_node_values_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../injection_container.dart';

class VisualizeNodesPage extends StatefulWidget {
  final int numberOfNodes;
  final String selectedModel;
  const VisualizeNodesPage(
      {Key? key, required this.numberOfNodes, required this.selectedModel})
      : super(key: key);

  @override
  State<VisualizeNodesPage> createState() => _VisualizeNodesPageState();
}

class _VisualizeNodesPageState extends State<VisualizeNodesPage> {
  int nodeNumber = 0;
  int cycleCount = 10;

  List<_ChartData> chartData = <_ChartData>[];

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2525),
        title: const Text(
          "Node Visualization",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFF2A2525),
      body: BlocProvider<VisualizeNodeValuesBloc>(
        create: (context) => sl<VisualizeNodeValuesBloc>()
          ..add(LoadVisualizeNodeValuesEvent(
              cycles: cycleCount, modelName: widget.selectedModel)),
        child: BlocBuilder<VisualizeNodeValuesBloc, VisualizeNodeValuesState>(
          builder: (context, state) {
            if (state is VisualizeNodeValuesLoaded) {
              List<double> nodeValueList =
                  state.visualizeNodesModel.nodeSpeedValues[nodeNumber];
              chartData = [];
              for (int i = 0; i < nodeValueList.length; i++) {
                chartData.add(_ChartData((i + 1) * 15, nodeValueList[i]));
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 15.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              gradient: RadialGradient(colors: [
                            const Color(0xFFABBAB8),
                            const Color(0xFFABBAB8).withOpacity(0.0)
                          ], radius: w * .5)),
                          height: 1,
                          width: w,
                        ),
                        SizedBox(
                          height: h * .1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Cycles: ",
                                    style: TextStyle(
                                        color: Color(0xFFFFFFFF), fontSize: 16),
                                  ),
                                  IconButton(
                                      onPressed: (cycleCount <= 10)
                                          ? null
                                          : () => modifyCycleCount(-10),
                                      icon: Icon(
                                        Icons.keyboard_arrow_left,
                                        size: 24,
                                        color: (cycleCount <= 10)
                                            ? const Color(0xFF393535)
                                            : const Color(0xFFFFFFFF),
                                      )),
                                  SizedBox.fromSize(
                                    size: const Size.fromWidth(36),
                                    child: Center(
                                        child: Text(
                                          "$cycleCount",
                                          style: const TextStyle(
                                              color: Color(0xFF00EAFF),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        )),
                                  ),
                                  IconButton(
                                      onPressed: (cycleCount > 200)
                                          ? null
                                          : () => modifyCycleCount(10),
                                      icon: Icon(
                                        Icons.keyboard_arrow_right,
                                        size: 24,
                                        color: (cycleCount > 200)
                                            ? const Color(0xFF393535)
                                            : const Color(0xFFFFFFFF),
                                      )),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    enableFeedback: false,
                                    backgroundColor: const Color(0xFF2A2525),
                                    side: const BorderSide(
                                        color: Color(0xFFFFFFFF)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 36.0),
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(40))),
                                onPressed: () {
                                  BlocProvider.of<VisualizeNodeValuesBloc>(
                                      context)
                                      .add(LoadVisualizeNodeValuesEvent(
                                      cycles: cycleCount,
                                      modelName: widget.selectedModel));
                                },
                                child: const Text(
                                  "Refresh",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF00EAFF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              gradient: RadialGradient(colors: [
                                const Color(0xFFABBAB8),
                                const Color(0xFFABBAB8).withOpacity(0.0)
                              ], radius: w * .5)),
                          height: 1,
                          width: w,
                        ),
                        SizedBox(
                          height: h * .1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Node: ",
                                    style: TextStyle(
                                        color: Color(0xFFFFFFFF), fontSize: 16),
                                  ),
                                  IconButton(
                                      onPressed: (nodeNumber == 0)
                                          ? null
                                          : () => modifyNodeNumber(-1),
                                      icon: Icon(
                                        Icons.keyboard_arrow_left,
                                        size: 24,
                                        color: (nodeNumber == 0)
                                            ? const Color(0xFF393535)
                                            : const Color(0xFFFFFFFF),
                                      )),
                                  SizedBox.fromSize(
                                    size: const Size.fromWidth(36),
                                    child: Center(
                                        child: Text(
                                          "$nodeNumber",
                                          style: const TextStyle(
                                              color: Color(0xFF00EAFF),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        )),
                                  ),
                                  IconButton(
                                      onPressed: (nodeNumber ==
                                          widget.numberOfNodes - 1)
                                          ? null
                                          : () => modifyNodeNumber(1),
                                      icon: Icon(
                                        Icons.keyboard_arrow_right,
                                        size: 24,
                                        color: (nodeNumber ==
                                            widget.numberOfNodes - 1)
                                            ? const Color(0xFF393535)
                                            : const Color(0xFFFFFFFF),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Center(
                        child: SizedBox(
                          height: h * .6,
                          child: SfCartesianChart(
                            palette: const [Color(0xFF00EAFF), Color(0xFF21B0BD)],
                              zoomPanBehavior: ZoomPanBehavior(
                                  enablePinching: true,
                                  enableDoubleTapZooming: true,
                                  enablePanning: true),
                              borderWidth: 0,
                              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 0),
                              title: ChartTitle(
                                  textStyle: GoogleFonts.rubik(
                                      fontSize: 14,
                                      color: const Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w400)),
                              primaryXAxis: NumericAxis(
                                  title: AxisTitle(text: "Time (mins)", textStyle: GoogleFonts.rubik(color: const Color(0xFFFFFFFF), fontSize: 14)),
                                  visibleMinimum: 0,
                                  visibleMaximum: 150,
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  interval: 15,
                                  majorGridLines: const MajorGridLines(width: 1, color: Color(0xFF433A3A))),
                              primaryYAxis: NumericAxis(
                                  title: AxisTitle(text: "Speed (km/hr)", textStyle: GoogleFonts.rubik(color: const Color(0xFFFFFFFF), fontSize: 14)),
                                  visibleMinimum: 0,
                                  visibleMaximum: 100,
                                  interval: 10,
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  majorGridLines: const MajorGridLines(width: 1, color: Color(0xFF433A3A)),
                              ),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: _getDefaultLineSeries(chartData)),
                        )),
                  ),
                  const Expanded(child: Text("The models are retrained every 7 days.", style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14),))
                ],
              );
            } else if (state is VisualizeNodeValuesError) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Color(0xFFFFFFFF)),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00EAFF),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void modifyNodeNumber(int count) {
    nodeNumber = nodeNumber + count;
    setState(() {});
  }

  void modifyCycleCount(int count) {
    cycleCount = cycleCount + count;
    setState(() {});
  }

  List<LineSeries<_ChartData, num>> _getDefaultLineSeries(
      List<_ChartData> chartDataList) {
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
          animationDuration: 1000,
          dataSource: chartDataList,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          width: 2,
          name: "Node: $nodeNumber",
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final double x;
  final double y;
}
