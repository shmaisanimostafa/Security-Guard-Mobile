import 'package:flutter/material.dart';

class SkeletonArticleCard extends StatelessWidget {
  const SkeletonArticleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for image
            Container(
              width: double.infinity,
              height: 150,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            // Placeholder for title
            Container(
              width: double.infinity,
              height: 20,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            // Placeholder for author and date
            Row(
              children: [
                Container(
                  width: 100,
                  height: 15,
                  color: Colors.grey[300],
                ),
                const Spacer(),
                Container(
                  width: 50,
                  height: 15,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}