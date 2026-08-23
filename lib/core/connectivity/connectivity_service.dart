import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  const ConnectivityService(this._connectivity, this._internetChecker);

  final Connectivity _connectivity;
  final InternetConnection _internetChecker;

  Stream<List<ConnectivityResult>> get onNetworkChanged =>
      _connectivity.onConnectivityChanged;

  Future<bool> hasInternet() async {
    return _internetChecker.hasInternetAccess;
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService(Connectivity(), InternetConnection()),
);
