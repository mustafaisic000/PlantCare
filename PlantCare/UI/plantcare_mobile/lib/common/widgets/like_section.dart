import 'package:flutter/material.dart';

class LikeSection extends StatelessWidget {
  final bool liked;
  final int brojLajkova;
  final VoidCallback onToggleLike;

  const LikeSection({
    super.key,
    required this.liked,
    required this.brojLajkova,
    required this.onToggleLike,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.favorite, color: liked ? Colors.green : Colors.grey),
          onPressed: onToggleLike,
        ),
        Text('$brojLajkova'),
      ],
    );
  }
}
