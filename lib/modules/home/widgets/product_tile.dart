import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? tag;
  final String text;
  final VoidCallback? fn;
  final VoidCallback? suffixFn;

  const ProductTile({
    super.key,
    required this.prefixIcon,
    this.suffixIcon,
    this.tag,
    required this.text,
    this.fn,
    this.suffixFn,
  });

  @override
  Widget build(BuildContext context) {
    Widget suffixWdt = const SizedBox.shrink();
    if (suffixIcon != null) {
      if (suffixFn != null) {
        suffixWdt = InkWell(
          customBorder: const CircleBorder(),
          onTap: suffixFn,
          child: Center(child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: FittedBox(child: suffixIcon),
          )),
        );
      } else {
        suffixWdt = suffixIcon!;
      }

      suffixWdt = Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: suffixWdt,
        ),
      );
    }

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
            if(tag != null)
              tag!,
            suffixWdt,
          ],
        ),
      ),
    );
  }
}
