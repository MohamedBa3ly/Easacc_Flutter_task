

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/permissions/permissions.dart';
import '../../../../data/repository/task_repository.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final TaskRepository repository;

  SettingsCubit({required this.repository}) : super(SettingsInitial());

  String savedUrl = '';
  List<String> wifiDevices = [];
  List<String> bluetoothDevices = [];
  String? selectedWifi;
  String? selectedBluetooth;


  Future<void> loadSettings() async {
    // 1️⃣ Request permissions first
    final granted = await requestPermissions();
    if (!granted) {
      emit(SettingsError('Please grant location and Bluetooth permissions'));
      return;
    }

    // 2️⃣ Load saved settings
    savedUrl = await repository.getSavedUrl();
    selectedWifi = await repository.getSelectedWifi();
    selectedBluetooth = await repository.getSelectedBluetooth();

    // Emit initial state (no devices yet)
    emit(SettingsLoaded(
      url: savedUrl,
      wifiDevices: [],
      bluetoothDevices: [],
      selectedWifi: selectedWifi,
      selectedBluetooth: selectedBluetooth,
    ));

    // 3️⃣ Scan WiFi devices
    repository.scanWifiDevices().then((wifiList) {
      // Remove duplicates
      wifiDevices = wifiList.toSet().toList();

      // Ensure selectedWifi is in the list
      if (selectedWifi != null && !wifiDevices.contains(selectedWifi)) {
        selectedWifi = null;
      }

      emit(SettingsLoaded(
        url: savedUrl,
        wifiDevices: wifiDevices,
        bluetoothDevices: bluetoothDevices,
        selectedWifi: selectedWifi,
        selectedBluetooth: selectedBluetooth,
      ));
    });

    // 4️⃣ Scan Bluetooth devices
    repository.scanBluetoothDevices().then((btList) {
      // Remove duplicates
      bluetoothDevices = btList.toSet().toList();

      // Ensure selectedBluetooth is in the list
      if (selectedBluetooth != null && !bluetoothDevices.contains(selectedBluetooth)) {
        selectedBluetooth = null;
      }

      emit(SettingsLoaded(
        url: savedUrl,
        wifiDevices: wifiDevices,
        bluetoothDevices: bluetoothDevices,
        selectedWifi: selectedWifi,
        selectedBluetooth: selectedBluetooth,
      ));
    });
  }



  Future<void> saveUrl(String url) async {
    await repository.saveUrl(url);
    savedUrl = url;
    emit(SettingsLoaded(
      url: savedUrl,
      wifiDevices: wifiDevices,
      bluetoothDevices: bluetoothDevices,
      selectedWifi: selectedWifi,
      selectedBluetooth: selectedBluetooth,
    ));
  }

  Future<void> selectWifi(String? device) async {
    if (device != null && !wifiDevices.contains(device)) return;
    selectedWifi = device;
    await repository.saveSelectedWifi(device);
    emit(SettingsLoaded(
      url: savedUrl,
      wifiDevices: wifiDevices,
      bluetoothDevices: bluetoothDevices,
      selectedWifi: selectedWifi,
      selectedBluetooth: selectedBluetooth,
    ));
  }


  Future<void> selectBluetooth(String? device) async {
    selectedBluetooth = device;
    await repository.saveSelectedBluetooth(device);
    emit(SettingsLoaded(
      url: savedUrl,
      wifiDevices: wifiDevices,
      bluetoothDevices: bluetoothDevices,
      selectedWifi: selectedWifi,
      selectedBluetooth: selectedBluetooth,
    ));
  }
}
