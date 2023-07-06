import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/models/category.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/images/network_image.dart';

import '../../feature/create_announcement/bloc/subcategory/subcategory_cubit.dart';
import '../../utils/colors.dart';

class CategoryWidget extends StatefulWidget {
  CategoryWidget({super.key, required Category category, this.isActive = true})
      : name = category.name ?? '',
        id = category.id ?? '',
        url = category.imageUrl!;

  final bool isActive;
  final String name;
  final String id;
  final String url;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: AppColors.empty,
      hoverColor: AppColors.empty,
      highlightColor: AppColors.empty,
      splashColor: AppColors.empty,
      onTap: () {
        if (widget.isActive) {
          BlocProvider.of<SubcategoryCubit>(context)
              .loadSubCategories(widget.id);
          Navigator.pushNamed(context, '/create_sub_category_screen');
        }
      },
      child: SizedBox(
        width: 108,
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomNetworkImage(width: 108, height: 100, url: widget.url),
            const SizedBox(
              height: 12,
            ),
            Text(
              widget.name,
              style: AppTypography.font24black.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
