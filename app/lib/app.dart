
import 'package:app/includes/theme.dart';
import 'package:app/models/unit.dart';
import 'package:app/views/auth.dart';
import 'package:app/views/home.dart';
import 'package:app/views/onboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hausmeister',
      theme: theme,
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1500),
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, user) {
            if(user.data == null){
              return const Auth();
            }
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection("units").where("tenants.${user.data!.uid}", isNull: false).snapshots(),
              builder: (context, units) {
                if((units.data?.docs ?? []).isEmpty){
                  return const Onboard();
                }
                final unit = (units.data?.docs ?? []).first;
                return Home(
                  unit: Unit.fromJson(unit.id, unit.data())
                );
              }
            );
          }
        ),
      ),
    );
  }
}