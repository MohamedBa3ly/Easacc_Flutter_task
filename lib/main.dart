import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/utils/service_locator.dart';
import 'navigation/navgraph.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Firebase:
  await Firebase.initializeApp();

  //Setup DI - (GetIt)
  setupServiceLocator();

  runApp(const NavGraph());


}





