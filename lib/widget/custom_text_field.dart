import 'package:flutter/material.dart';
import 'package:otlob_gas/common/constants/validator.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      this.prefixIcon,
      this.hintText,
      this.labelText,
      this.prefixText,
      this.validator,
      this.suffixIcon,
      this.isMultiLine = false,
      this.expands = false,
      this.isObscure = false,
      this.textEditingController,
      this.hintStyle,
      this.prefixIconConstraints,
      this.isNumberOnly = false,
      this.onTap,
      this.onChanged,
      this.readOnly = false})
      : super(key: key);
  final Widget? prefixIcon;
  final String? hintText;
  final Widget? labelText;
  final String? prefixText;
  final String? Function(String?)? validator;
  final bool isMultiLine;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  final BoxConstraints? prefixIconConstraints;
  final bool isNumberOnly;
  final TextEditingController? textEditingController;
  final Function(String)? onChanged;
  final GestureTapCallback? onTap;
  final bool? readOnly;
  final bool expands;
  final bool isObscure;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: isMultiLine ? null : 1,
      minLines: isMultiLine ? 4 : null,
      validator: validator,
      controller: textEditingController,
      expands: expands,
      readOnly: readOnly!,
      obscureText: isObscure,
      onChanged: onChanged,
      onTap: onTap,
      keyboardType: isNumberOnly
          ? const TextInputType.numberWithOptions(decimal: true)
          : null,
      inputFormatters: [if (isNumberOnly) AppValidator.priceValueOnly()],
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          errorStyle: Theme.of(context).textTheme.labelMedium,
          hintText: hintText,
          label: labelText,
          hintStyle: hintStyle ??
              Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(
              horizontal: isMultiLine ? 10 : 5,
              vertical: isMultiLine ? 5.0 : 0),
          prefixIcon: prefixIcon,
          prefixIconConstraints: prefixIconConstraints,
          prefixText: prefixText ?? "",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isMultiLine ? 10 : 70)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(isMultiLine ? 10 : 70))),
    );
  }
}
