import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Gallery extends StatelessWidget {
  const Gallery({
    super.key,
    required this.images
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    if(images.isEmpty) return const SizedBox(height: 0);
    return SizedBox(
      height: 112,
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        crossAxisCount: 1,
        childAspectRatio: 1 / 1,
        mainAxisSpacing: 16,
        children: images.map<Widget>((image) => img(image)).toList()
      ),
    );
  }

  Widget img(String image) => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Material(
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(image)),
        child: Image.network(
          image.toString(),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );

}