import 'package:flutter/material.dart';

class ProductField extends StatelessWidget {
  final TextEditingController fieldCtrl;
  final Widget? prefixIcon;
  final String? label;
  final String? hint;

  const ProductField({
    super.key,
    required this.fieldCtrl,
    this.label,
    this.hint,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            // textInputAction: TextInputAction.search,
            maxLines: null,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: prefixIcon,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: fieldCtrl.clear,
              ),
            ),
            // textAlign: TextAlign.center,
            controller: fieldCtrl,
            // onSubmitted: (_) {},
          ),
        )
      ],
    );
  }
}