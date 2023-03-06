// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omega Nav',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Rubik',
      ),
      home: const MyHomePage(title: 'Omega Nav'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSelected_dcrnn = false;
  bool isSelected_a3tgcn = false;
  bool isSelected_stgcn = false;
  int _counter = 0;

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/dot.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                height: 250,
                width: screenWidth,
                decoration:
                    const BoxDecoration(color: Color(0xff2A2525), boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  )
                ]),
              ),
            ),
            const Positioned(
              top: 70,
              left: 60,
              child: Text(
                "From:",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rubik'),
              ),
            ),
            const Positioned(
              top: 70,
              left: 120,
              child: Text(
                "Point 1",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 75,
              left: 30,
              child: Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  color: Color(0xff1C2C82),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 110,
              left: 60,
              child: Container(
                height: 1,
                width: 0.75 * screenWidth,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.white,
                      Color(0xffABBAB8),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 130,
              left: 60,
              child: Text(
                "To:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Positioned(
              top: 130,
              left: 90,
              child: Text(
                "Point 2",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 170,
              left: 60,
              child: Container(
                height: 1,
                width: 0.75 * screenWidth,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.white,
                      Color(0xffABBAB8),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 135,
              left: 30,
              child: Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  color: Color(0xff36B1EE),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 95,
              left: 34,
              child: Container(
                height: 30,
                width: 1,
                decoration: BoxDecoration(color: Colors.white),
              ),
            ),
            const Positioned(
              top: 200,
              left: 30,
              child: Text(
                "Model:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 190,
              left: 100,
              child: Container(
                height: 40,
                width: 300,
                decoration: const BoxDecoration(
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.black12),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black, blurRadius: 1, spreadRadius: 0),
                    BoxShadow(
                        color: Color(0xff2A2525),
                        blurRadius: 10,
                        spreadRadius: 5),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 185,
              left: 105,
              child: FlatButton(
                color: const Color(0xff2A2525),
                onPressed: () {
                  print(isSelected_dcrnn);
                  setState(() {
                    isSelected_dcrnn = !isSelected_dcrnn;
                    isSelected_a3tgcn = false;
                    isSelected_stgcn = false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  side: BorderSide(
                      color: isSelected_dcrnn
                          ? Color(0xff00EAFF)
                          : Colors.transparent,
                      width: 1),
                ),
                child: const Text(
                  "DCRNN",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 185,
              left: 200,
              child: FlatButton(
                color: const Color(0xff2A2525),
                onPressed: () {
                  print(isSelected_a3tgcn);
                  setState(() {
                    isSelected_a3tgcn = !isSelected_a3tgcn;
                    isSelected_dcrnn = false;
                    isSelected_stgcn = false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  side: BorderSide(
                      color: isSelected_a3tgcn
                          ? Color(0xff00EAFF)
                          : Colors.transparent,
                      width: 1),
                ),
                child: const Text(
                  "A3TGCN",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 185,
              left: 310,
              child: FlatButton(
                color: const Color(0xff2A2525),
                onPressed: () {
                  print(isSelected_a3tgcn);
                  setState(() {
                    isSelected_stgcn = !isSelected_stgcn;
                    isSelected_dcrnn = false;
                    isSelected_a3tgcn = false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  side: BorderSide(
                      color: isSelected_stgcn
                          ? Color(0xff00EAFF)
                          : Colors.transparent,
                      width: 1),
                ),
                child: const Text(
                  "STGCN",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 250,
              // ignore: sized_box_for_whitespace
              child: Container(
                height: 900,
                width: screenWidth,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(19.01820173, 73.1064476), zoom: 11),
                  markers: {
                    Marker(
                      markerId: const MarkerId("marker1"),
                      position: const LatLng(19.01820173, 73.1064476),
                      draggable: false,
                      onDragEnd: (value) {
                        // value is the new position
                      },
                      // To do: custom marker icon
                      icon: markerIcon,
                    ),
                    Marker(
                        markerId: const MarkerId("marker2"),
                        position: const LatLng(18.989847, 73.1158094),
                        icon: markerIcon),
                    Marker(
                      markerId: const MarkerId("marker3"),
                      position: const LatLng(18.9793472, 73.1161232),
                    ),
                    Marker(
                      markerId: const MarkerId("marker4"),
                      position: const LatLng(18.9685004, 73.1317806),
                    ),
                    Marker(
                      markerId: const MarkerId("marker5"),
                      position: const LatLng(18.9846084, 73.0907106),
                    ),
                    Marker(
                      markerId: const MarkerId("marker6"),
                      position: const LatLng(18.95776075, 73.15502465),
                    ),
                    Marker(
                      markerId: const MarkerId("marker7"),
                      position: const LatLng(18.981489, 73.0878071),
                    ),
                    Marker(
                      markerId: const MarkerId("marker8"),
                      position: const LatLng(18.968951, 73.1143154),
                    ),
                    Marker(
                      markerId: const MarkerId("marker9"),
                      position: const LatLng(18.9032905, 72.9893741),
                    ),
                    Marker(
                      markerId: const MarkerId("marker10"),
                      position: const LatLng(18.7513474, 73.0944013),
                    ),
                    Marker(
                      markerId: const MarkerId("marker11"),
                      position: const LatLng(18.9677842, 73.1593135),
                    ),
                    Marker(
                      markerId: const MarkerId("marker12"),
                      position: const LatLng(18.9537858, 73.1705332),
                    ),
                    Marker(
                      markerId: const MarkerId("marker13"),
                      position: const LatLng(18.9667759, 73.1374926),
                    ),
                    Marker(
                      markerId: const MarkerId("marker14"),
                      position: const LatLng(18.8971979, 73.2520656),
                    ),
                    Marker(
                      markerId: const MarkerId("marker15"),
                      position: const LatLng(19.0689075, 72.9931855),
                    ),
                    Marker(
                      markerId: const MarkerId("marker16"),
                      position: const LatLng(19.0972505, 73.0719459),
                    ),
                    Marker(
                      markerId: const MarkerId("marker17"),
                      position: const LatLng(18.9595136, 73.0376418),
                    ),
                    Marker(
                      markerId: const MarkerId("marker18"),
                      position: const LatLng(19.0329606, 73.0297199),
                    ),
                    Marker(
                      markerId: const MarkerId("marker19"),
                      position: const LatLng(18.9654601, 73.0586596),
                    ),
                    Marker(
                      markerId: const MarkerId("marker20"),
                      position: const LatLng(18.9501835, 73.032036),
                    ),
                  },
                ),
              ),
            ),
            Positioned(
              top: 850,
              left: 40,
              child: ElevatedButton(
                onPressed: () {},
                child: Center(
                  child: Text(
                    "Predict",
                    style: TextStyle(color: Color(0xff00EAFF)),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff2A2525),
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                    textStyle: const TextStyle(
                        color: Color(0xff00EAFF),
                        fontSize: 16,
                        fontStyle: FontStyle.normal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    shadowColor: Color(0xff2A2525)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
