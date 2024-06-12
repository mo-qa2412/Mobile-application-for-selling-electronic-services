import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/entities/ramo_service.dart';
import '../../../../models/enums.dart';
import '../../../shared/widgets/service_details_page.dart';

class RAMOServiceHomePageCard extends StatelessWidget {
  const RAMOServiceHomePageCard({super.key, required this.service});

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
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colorScheme.surfaceVariant.withOpacity(.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Container(
                height: 75,
                width: 75,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: colorScheme.surfaceVariant),
                child: Image.asset(
                  'assets/category_icons/${service.category.index}.png',
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      color: colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    categoriesAsString[service.category]!,
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${service.price} SYP',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
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
