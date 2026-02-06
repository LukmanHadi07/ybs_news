import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpInputBox extends StatelessWidget {
  const OtpInputBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isLast,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLast;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.w,
      height: 56.h,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.visiblePassword,
        textCapitalization: TextCapitalization.characters,
        maxLines: 1,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          height: 1.0,
        ),

        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
          LengthLimitingTextInputFormatter(1),
        ],
        textInputAction: isLast ? TextInputAction.done : TextInputAction.next,

        decoration: InputDecoration(
          counterText: '',
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
