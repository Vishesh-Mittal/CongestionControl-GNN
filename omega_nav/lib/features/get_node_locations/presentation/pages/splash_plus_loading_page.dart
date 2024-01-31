import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omega_nav/core/common_widgets/space_helpers.dart';
import 'package:omega_nav/features/get_node_locations/presentation/manager/get_node_locations_bloc.dart';
import 'package:omega_nav/features/optimal_path/presentation/pages/node_map_page.dart';

import '../../../../injection_container.dart';

class SplashPlusLoadingPage extends StatefulWidget {
  const SplashPlusLoadingPage({Key? key}) : super(key: key);

  @override
  State<SplashPlusLoadingPage> createState() => _SplashPlusLoadingPageState();
}

class _SplashPlusLoadingPageState extends State<SplashPlusLoadingPage> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF2A2525),
      body: BlocProvider<GetNodeLocationsBloc>(
        create: (context) => sl<GetNodeLocationsBloc>()..add(LoadGetNodeLocationsEvent()),
        child: Container(
          height: h,
          width: w,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Splash.png"),
                  fit: BoxFit.fitWidth)),
          child: Column(
            children: [
              addVerticalSpace(h * .75),
              BlocConsumer<GetNodeLocationsBloc, GetNodeLocationsState>(
                listener: (context, state) {
                  if (state is GetNodeLocationsLoaded) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => NodeMapPage(nodeLocationsList: state.nodeLocationsList)));
                  }
                },
                builder: (context, state) {
                  if (state is GetNodeLocationsError) {
                    return Column(
                      children: [
                        const Icon(Icons.close, size: 56, color: Color(0xFFA90B0B),),
                        addVerticalSpace(h * .04),
                        Text(state.errorMessage, style: const TextStyle(
                          color: Color(0xFFFFFFFF), fontSize: 14
                        ),)
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator(
                      color: Color(0xFF00EAFF),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
