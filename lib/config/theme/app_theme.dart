import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final errorStyle = OutlineInputBorder(
    borderSide: BorderSide(
  color: Colors.red.shade500,
));

final borderStyle = OutlineInputBorder(
  borderSide: BorderSide(
    color: Colors.grey.shade300,
    style: BorderStyle.solid,
  ),
);

final inputDecorationThemes = InputDecorationTheme(
    isDense: true,
    errorStyle: TextStyle(
      color: Colors.red.shade500,
      fontSize: 20.sp,
      fontWeight: FontWeight.w400,
    ),
    errorBorder: errorStyle,
    focusedErrorBorder: errorStyle,
    contentPadding: EdgeInsets.all(16.h),
    enabledBorder: borderStyle,
    disabledBorder: borderStyle,
    border: borderStyle,
    focusedBorder: borderStyle,
    labelStyle: TextStyle(
        color: const Color(0xFFC4C4C4),
        fontFamily: 'Roboto',
        fontSize: 20.0.sp));