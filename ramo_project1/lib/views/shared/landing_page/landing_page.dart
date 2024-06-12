import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../shared/ui/custom_scaffold.dart';
import '../../admin/login/admin_login_page.dart';
import '../../customer/customer_login_page/customer_login.dart';
import '../../developer/login_page/developer_login.dart';
import 'widgets/login_options_card.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    ColorScheme colorScheme = themeData.colorScheme;
    return CustomScaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Hero(
                tag: 'landing_page_icon',
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 330,
                    height: 330,
                    foregroundDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      backgroundBlendMode: BlendMode.hue,
                    ),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant.withOpacity(.4),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/icon/landing_page.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Welcome',
                style: themeData.textTheme.displayMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Login As:',
                style: themeData.textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              LoginOptionsCard(
                iconData: Icons.display_settings,
                title: 'Admin',
                subTitle: 'Manage Finished Orders',
                onTap: () => Get.to(
                  () => const AdminLoginPage(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              LoginOptionsCard(
                iconData: Icons.work_outline_rounded,
                title: 'Developer',
                subTitle: 'Add and Manage Services',
                onTap: () => Get.to(
                  () => const DeveloperLoginPage(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              LoginOptionsCard(
                iconData: Icons.person,
                title: 'Customer',
                subTitle: 'Browse and Buy Services',
                onTap: () => Get.to(
                  () => const CustomerLoginPage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
