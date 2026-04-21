import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.title,
    required this.prize,
    required this.imageUrl,
    required this.company,
    required this.backgroundColor,
  });

  final String title;
  final double prize;
  final String imageUrl;
  final String company;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.orange[200],
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 5),
          Text(
            prize.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 8),
          Center(child: Image.asset(imageUrl, height: 275)),
        ],
      ),
    );
  }
}