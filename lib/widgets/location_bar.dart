import 'package:flutter/material.dart';

class LocationBar extends StatelessWidget implements PreferredSizeWidget {
  final String location;
  final String country;

  const LocationBar({
    super.key,
    required this.location,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(Icons.location_on_outlined, color: Color(0xFF006A56)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            country,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black54),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
