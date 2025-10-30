import 'package:adhan/adhan.dart';

/// প্রতিটি জেলার নাম এবং তার স্থানাঙ্ক ধারণ করার জন্য একটি ক্লাস।
class DistrictLocation {
  final String name;
  final Coordinates coordinates;

  const DistrictLocation({required this.name, required this.coordinates});
}

/// বাংলাদেশের জেলাসমূহের তালিকা (নমুনা)
/// দ্রষ্টব্য: এখানে কয়েকটি জেলা যোগ করা হয়েছে। আপনি সব জেলার স্থানাঙ্ক যোগ করতে পারেন।
List<DistrictLocation> bangladeshDistricts = [
  DistrictLocation(name: "Dhaka", coordinates: Coordinates(23.8103, 90.4125)),
  DistrictLocation(name: "Barisal", coordinates: Coordinates(22.7010, 90.3535)),
  DistrictLocation(name: "Chittagong", coordinates: Coordinates(22.3569, 91.7832)),
  DistrictLocation(name: "Khulna", coordinates: Coordinates(22.8456, 89.5403)),
  DistrictLocation(name: "Rajshahi", coordinates: Coordinates(24.3745, 88.6042)),
  DistrictLocation(name: "Sylhet", coordinates: Coordinates(24.8949, 91.8687)),
  DistrictLocation(name: "Rangpur", coordinates: Coordinates(25.7439, 89.2752)),
  DistrictLocation(name: "Mymensingh", coordinates: Coordinates(24.7471, 90.4203)),
  DistrictLocation(name: "Comilla", coordinates: Coordinates(23.4607, 91.1809)),
  DistrictLocation(name: "Cox's Bazar", coordinates: Coordinates(21.4272, 92.0058)),
];
