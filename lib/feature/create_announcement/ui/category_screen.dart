import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/category/category.dart';

import '../bloc/category/category_cubit.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategorySuccessState) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData.fallback(),
              backgroundColor: AppColors.empty,
              elevation: 0,
              title: Text(
                'Ajouter une annonce',
                style: AppTypography.font20black,
              ),
            ),
            body: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 108 / 120,
              children: state.categories
                  .map(
                      (e) => CategoryWidget(category: e,))
                  .toList(),
            ),
          );
        } else if (state is CategoryFailState) {
          return const Center(
            child: Text('Проблемс'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}