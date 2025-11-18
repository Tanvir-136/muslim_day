import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  // Properties for the main card type
  final String title;
  final String? content;
  final bool hasInfoIcon;
  final bool isSimple;

  // Properties for the Sehri/Iftar card type
  final String? time;
  final bool isCountdown;

  // Main constructor for the grid cards
  const InfoCard({
    super.key,
    required this.title,
    this.content,
    this.hasInfoIcon = false,
    this.isSimple = false,
  })  : time = null,
        isCountdown = false;

  // Named constructor for creating the Sehri/Iftar style card
  const InfoCard.sehriIftar({
    super.key,
    required this.title,
    required this.time,
    this.isCountdown = false,
  })  : content = null,
        hasInfoIcon = false,
        isSimple = false;

  @override
  Widget build(BuildContext context) {
    // If 'time' is not null, we build the special Sehri/Iftar card.
    // Otherwise, we build the regular info card.
    if (time != null) {
      return _buildSehriIftarCard();
    } else {
      return _buildGridCard();
    }
  }

  // Helper method to build the regular info card
  Widget _buildGridCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isSimple ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (hasInfoIcon) const Icon(Icons.info_outline, color: Colors.black54, size: 18),
            ],
          ),
          if (!isSimple && content != null) ...[
            const SizedBox(height: 8),
            Text(
              content!,
              style: const TextStyle(color: Colors.black54, fontSize: 12, height: 1.5),
            ),
          ]
        ],
      ),
    );
  }


  Widget _buildSehriIftarCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black87), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            time!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isCountdown ? const Color(0xFFD32F2F) : const Color(0xFF1D9375),
            ),
          ),
          const SizedBox(height: 8),
          Text('অ্যালার্ম', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }
}