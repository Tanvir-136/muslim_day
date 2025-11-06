import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For haptic feedback (vibration)
import 'package:shared_preferences/shared_preferences.dart';

class TasbeehCounterScreen extends StatefulWidget {
  const TasbeehCounterScreen({Key? key}) : super(key: key);

  @override
  _TasbeehCounterScreenState createState() => _TasbeehCounterScreenState();
}

class _TasbeehCounterScreenState extends State<TasbeehCounterScreen> {
  int _currentCount = 0;
  int _totalCount = 0;
  int _targetCount = 33;
  
  late SharedPreferences _prefs;

  // Key for saving the total count
  static const String _totalCountKey = 'tasbeeh_total_count';

  @override
  void initState() {
    super.initState();
    _loadTotalCount();
  }

  // Load the persistent total count from storage
  Future<void> _loadTotalCount() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalCount = _prefs.getInt(_totalCountKey) ?? 0;
    });
  }

  // Increment the count and save the total
  Future<void> _incrementCount() async {
    // Vibrate gently
    HapticFeedback.lightImpact();

    setState(() {
      _currentCount++;
      _totalCount++;
    });

    // Save the new total
    await _prefs.setInt(_totalCountKey, _totalCount);

    // Vibrate strongly when the target is reached
    if (_currentCount == _targetCount) {
      HapticFeedback.mediumImpact();
    }
  }

  // Reset only the current session count
  void _resetCurrentCount() {
    setState(() {
      _currentCount = 0;
    });
    HapticFeedback.heavyImpact();
  }

  // Set a new target and reset the current count
  void _setTarget(int newTarget) {
    setState(() {
      _targetCount = newTarget;
      _currentCount = 0; // Reset current count when target changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("তাসবীহ কাউন্টার"), // পরিবর্তিত
        backgroundColor: Colors.teal, // Match your app theme
      ),
      body: Column(
        children: [
          // --- Display Area ---
          Container(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCountDisplay("মোট", _totalCount.toString()), // পরিবর্তিত
                _buildCountDisplay("লক্ষ্য", _targetCount.toString()), // পরিবর্তিত
              ],
            ),
          ),

          // --- Main Tap Button ---
          Expanded(
            child: GestureDetector(
              onTap: _incrementCount,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal.shade50,
                  border: Border.all(color: Colors.teal, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    _currentCount.toString(),
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // --- Controls Area ---
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Reset Button
                FloatingActionButton(
                  onPressed: _resetCurrentCount,
                  backgroundColor: Colors.red.shade100,
                  child: const Icon(Icons.refresh, color: Colors.red),
                  heroTag: 'reset', // Unique hero tag
                ),
                
                // Target Buttons
                Row(
                  children: [
                    _buildTargetChip(33),
                    const SizedBox(width: 8),
                    _buildTargetChip(99),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for displaying "Total" and "Target"
  Widget _buildCountDisplay(String label, String value) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            color: Colors.teal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Helper widget for the 33/99 target chips
  Widget _buildTargetChip(int target) {
    bool isSelected = _targetCount == target;
    return ChoiceChip(
      label: Text('$target'),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _setTarget(target);
        }
      },
      selectedColor: Colors.teal,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.teal,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.teal.shade50,
      shape: StadiumBorder(
        side: BorderSide(color: Colors.teal.shade200),
      ),
    );
  }
}