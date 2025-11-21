part of 'settings_cubit.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final String url;
  final List<String> wifiDevices;
  final List<String> bluetoothDevices;
  final String? selectedWifi;
  final String? selectedBluetooth;

  SettingsLoaded({
    required this.url,
    required this.wifiDevices,
    required this.bluetoothDevices,
    required this.selectedWifi,
    required this.selectedBluetooth,
  });
}

class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);
}
