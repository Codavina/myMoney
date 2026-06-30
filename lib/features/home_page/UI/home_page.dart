import 'package:flutter/material.dart';
import 'package:my_money/features/categorie_details/UI/add_category_dialog.dart';
import 'package:my_money/features/categorie_details/data/category_model.dart';
import 'package:my_money/features/home_page/widgets/category_card.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];


  Future<void> _addCategory()async{
    final CategoryModel? category = await showDialog<CategoryModel>(
      context: context,
      builder: (_) => const AddCategoryDialog(),
    );

    if (!mounted || category == null) return;

    setState(() {
      categories.add(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('My Money')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Column(
                children: List.generate(
                  categories.length,
                  (int index) => CategoryCard(category: categories[index]),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(

        onPressed: _addCategory,
        label: const Text('Category',),
        icon: const Icon(Icons.add),
      ),
    );
  }
}


