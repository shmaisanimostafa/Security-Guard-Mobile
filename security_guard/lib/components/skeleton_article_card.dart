import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonArticleCard extends StatelessWidget {
  const SkeletonArticleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 100,
              width: 100,
              color: Colors.grey[300], // Placeholder color
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 20,
                  width: double.infinity,
                  color: Colors.grey[300], // Placeholder color
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey, // Placeholder color
                      ),
                    ),
                    const SizedBox(width: 5),
                    Row(
                      children: [
                        Container(
                          height: 15,
                          width: 80,
                          color: Colors.grey[300], // Placeholder color
                        ),
                        const SizedBox(width: 5),
                        Container(
                          height: 15,
                          width: 15,
                          color: Colors.grey[300], // Placeholder color
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 15,
                      width: 60,
                      color: Colors.grey[300], // Placeholder color
                    ),
                    Container(
                      height: 24,
                      width: 24,
                      color: Colors.grey[300], // Placeholder color
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}