
import 'package:app/components/avatar.dart';
import 'package:app/models/profile.dart';
import 'package:app/models/unit.dart';
import 'package:app/views/chat_view.dart';
import 'package:app/views/dash.dart';
import 'package:app/views/settings.dart';
import 'package:app/views/ticket_edit.dart';
import 'package:app/views/tickets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.unit
  });
  
  final Unit unit;
  
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController controller;
  late User user;
  int index = 0;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      setState(() => index = controller.index);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Avatar(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Settings())),
            profile: Profile(
              uid: user.uid,
              name: user.displayName!,
              photo: user.photoURL
            ),
            negative: true,
          )
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Settings())),
            icon: Icon(TablerIcons.settings, color: Theme.of(context).colorScheme.primary)
          ),
          // IconButton(
          //   onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Wallet())), 
          //   icon: Icon(TablerIcons.wallet, color: Theme.of(context).colorScheme.primary)
          // ),
          // IconButton(
          //   onPressed: () {
          //     final Uri url = Uri(
          //       scheme: 'tel',
          //       path: translate("phone_number_string")
          //     );
          //     canLaunchUrl(url).then((value) => print(value)).catchError((e) => print(e));
          //   }, 
          //   icon: Icon(TablerIcons.phone_call, color: Theme.of(context).colorScheme.primary)
          // )
        ],
      ),
      body: TabBarView(
        controller: controller,
        children: [
          Dash(
            unit: widget.unit
          ),
          Tickets(
            unit: widget.unit
          ),
          ChatView(
            unit: widget.unit
          ),
        ],
      ),
      floatingActionButton: index < 2 ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TicketEdit(
            unit: widget.unit
          )));
        },
        child: const Padding(
          padding: EdgeInsets.only(bottom: 3.0),
          child: Icon(TablerIcons.plus),
        ),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.only(bottom: MediaQuery.viewPaddingOf(context).bottom),
        child: TabBar(
          controller: controller,
          tabs: const [
            Tab(icon: Icon(TablerIcons.star)),
            Tab(icon: Icon(TablerIcons.alert_triangle)),
            Tab(icon: Icon(TablerIcons.message_2)),
          ],
        ),
      )
    );
  }
}