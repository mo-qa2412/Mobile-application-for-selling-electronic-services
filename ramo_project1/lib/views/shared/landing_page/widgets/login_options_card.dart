import 'package:flutter/material.dart';

class LoginOptionsCard extends StatelessWidget {
  const LoginOptionsCard({
    super.key,
    required this.iconData,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });

  final IconData iconData;
  final String title;
  final String subTitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    ColorScheme colorScheme = themeData.colorScheme;
    return ListTile(
      onTap: onTap,
      leading: Icon(
        iconData,
        color: colorScheme.primary,
      ),
      title: Text(
        title,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      tileColor: colorScheme.surfaceVariant.withOpacity(.4),
      titleTextStyle: themeData.textTheme.bodyLarge?.copyWith(
        color: colorScheme.primary,
      ),
      subtitle: Text(
        subTitle,
      ),
    );
  }
}
