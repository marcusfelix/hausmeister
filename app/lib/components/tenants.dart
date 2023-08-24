import 'package:app/includes/translator.dart';
import 'package:app/models/profile.dart';
import 'package:app/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class Tenants extends StatelessWidget {
  Tenants({
    Key? key,
    required this.unit
  }) : super(key: key);

  final Unit unit;

  final controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            translate("tenants_string").toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        SizedBox(
          height: 96,
          child: GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            crossAxisCount: 1,
            scrollDirection: Axis.horizontal,
            childAspectRatio: 5 / 3,
            mainAxisSpacing: 16,
            children: unit.tenants.map((e) => card(context, e)).toList()..add(card(context, null)),
          ),
        ),
      ],
    );
  }

  Widget card(BuildContext context, Profile? profile) => Column(
    children: [
      AspectRatio(
        aspectRatio: 1 / 1,
        child: Material(
          shape: const CircleBorder(),
          color: Colors.transparent,
          child: InkWell(
            onTap: profile == null ? (){
              showDialog(
                context: context, 
                builder: (context) => inviteBox(context)
              );
            } : null,
            customBorder: const CircleBorder(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                  width: 2,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(profile != null ? 0.2 : 0),
                ),
                child: profile != null ? profile.photo != null ? ClipOval(
                  child: Image.network(
                    profile.photo.toString(),
                    fit: BoxFit.cover,
                  )
                ) : Center(
                  child: Text(
                    profile.name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                ) : Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Icon(
                    TablerIcons.plus,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
              )
            ),
          ),
        ),
      ),
      const SizedBox(height: 2),
      Text(
        profile?.name ?? translate("add_tenant_string"),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
        ),
      )
    ],
  );

  Widget inviteBox(context) => AlertDialog(
    title: Text(translate("invite_tenant_string")),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(translate("invite_tenant_following_code_string")),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Text(
            unit.accessCode.toUpperCase(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(translate("cancel_string").toUpperCase()),
      ),
    ],
  );
}