import 'package:app/models/unit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class Documents extends StatelessWidget {
  const Documents({
    Key? key,
    required this.unit
  }) : super(key: key);

  final Unit unit;
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseStorage.instance.ref('units/${unit.id}').listAll(),
      builder: (context, documents) {
        if((documents.data?.items ?? []).isEmpty) {
          return Container();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                crossAxisCount: 1,
                scrollDirection: Axis.horizontal,
                childAspectRatio: 4 / 3,
                mainAxisSpacing: 16,
                children: documents.data!.items.map((e) => card(context, e)).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      }
    );
  }

  Widget card(BuildContext context, Reference file) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        image: const DecorationImage(
          image: AssetImage("assets/bg_card.png"),
          fit: BoxFit.fitHeight
        )
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            file.getDownloadURL().then((value) => launchUrl(Uri.parse(value)));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(TablerIcons.file_text, size: 24),
                Text(
                  file.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );

}