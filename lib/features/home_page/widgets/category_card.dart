import 'package:flutter/material.dart';
import '../../../core/utils/app_formatter.dart';
import '../../categories_details_page/data/category_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category,required this.onPressed});

  final CategoryModel category;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              category.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${AppFormatter.money.format(category.balance)} ${category.currency}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          trailing: IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.arrow_forward_ios, size: 36),
          ),
        ),
      ),
    );
  }
}
