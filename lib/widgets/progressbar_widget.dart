import 'package:flutter/material.dart';

class ProgressbarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(10, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            color:
                index == 7 ? Colors.blue : Colors.grey, // 7. seviyeyi işaret et
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
