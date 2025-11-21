import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermissions() async {
  final wifiStatus = await Permission.location.request();
  final btStatus = await Permission.bluetoothScan.request();
  return wifiStatus.isGranted && btStatus.isGranted;
}