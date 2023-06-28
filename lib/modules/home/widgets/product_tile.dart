import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final Widget? prefixIcon;
  final String text;
  final VoidCallback? fn;

  const ProductTile({
    super.key,
    required this.prefixIcon,
    required this.text,
    this.fn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: fn,
        child: Row(
          children: [
            if (prefixIcon != null)
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: prefixIcon,
                ),
              ),
            // prefixIcon ?? const SizedBox.shrink(),
            const SizedBox(width: 8.0),
            Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
