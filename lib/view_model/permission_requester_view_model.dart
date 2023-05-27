import 'package:permission_handler/permission_handler.dart';

const requestPermissions = [Permission.location];

Future<bool> grantLocationPermission() async {
  if (!await Permission.location.isGranted) {
    if (!await Permission.location.request().isGranted) {
      return false;
    }
  }
  if (!await Permission.locationWhenInUse.isGranted) {
    if (!await Permission.locationWhenInUse.request().isGranted) {
      return false;
    }
  }

  return true;
}
