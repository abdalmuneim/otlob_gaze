import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/validator.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/widget/custom_text_field.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField(
      {super.key, required this.controller, this.isEditMode = false});
  final TextEditingController controller;
  final bool isEditMode;
  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isObscure = true;
  toggleObscure() {
    isObscure = !isObscure;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      // suffixIcon:
      //     IconButton(icon: const Icon(Icons.visibility), onPressed: () {}),
      prefixText: '     ',
      prefixIcon: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[300],
          child: SvgPicture.asset(Assets.activeSecretIC)),
      isObscure: isObscure,
      hintText: Utils.localization?.writePass ?? "",
      textEditingController: widget.controller,
      validator: (value) {
        if (value!.isEmpty && widget.isEditMode) {
          return null;
        }
        return AppValidator.validateFields(
            value, ValidationType.password, context);
      },
    );
  }
}
