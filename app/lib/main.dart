import 'package:app/app.dart';
// import 'package:app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    // Uncomment after $ flutterfire configure
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  // Use emulator if EMULATOR_HOST is set
  const host = String.fromEnvironment("EMULATOR_HOST", defaultValue: "");
  if(host != ""){
    print("Using emulator at $host");
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    await FirebaseStorage.instance.useStorageEmulator(host, 9199);
    FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
  }

  // Run app
  runApp(App());
}