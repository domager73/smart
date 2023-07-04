  import 'package:flutter/material.dart';
import 'package:smart/utils/fonts.dart';

import '../../utils/colors.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final double width;
  final double height;
  final TextStyle styleText;
  final EdgeInsets padding;
  final bool isTouch;
  final Color activeColor;
  final Color disableColor;
  final Widget? child;

  const CustomTextButton({
    Key? key,
    required this.callback,
    required this.text,
    required this.styleText,
    this.width = double.infinity,
    this.height = 50,
    this.padding = const EdgeInsets.all(10),
    this.isTouch = false,
    this.child,
    this.activeColor = AppColors.red,
    this.disableColor = AppColors.disable,
  }) : super(key: key);

  CustomTextButton.withIcon({
    Key? key,
    required this.callback,
    required this.text,
    required this.styleText,
    this.width = double.infinity,
    this.height = 52,
    this.padding = EdgeInsets.zero,
    this.isTouch = false,
    this.activeColor = AppColors.red,
    this.disableColor = AppColors.disable,
    required Widget icon,
  }) : child = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      icon,
      const SizedBox(
        width: 10,
      ),
      Text(
        text,
        style: AppTypography.font14white,
      )
    ],
  ), super(key: key);

  const CustomTextButton.orangeContinue({
    Key? key,
    required this.callback,
    required this.text,
    this.styleText = AppTypography.font14white,
    this.width = double.infinity,
    this.height = 52,
    this.padding = const EdgeInsets.all(0),
    this.isTouch = false,
    this.child,
    this.activeColor = AppColors.red,
    this.disableColor = AppColors.disable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: isTouch ? activeColor : disableColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)))),
        onPressed: callback,
        child: child ?? Text(
          text,
          style: styleText,
        ),
      ),
    );
  }
}