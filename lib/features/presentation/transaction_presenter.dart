import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../models/transactions.dart';

extension TransactionPresentation on Transactions {
  IconData get icon {
    switch (kategori) {
      case '1':
        return Icons.point_of_sale_rounded;
      case '2':
        return Icons.shopping_bag_outlined;
      case '3':
        return Icons.business_center_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Color categoryColor(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final colorScheme = Theme.of(context).colorScheme;
    switch (kategori) {
      case '1':
        return appColors.green;
      case '2':
        return appColors.red;
      case '3':
        return appColors.blue;
      default:
        return colorScheme.primary;
    }
  }

  Color categoryBgColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>()!;
    switch (kategori) {
      case '1':
        return appColors.greenBg;
      case '2':
        return appColors.redBg;
      case '3':
        return appColors.blueBg;
      default:
        return colorScheme.tertiary;
    }
  }

  Color amountColor(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return masuk ? appColors.green : appColors.red;
  }
}