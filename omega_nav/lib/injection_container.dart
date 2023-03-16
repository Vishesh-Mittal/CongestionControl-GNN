import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:omega_nav/core/device_information/network_info.dart';
import 'package:omega_nav/features/get_node_locations/data/data_sources/get_node_locations_remote_data_source.dart';
import 'package:omega_nav/features/get_node_locations/data/repositories/get_node_locations_repository.dart';
import 'package:omega_nav/features/get_node_locations/presentation/manager/get_node_locations_bloc.dart';
import 'package:omega_nav/features/optimal_path/data/data_sources/optimal_path_remote_data_source.dart';
import 'package:omega_nav/features/optimal_path/data/repositories/optimal_path_repository.dart';
import 'package:omega_nav/features/optimal_path/presentation/manager/optimal_path_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:omega_nav/features/visualize_node_values/data/data_sources/visualize_node_values_remote_data_source.dart';
import 'package:omega_nav/features/visualize_node_values/data/repositories/visualize_node_values_repository.dart';
import 'package:omega_nav/features/visualize_node_values/presentation/manager/visualize_node_values_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async{
  sl.registerFactory(() => OptimalPathBloc(repository: sl()));
  sl.registerFactory(() => GetNodeLocationsBloc(repository: sl()));
  sl.registerFactory(() => VisualizeNodeValuesBloc(repository: sl()));

  sl.registerLazySingleton<OptimalPathRepository>(() => OptimalPathRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()));
  sl.registerLazySingleton<GetNodeLocationsRepository>(() => GetNodeLocationsRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()));
  sl.registerLazySingleton<VisualizeNodeValuesRepository>(() => VisualizeNodeValuesRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()));

  sl.registerLazySingleton<OptimalPathRemoteDataSource>(() => OptimalPathRemoteDataSourceImpl(client: sl(), polylinePoints: sl()));
  sl.registerLazySingleton<GetNodeLocationsRemoteDataSource>(() => GetNodeLocationsRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<VisualizeNodeValuesRemoteDataSource>(() => VisualizeNodeValuesRemoteDatSourceImpl(client: sl()));

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: sl()));
  sl.registerLazySingleton<PolylinePoints>(() => PolylinePoints());
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());

}
