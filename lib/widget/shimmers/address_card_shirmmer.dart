import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AddressCardShirmmer extends StatelessWidget {
  const AddressCardShirmmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        child: SizedBox(
          height: 160,
          width: double.infinity,
        )
      ),
    );
  }
}
