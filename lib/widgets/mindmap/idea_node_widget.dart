import 'package:emoapp/model/idea.dart';
import 'package:flutter/material.dart';

/// Widget representing a single idea node on the mindmap canvas
class IdeaNodeWidget extends StatelessWidget {
  const IdeaNodeWidget({
    Key? key,
    required this.idea,
    this.isSelected = false,
    this.isMoving = false,
  }) : super(key: key);

  final Idea idea;
  final bool isSelected;
  final bool isMoving;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.blue : Colors.white,
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey,
          width: isSelected ? 3 : 2,
        ),
        boxShadow: [
          if (isSelected || isMoving)
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Expanded(
                  child: Center(
                    child: Text(
                      idea.title,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Reference count badge
                if (idea.references.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${idea.references.length}',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.orange : Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Moving indicator
          if (isMoving)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
