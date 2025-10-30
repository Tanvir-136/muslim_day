import 'package:flutter/material.dart';

class LocationBar extends StatelessWidget {
  final String location;
  final String country;
  final VoidCallback onLocationPressed; // <-- 1. Add callback
  final bool isLoading; // <-- 2. Add loading state

  const LocationBar({
    super.key,
    required this.location,
    required this.country,
    required this.onLocationPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, color: Color(0xFF1D9375), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                // 3. Use location from parameter
                Text(
                  location,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 4. Add GPS button
          IconButton(
            icon: isLoading 
                ? SizedBox( // Show loading indicator
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.teal)
                  )
                : const Icon( // Show location icon
                    Icons.my_location, 
                    color: Colors.grey, 
                    size: 24
                  ),
            onPressed: isLoading ? null : onLocationPressed, // Disable button when loading
            tooltip: "Detect Current Location",
          ),
        ],
      ),
    );
  }
}
