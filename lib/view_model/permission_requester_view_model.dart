import 'package:permission_handler/permission_handler.dart';

const requestPermissions = [Permission.location];

Future<bool> grantLocationPermission() async {
  if (await Permission.location.request().isGranted) {
    if (await Permission.locationWhenInUse.request().isGranted) {
      return true;
    }
  }
  return false;
}
