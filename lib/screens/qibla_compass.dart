import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import 'dart:math' as math; 

class QiblaCompassScreen extends StatefulWidget {
  const QiblaCompassScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QiblaCompassScreenState createState() => _QiblaCompassScreenState();
}

class _QiblaCompassScreenState extends State<QiblaCompassScreen> {
  bool _isLoading = true;
  String? _error;
  double? _qiblaDirection;

  @override
  void initState() {
    super.initState();
    _initQiblaCompass();
  }

  Future<void> _initQiblaCompass() async {
    try {
      // 1. Check and request location permissions
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() {
            _error = "Location permission is required to find the Qibla.";
            _isLoading = false;
          });
          return;
        }
      }

      // 2. Get user's current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final coordinates = Coordinates(position.latitude, position.longitude);

      // 3. Calculate Qibla direction using the adhan package
      final qibla = Qibla(coordinates).direction;

      setState(() {
        _qiblaDirection = qibla;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to get Qibla direction: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.teal));
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    // If we have the Qibla direction, listen to the compass stream
    return _buildCompass();
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error reading compass: ${snapshot.error}",
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.teal),
                SizedBox(height: 10),
                Text("Calibrating compass..."),
              ],
            ),
          );
        }

        double? deviceHeading = snapshot.data!.heading;

        // If compass data is null (e.g., no sensor)
        if (deviceHeading == null) {
          return const Center(
            child: Text(
              "Your device does not have a compass sensor.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          );
        }
        
        // This is the magic!
        // We calculate the angle to rotate the Kaaba icon.
        // It's the difference between the Qibla direction and the device's heading.
        double relativeAngle = (_qiblaDirection! - deviceHeading);
        
        // Convert to radians for the Transform.rotate widget
        double relativeAngleRadians = relativeAngle * (math.pi / 180.0);

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "কিবলা",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${_qiblaDirection!.toStringAsFixed(2)}° N",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),

              // The Compass UI
              SizedBox(
                width: 300,
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Simple compass background
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300, width: 4),
                      ),
                    ),
                    // "N" for North
                    const Positioned(
                      top: 10,
                      child: Text("N", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                    ),
                    // "S" for South
                    const Positioned(
                      bottom: 10,
                      child: Text("S", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
                    ),
                    // "E" for East
                    const Positioned(
                      right: 10,
                      child: Text("E", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
                    ),
                    // "W" for West
                    const Positioned(
                      left: 10,
                      child: Text("W", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
                    ),

                    // The Qibla Needle
                    // This rotates to point to the Qibla
                    Transform.rotate(
                      angle: relativeAngleRadians,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.mosque, // Using a Mosque icon for Kaaba
                            size: 60,
                            color: Colors.teal,
                          ),
                          Container( // The "needle" part
                            width: 4,
                            height: 80,
                            color: Colors.teal,
                          ),
                        ],
                      ),
                    ),

                    // This rotates to show the device's heading
                    Transform.rotate(
                      angle: (deviceHeading * -1) * (math.pi / 180.0), // Rotate north pole
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           // Arrow pointing North
                           Icon(Icons.navigation, color: Colors.red, size: 40),
                           SizedBox(height: 110), // Points opposite
                        ],
                      ),
                    ),


                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "লাল তীরটি উত্তর দিকে নির্দেশ করে। সবুজ আইকনটি কিবলার দিক নির্দেশ করে।",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}