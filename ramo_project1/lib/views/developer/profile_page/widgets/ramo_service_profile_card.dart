import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/entities/ramo_service.dart';
import '../../../shared/widgets/service_details_page.dart';

class RAMOServiceProfileCard extends StatelessWidget {
  const RAMOServiceProfileCard({super.key, required this.service});

  final RAMOService service;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    ColorScheme colorScheme = themeData.colorScheme;
    return InkWell(
      onTap: () => Get.to(
        () => ServiceDetailsPage(service: service),
      ),
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colorScheme.surfaceVariant.withOpacity(.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: colorScheme.surfaceVariant),
                child: Image.asset(
                  'assets/category_icons/${service.category.index}.png',
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      service.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${service.price} SYP',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
