import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivityChecker;

  NetworkInfoImpl({required this.connectivityChecker});

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivityChecker.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
