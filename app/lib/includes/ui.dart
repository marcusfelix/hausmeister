import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../models/ticket.dart';

IconData icon(Ticket ticket) {
  switch(ticket.type) {
    case TicketType.issue:
      return TablerIcons.alert_triangle;

    case TicketType.request:
      return TablerIcons.bell;

    case TicketType.other:
    default:
      return TablerIcons.circle;
  }
}

Color color(Ticket ticket) {
  switch(ticket.status) {
    case TicketStatus.open:
      return Colors.blue;

    case TicketStatus.aknowledge:
      return Colors.orange;

    case TicketStatus.closed:
      return Colors.green;

    default:
      return Colors.grey;
  }
}