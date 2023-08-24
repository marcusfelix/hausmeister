import 'package:app/includes/translator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class EmptyTickets extends StatelessWidget {
  const EmptyTickets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            TablerIcons.alert_triangle,
            color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.4),
            size: 18,
          ),
          Text(
            translate("no_tickets_string"),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.4),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}