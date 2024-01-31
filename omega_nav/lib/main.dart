import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omega_nav/features/get_node_locations/presentation/pages/splash_plus_loading_page.dart';
import 'package:omega_nav/features/optimal_path/presentation/pages/node_map_page.dart';
import 'features/visualize_node_values/presentation/pages/visualize_nodes_page.dart';
import 'injection_container.dart' as dep_injector;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep_injector.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.rubikTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: const SplashPlusLoadingPage(),
    );
  }
}
