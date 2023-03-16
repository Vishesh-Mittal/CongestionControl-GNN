import 'dart:async';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:omega_nav/features/optimal_path/data/models/optimal_path_result_model.dart';
import 'package:omega_nav/features/visualize_node_values/presentation/pages/visualize_nodes_page.dart';

import '../../../../core/common_widgets/alert_helper.dart';
import '../../../../core/common_widgets/space_helpers.dart';

import '../../../../injection_container.dart';

import '../manager/optimal_path_bloc.dart';
import '../widgets/map_marker.dart';
import '../widgets/marker_generator.dart';

class NodeMapPage extends StatefulWidget {
  final List<LatLng> nodeLocationsList;

  const NodeMapPage({Key? key, required this.nodeLocationsList})
      : super(key: key);

  @override
  State<NodeMapPage> createState() => _NodeMapPageState();
}

class _NodeMapPageState extends State<NodeMapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final List<String> _modelNames = ["DCRNN", "A3TGCN", "GCLSTM"];

  final String _initialStartMessage = "to start...";
  final String _initialEndMessage = "to end...";

  String _selectedModel = "DCRNN";
  String _startPoint = "to start...";
  String _endPoint = "to end...";

  final List<Marker> _mapMarkers = [];
  List<MapMarker> markerList = [];
  final Set<Polyline> _polyLine = <Polyline>{};
  List<String> tempPath = [];

  @override
  void initState() {
    super.initState();
    markerWidgets();
    generateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition _initialPosition = CameraPosition(
      target: widget.nodeLocationsList[0],
      zoom: 13.5,
    );

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
        body: BlocProvider<OptimalPathBloc>(
      create: (context) => sl<OptimalPathBloc>(),
      child: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            polylines: _polyLine,
            markers: _mapMarkers.toSet(),
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Container(
            width: w,
            height: h * .33,
            decoration: BoxDecoration(
                color: const Color(0xFF2A2525),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ]),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 32,
                                width: 1,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFABBAB8),
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF1C2C82)),
                                      height: 12,
                                      width: 12,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF36B1EE)),
                                      height: 12,
                                      width: 12,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    const Text(
                                      "From: ",
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Node " + _startPoint,
                                      style: const TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 16),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          _startPoint != _initialStartMessage
                                              ? IconButton(
                                                  onPressed: () =>
                                                      resetStartPoint(),
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Color(0xFFFFFFFF),
                                                  ))
                                              : Container(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                      const Color(0xFFABBAB8),
                                      const Color(0xFFABBAB8).withOpacity(0.0)
                                    ],
                                        stops: const [
                                      0.5,
                                      1.0
                                    ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight)),
                                height: 1,
                                width: w,
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    const Text(
                                      "To: ",
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Node " + _endPoint,
                                      style: const TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 16),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          _endPoint != _initialEndMessage
                                              ? IconButton(
                                                  onPressed: () =>
                                                      resetEndPoint(),
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Color(0xFFFFFFFF),
                                                  ))
                                              : Container(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Model:",
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            AnimatedToggleSwitch<String>.size(
                              current: _selectedModel,
                              values: _modelNames,
                              iconOpacity: 0.3,
                              height: 36,
                              indicatorSize: Size.fromWidth(w * .225),
                              indicatorBorder:
                                  Border.all(color: const Color(0xFF16BFBF)),
                              iconBuilder: (val, _) {
                                return Center(
                                    child: Text(
                                  val,
                                  style: TextStyle(
                                      fontSize: _selectedModel == val ? 14 : 13,
                                      color: (val == _selectedModel)
                                          ? const Color(0xFF00EAFF)
                                          : const Color(0xFF909090)),
                                ));
                              },
                              innerColor: const Color(0xFF2A2525),
                              borderColor: const Color(0xFF393535),
                              colorBuilder: (_) => const Color(0xFF2A2525),
                              onChanged: (val) =>
                                  setState(() => _selectedModel = val),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
          BlocConsumer<OptimalPathBloc, OptimalPathState>(
            listener: (context, state) {
              if (state is GetOptimalPathLoading) {
                displayLoadingSnackBarMessage(
                  context,
                  "Finding the optimal path...",
                  const Color(0xFFFFFFFF),
                  const Color(0xFF2A2525),
                );
              } else if (state is GetOptimalPathLoaded) {
                dismissSnackBarMessage(context);
                displayLoadingSnackBarMessage(
                    context,
                    "Path Found! Interpreting results...",
                    const Color(0xFFFFFFFF),
                    const Color(0xFF16BFBF));
                Future.delayed(const Duration(seconds: 3), () {
                  _dispatchGenerateRoute(context, state.optimalPathResultModel);
                  // tempPath = state.optimalPathResultModel.pathOfIds;
                  // print(tempPath);
                  // changePathPoints();
                });
              } else if (state is GetOptimalPathError) {
                dismissSnackBarMessage(context);
                displayAlertSnackBarMessage(
                    context,
                    "Server was unable to return the path...",
                    const Color(0xFFFFFFFF),
                    const Color(0xFFA90B0B));
              } else if (state is GeneratingRouteLoading) {
                dismissSnackBarMessage(context);
                displayLoadingSnackBarMessage(context, "Generating route...",
                    const Color(0xFFFFFFFF), const Color(0xFF16BFBF));
              } else if (state is GeneratingRouteLoaded) {
                dismissSnackBarMessage(context);
                _polyLine.clear();
                _polyLine.add(state.polyline);
                setState(() {});
              }
            },
            builder: (context, state) {
              if (state is GeneratingRouteLoaded) {
                return Positioned(
                  bottom: h * .05,
                  width: w,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  enableFeedback: false,
                                  backgroundColor: const Color(0xFF2A2525),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 40.0),
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40))),
                              onPressed:
                                  (_startPoint == _initialStartMessage) ||
                                          (_endPoint == _initialEndMessage)
                                      ? null
                                      : () => _dispatchGetOptimalPath(context),
                              child: Text(
                                "Predict",
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      (_startPoint == _initialStartMessage) ||
                                              (_endPoint == _initialEndMessage)
                                          ? const Color(0xFF393535)
                                          : const Color(0xFF00EAFF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    enableFeedback: false,
                                    backgroundColor: const Color(0xFF2A2525),
                                    padding: const EdgeInsets.all(16.0),
                                    elevation: 4.0,
                                    shape: const CircleBorder()),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => VisualizeNodesPage(
                                            numberOfNodes:
                                                widget.nodeLocationsList.length,
                                            selectedModel: _selectedModel,
                                          )));
                                },
                                child: const Icon(
                                  Icons.insights_rounded,
                                  size: 18,
                                  color: Color(0xFFFFFFFF),
                                )),
                          ],
                        ),
                        addVerticalSpace(16.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              enableFeedback: false,
                              backgroundColor: const Color(0xFF2A2525),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 0.0),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40))),
                          onPressed: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Estimated Travel Time: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                state.optimalPathResultModel.estimatedTime
                                        .toStringAsFixed(2) +
                                    " mins",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF00EAFF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if ((state is GetOptimalPathError) ||
                  (state is OptimalPathInitial)) {
                return Positioned(
                  bottom: h * .05,
                  width: w,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              enableFeedback: false,
                              backgroundColor: const Color(0xFF2A2525),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 40.0),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40))),
                          onPressed:
                          (_startPoint == _initialStartMessage) ||
                              (_endPoint == _initialEndMessage)
                              ? null
                              : () => _dispatchGetOptimalPath(context),
                          child: Text(
                            "Predict",
                            style: TextStyle(
                              fontSize: 16,
                              color:
                              (_startPoint == _initialStartMessage) ||
                                  (_endPoint == _initialEndMessage)
                                  ? const Color(0xFF393535)
                                  : const Color(0xFF00EAFF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                enableFeedback: false,
                                backgroundColor: const Color(0xFF2A2525),
                                padding: const EdgeInsets.all(16.0),
                                elevation: 4.0,
                                shape: const CircleBorder()),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => VisualizeNodesPage(
                                        numberOfNodes:
                                            widget.nodeLocationsList.length,
                                        selectedModel: _selectedModel,
                                      )));
                            },
                            child: const Icon(
                              Icons.insights_rounded,
                              size: 18,
                              color: Color(0xFFFFFFFF),
                            )),
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    ));
  }

  void _dispatchGetOptimalPath(BuildContext context) {
    BlocProvider.of<OptimalPathBloc>(context).add(LoadGetOptimalPathEvent(
        startPointId: _startPoint,
        endPointId: _endPoint,
        modelName: _selectedModel));
  }

  void _dispatchGenerateRoute(
      BuildContext context, OptimalPathResultModel optimalPathResultModel) {
    BlocProvider.of<OptimalPathBloc>(context).add(LoadGenerateRouteEvent(
        nodeLocations: widget.nodeLocationsList,
        optimalPathResultModel: optimalPathResultModel));
  }

  void setPointValues(String pointId) {
    if (_startPoint == _initialStartMessage) {
      if (_endPoint != pointId) {
        _startPoint = pointId;
        modifySelectedMarker(int.parse(pointId), const Color(0xFF1C0A66));
      }
    } else if (_endPoint == _initialEndMessage) {
      if (_startPoint != pointId) {
        _endPoint = pointId;
        modifySelectedMarker(int.parse(pointId), const Color(0xFF36B1EE));
      }
    }
    setState(() {});
  }

  void resetStartPoint() {
    String _temp = _startPoint;
    _startPoint = _initialStartMessage;
    modifySelectedMarker(int.parse(_temp), const Color(0xFF716666));
  }

  void resetEndPoint() {
    String _temp = _endPoint;
    _endPoint = _initialEndMessage;
    modifySelectedMarker(int.parse(_temp), const Color(0xFF716666));
  }

  void changePathPoints() {
    for (String point in tempPath.sublist(1, tempPath.length - 1)) {
      modifySelectedMarker(int.parse(point), const Color(0xFF435623));
    }
  }

  void markerWidgets() {
    markerList = [];
    for (int i = 0; i < widget.nodeLocationsList.length; i++) {
      markerList.add(MapMarker(id: "$i", color: const Color(0xFF716666)));
    }
  }

  void modifySelectedMarker(int id, Color color) {
    markerList[id] = MapMarker(id: "$id", color: color);
    MarkerGenerator(
        markerWidgets: [MapMarker(id: "$id", color: color)],
        callback: (bitmaps) {
          setState(() {
            _mapMarkers[id] = Marker(
                markerId: MarkerId("$id"),
                position: widget.nodeLocationsList[id],
                icon: BitmapDescriptor.fromBytes(bitmaps[0]),
                onTap: () {
                  setPointValues("$id");
                });
          });
        }).generate(context);
  }

  void generateMarkers() {
    MarkerGenerator(
        markerWidgets: markerList,
        callback: (bitmaps) {
          setState(() {
            List<LatLng> _listOfPoints = widget.nodeLocationsList;
            for (int i = 0; i < _listOfPoints.length; i++) {
              _mapMarkers.add(Marker(
                  markerId: MarkerId("$i"),
                  position: _listOfPoints[i],
                  icon: BitmapDescriptor.fromBytes(bitmaps[i]),
                  onTap: () {
                    setPointValues("$i");
                  }));
            }
          });
        }).generate(context);
  }
}
