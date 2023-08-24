import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Attachments extends StatelessWidget {
  const Attachments({
    required Key key, 
    required this.attachments, 
  }) : super(key: key);

  final List<String> attachments;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: attachments.map((file) => Container(
        margin: const EdgeInsets.only(top: 8),
        constraints: const BoxConstraints(maxWidth: 414),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      file,
                      fit: BoxFit.cover,
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      runSpacing: 4,
                      children: [
                        Text(
                          file.split("/").last, 
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, 
                          style: TextStyle(
                            fontSize: 12, 
                            fontWeight: FontWeight.bold, 
                            color: Theme.of(context).colorScheme.onTertiaryContainer
                          )
                        ),
                      ],
                    ),
                  )
                ],
              ),
              onTap: () {
                launchUrlString(file.toString());
              },
            ),
          ),
        ),
      )).toList()
    );
  }
}
