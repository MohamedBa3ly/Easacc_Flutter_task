import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/errors/failures.dart';

abstract class TaskRepository {
  Future<Either<Failure, UserCredential>> signInWithGoogle();
  // Future<Either<Failure, Map<String, dynamic>>> signInWithFacebook();
  Future<Either<Failure, UserCredential>> signInWithFacebook();


  Future<String> getSavedUrl();
  Future<void> saveUrl(String url);

  Future<String?> getSelectedWifi();
  Future<void> saveSelectedWifi(String? device);

  Future<String?> getSelectedBluetooth();
  Future<void> saveSelectedBluetooth(String? device);

  Future<List<String>> scanWifiDevices();
  Future<List<String>> scanBluetoothDevices();
}