import 'package:dartz/dartz.dart';
import 'package:easacc_flutter_task/data/repository/task_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '../../core/errors/failures.dart';


class TaskRepositoryImpl implements TaskRepository {

  @override
  Future<Either<Failure, UserCredential>> signInWithGoogle() async {
    try {
      // 1. Google sign-in
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return Left(ServerFailure('Google sign-in canceled'));
      }

      // 2. Get Google auth tokens
      final googleAuth = await googleUser.authentication;

      // 3. Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // 4. Sign in with Firebase
      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Login failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }




  @override
  Future<Either<Failure, UserCredential>> signInWithFacebook() async {
    try {
      // Trigger Facebook login
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      // Handle login result
      switch (result.status) {
        case LoginStatus.success:
        // Get access token
          final AccessToken accessToken = result.accessToken!;

          // Create a Firebase credential
          final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.tokenString);

          // Sign in with Firebase
          final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

          return Right(userCredential);

        case LoginStatus.cancelled:
          return Left(ServerFailure('Facebook login canceled by user'));

        case LoginStatus.failed:
          return Left(ServerFailure(result.message ?? 'Facebook login failed'));

        default:
          return Left(ServerFailure('Unknown Facebook login error'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase auth error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<String> getSavedUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('website_url') ?? '';
  }

  @override
  Future<void> saveUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('website_url', url);
  }

  @override
  Future<String?> getSelectedWifi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_wifi');
  }

  @override
  Future<void> saveSelectedWifi(String? device) async {
    final prefs = await SharedPreferences.getInstance();
    if (device != null) await prefs.setString('selected_wifi', device);
  }

  @override
  Future<String?> getSelectedBluetooth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_bt');
  }

  @override
  Future<void> saveSelectedBluetooth(String? device) async {
    final prefs = await SharedPreferences.getInstance();
    if (device != null) await prefs.setString('selected_bt', device);
  }

  @override
  Future<List<String>> scanWifiDevices() async {
    try {
      final networks = await WiFiForIoTPlugin.loadWifiList();
      // Filter out null SSIDs
      return networks.map((e) => e.ssid ?? '').where((ssid) => ssid.isNotEmpty).toList();
    } catch (_) {
      return [];
    }
  }


  @override
  Future<List<String>> scanBluetoothDevices() async {
    final devices = <String>{}; // use Set to remove duplicates

    // Listen to scan results
    final subscription = FlutterBluePlus.scanResults.listen((results) {
      for (var r in results) {
        final name = r.device.name;
        if (name.isNotEmpty) devices.add(name);
      }
    });

    // Start scanning for 6-10 seconds (more time to find devices)
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 8));

    // Wait for scan to finish
    await Future.delayed(const Duration(seconds: 8));

    // Stop scanning and cancel subscription
    await FlutterBluePlus.stopScan();
    await subscription.cancel();

    return devices.toList();
  }




}
