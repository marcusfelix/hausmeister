import 'package:app/components/composer.dart';
import 'package:app/components/gallery.dart';
import 'package:app/includes/translator.dart';
import 'package:app/models/unit.dart';
import 'package:app/views/messages_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../includes/ui.dart';
import '../models/ticket.dart';

class TicketView extends StatelessWidget {
  const TicketView({
    Key? key,
    required this.unit,
    required this.ticket
  }) : super(key: key);

  final Unit unit;
  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: const Icon(TablerIcons.arrow_left)
        ),
        title: Text(ticket.title),
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Gallery(
                images: ticket.attachments
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon(ticket),
                          size: 20,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      title: Text(translate("${ticket.type.name}_string")),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color(ticket).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color(ticket),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      title: Text(translate("${ticket.status.name}_string")),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  ticket.description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.3,
                  ),
                ),
              ),
              const Divider(
                height: 32,
                thickness: 1,
                endIndent: 16,
                indent: 16,
              )
            ],
          ),
          Expanded(
            child: MessagesView(
              unit: unit,
              ticket: ticket
            )
          )
        ],
      ),
      bottomNavigationBar: Composer(
        unit: unit,
        ticket: ticket
      )
    );
  }
}