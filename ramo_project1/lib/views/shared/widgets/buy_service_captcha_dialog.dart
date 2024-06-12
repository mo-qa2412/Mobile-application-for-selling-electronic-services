import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import '../../../shared/utils/toast_service.dart';

class BuyServiceCaptchaDialog extends StatefulWidget {
  const BuyServiceCaptchaDialog({super.key});

  @override
  State<BuyServiceCaptchaDialog> createState() =>
      _BuyServiceCaptchaDialogState();
}

class _BuyServiceCaptchaDialogState extends State<BuyServiceCaptchaDialog> {
  late int firstNumber;
  late int secondNumber;
  late String operator;
  late int solution;
  TextEditingController solutionController = TextEditingController();

  @override
  void initState() {
    Random random = Random();
    firstNumber = random.nextInt(9);
    secondNumber = random.nextInt(9);
    operator = operators[random.nextInt(1)];
    solution = calculateResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    ColorScheme colorScheme = themeData.colorScheme;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          decoration: BoxDecoration(
            color: colorScheme.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confirm Service Order',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Confirm order by solving the following math equation:',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  '$firstNumber $operator $secondNumber = ?',
                  style: textTheme.headlineMedium,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: solutionController,
                decoration: const InputDecoration(label: Text('Solution')),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context)
                            .colorScheme
                            .errorContainer
                            .withOpacity(.2),
                      ),
                    ),
                    onPressed: () => Get.back(result: false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () => confirmOrder(),
                    child: const Text('Confirm Order'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void confirmOrder() {
    if (solutionController.text.isEmpty) {
      return;
    }
    if (int.parse(solutionController.text) != solution) {
      ToastService.showErrorToast(
        message: 'Invalid solution for the equation!',
      );
      return;
    }
    
    Get.back(result: true);

    return;
  }

  int calculateResult() {
    switch (operator) {
      case '+':
        {
          return firstNumber + secondNumber;
        }
      case '-':
        {
          return firstNumber - secondNumber;
        }
    }
    return 0;
  }
}

List<String> operators = [
  '+',
  '-',
];
