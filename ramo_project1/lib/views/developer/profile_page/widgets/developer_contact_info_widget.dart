import 'package:flutter/material.dart';

class DeveloperContactInfoWidget extends StatelessWidget {
  const DeveloperContactInfoWidget({
    super.key,
    required this.info,
    required this.iconData,
  });

  final String info;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(iconData),
        const SizedBox(width: 30),
        Text(
          info,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
