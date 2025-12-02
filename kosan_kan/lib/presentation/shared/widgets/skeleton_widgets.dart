import 'package:flutter/material.dart';

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    Key? key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

Widget featuredSkeletonRow() {
  return SizedBox(
    height: 180,
    child: ListView.separated(
      padding: const EdgeInsets.only(left: 16, right: 12),
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.78,
          margin: EdgeInsets.only(left: index == 0 ? 0 : 0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    ),
  );
}

Widget gridSkeleton(BuildContext context, {int count = 4}) {
  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    itemCount: count,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.72,
    ),
    itemBuilder: (_, __) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(height: 110, borderRadius: BorderRadius.circular(12)),
          const SizedBox(height: 8),
          SkeletonBox(
            height: 14,
            width: 120,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(height: 6),
          SkeletonBox(
            height: 12,
            width: 80,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    },
  );
}

Widget listCardSkeleton(BuildContext context, {int count = 3}) {
  return ListView.separated(
    padding: const EdgeInsets.only(top: 12, bottom: 16),
    itemCount: count,
    separatorBuilder: (_, __) => const SizedBox(height: 8),
    itemBuilder: (_, __) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SkeletonBox(
              height: 90,
              width: 110,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(
                    height: 14,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 8),
                  SkeletonBox(
                    height: 12,
                    width: 140,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SkeletonBox(
                        height: 12,
                        width: 60,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(width: 8),
                      SkeletonBox(
                        height: 28,
                        width: 80,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
