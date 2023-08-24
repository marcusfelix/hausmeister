import 'package:app/models/profile.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    required this.profile,
    required this.onTap,
    this.size = "md",
    this.negative = false
  }) : super(key: key);

  final Profile? profile;
  final Function() onTap;
  final String size;
  final bool negative;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size == "lg" ? 48 : size == "md" ? 40 : 32,
        height: size == "lg" ? 48 : size == "md" ? 40 : 32,
        child: CircleAvatar(
          backgroundColor: negative ? Theme.of(context).colorScheme.onSecondaryContainer : Theme.of(context).colorScheme.secondaryContainer,
          backgroundImage: profile?.photo != null ? NetworkImage(profile!.photo!) : null,
          child: Text(
            profile?.name[0] ?? "-",
            style: TextStyle(
              fontSize: size == "lg" ? 28 : size == "md" ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: negative ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}