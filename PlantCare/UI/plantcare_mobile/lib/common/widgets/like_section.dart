import 'package:flutter/material.dart';

class LikeSection extends StatefulWidget {
  final bool initialLiked;
  final int initialBrojLajkova;
  final Future<bool> Function() onToggleLike;

  const LikeSection({
    super.key,
    required this.initialLiked,
    required this.initialBrojLajkova,
    required this.onToggleLike,
  });

  @override
  State<LikeSection> createState() => _LikeSectionState();
}

class _LikeSectionState extends State<LikeSection> {
  late bool liked;
  late int brojLajkova;

  @override
  void initState() {
    super.initState();
    liked = widget.initialLiked;
    brojLajkova = widget.initialBrojLajkova;
  }

  void _handleLike() async {
    final success = await widget.onToggleLike();
    if (!mounted) return;

    setState(() {
      liked = success ? !liked : liked;
      brojLajkova += success ? (liked ? 1 : -1) : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.favorite, color: liked ? Colors.green : Colors.grey),
          onPressed: _handleLike,
        ),
        Text('$brojLajkova'),
      ],
    );
  }
}
