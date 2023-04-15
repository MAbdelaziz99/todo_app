import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

navigateToAndRemoveUntil({
  required context,
  required screen,
}) =>
    Navigator.pushNamedAndRemoveUntil(context, screen, (route) => false);

navigateTo({required context, required screen}) =>
    Navigator.pushNamed(context, screen);

Widget defaultTextFormField({
  required TextEditingController controller,
  required String hintText,
  IconData? suffixIcon,
  IconData? prefixIcon,
  required TextInputType keyboardType,
  bool obscureText = false,
  VoidCallback? suffixIconPressed,
  VoidCallback? onTab,
  ValueChanged? onFieldSubmitted,
  ValueChanged? onFieldChanged,
  required errorText,
  bool isClickable = true,
  int? maxLines = 1,
  double radius = 10.0,
  double contentPadding = 20.0,
}) =>
    TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(contentPadding).r,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius).r,
        ),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(suffixIcon),
          onPressed: suffixIconPressed,
        ),
        prefixIcon: Icon(
          prefixIcon,
        ),
      ),
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      onTap: onTab,
      maxLines: maxLines,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onFieldChanged,
      validator: (value) {
        if(value == null || value.isEmpty) {
          return errorText;
        }
        return null;
      },
      enabled: isClickable,
    );

defaultSuccessSnackBar({required String message, required context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(milliseconds: 3 * 1000),
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 16.sp, color: Colors.white),
    ),
    backgroundColor: Colors.green,
  ));
}

defaultErrorSnackBar({required String message, required context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(milliseconds: 3 * 1000),
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 16.sp, color: Colors.white,),
    ),
    backgroundColor: Colors.red,
  ));
}

Widget defaultDivider() => Divider(
  height: 1.h,
  thickness: 0.8,
  color: const Color(0x61000000),
);

