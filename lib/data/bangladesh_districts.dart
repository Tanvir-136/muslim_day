import 'package:adhan/adhan.dart';

/// প্রতিটি জেলার নাম এবং তার স্থানাঙ্ক ধারণ করার জন্য একটি ক্লাস।
class DistrictLocation {
  final String name;
  final Coordinates coordinates;

  const DistrictLocation({required this.name, required this.coordinates});
}

/// বাংলাদেশের সকল জেলার তালিকা
List<DistrictLocation> bangladeshDistricts = <DistrictLocation>[
  // Dhaka Division (ঢাকা বিভাগ)
  DistrictLocation(name: "Dhaka", coordinates: Coordinates(23.8103, 90.4125)),
  DistrictLocation(name: "Faridpur", coordinates: Coordinates(23.6071, 89.8428)),
  DistrictLocation(name: "Gazipur", coordinates: Coordinates(24.0958, 90.4125)),
  DistrictLocation(name: "Gopalganj", coordinates: Coordinates(23.0082, 89.8267)),
  DistrictLocation(name: "Jamalpur", coordinates: Coordinates(24.9113, 89.9481)),
  DistrictLocation(name: "Kishoreganj", coordinates: Coordinates(24.4260, 90.7765)),
  DistrictLocation(name: "Madaripur", coordinates: Coordinates(23.1641, 90.1896)),
  DistrictLocation(name: "Manikganj", coordinates: Coordinates(23.8617, 90.0047)),
  DistrictLocation(name: "Munshiganj", coordinates: Coordinates(23.5422, 90.5305)),
  DistrictLocation(name: "Mymensingh", coordinates: Coordinates(24.7471, 90.4203)),
  DistrictLocation(name: "Narayanganj", coordinates: Coordinates(23.6238, 90.5000)),
  DistrictLocation(name: "Narsingdi", coordinates: Coordinates(23.9223, 90.7154)),
  DistrictLocation(name: "Netrokona", coordinates: Coordinates(24.8103, 90.8656)),
  DistrictLocation(name: "Rajbari", coordinates: Coordinates(23.7584, 89.6447)),
  DistrictLocation(name: "Shariatpur", coordinates: Coordinates(23.2100, 90.3378)),
  DistrictLocation(name: "Sherpur", coordinates: Coordinates(25.0205, 90.0150)),
  DistrictLocation(name: "Tangail", coordinates: Coordinates(24.2513, 89.9167)),

  // Chittagong Division (চট্টগ্রাম বিভাগ)
  DistrictLocation(name: "Bandarban", coordinates: Coordinates(22.1933, 92.2190)),
  DistrictLocation(name: "Brahmanbaria", coordinates: Coordinates(23.9608, 91.1115)),
  DistrictLocation(name: "Chandpur", coordinates: Coordinates(23.2307, 90.6521)),
  DistrictLocation(name: "Chittagong", coordinates: Coordinates(22.3569, 91.7832)),
  DistrictLocation(name: "Comilla", coordinates: Coordinates(23.4607, 91.1809)),
  DistrictLocation(name: "Cox's Bazar", coordinates: Coordinates(21.4272, 92.0058)),
  DistrictLocation(name: "Feni", coordinates: Coordinates(23.0159, 91.3976)),
  DistrictLocation(name: "Khagrachhari", coordinates: Coordinates(23.1193, 91.9840)),
  DistrictLocation(name: "Lakshmipur", coordinates: Coordinates(22.9447, 90.8282)),
  DistrictLocation(name: "Noakhali", coordinates: Coordinates(22.8698, 91.0974)),
  DistrictLocation(name: "Rangamati", coordinates: Coordinates(22.6324, 92.2985)),

  // Rajshahi Division (রাজশাহী বিভাগ)
  DistrictLocation(name: "Bogra", coordinates: Coordinates(24.8488, 89.3720)),
  DistrictLocation(name: "Joypurhat", coordinates: Coordinates(25.0947, 89.0228)),
  DistrictLocation(name: "Naogaon", coordinates: Coordinates(24.7936, 88.9318)),
  DistrictLocation(name: "Natore", coordinates: Coordinates(24.4090, 89.0061)),
  DistrictLocation(name: "Chapai Nawabganj", coordinates: Coordinates(24.5917, 88.2775)),
  DistrictLocation(name: "Pabna", coordinates: Coordinates(24.0046, 89.2495)),
  DistrictLocation(name: "Rajshahi", coordinates: Coordinates(24.3745, 88.6042)),
  DistrictLocation(name: "Sirajganj", coordinates: Coordinates(24.4551, 89.7022)),

  // Khulna Division (খুলনা বিভাগ)
  DistrictLocation(name: "Bagerhat", coordinates: Coordinates(22.6602, 89.7895)),
  DistrictLocation(name: "Chuadanga", coordinates: Coordinates(23.6433, 88.8522)),
  DistrictLocation(name: "Jessore", coordinates: Coordinates(23.1634, 89.2042)),
  DistrictLocation(name: "Jhenaidah", coordinates: Coordinates(23.5437, 89.1725)),
  DistrictLocation(name: "Khulna", coordinates: Coordinates(22.8456, 89.5403)),
  DistrictLocation(name: "Kushtia", coordinates: Coordinates(23.9089, 89.1220)),
  DistrictLocation(name: "Magura", coordinates: Coordinates(23.4873, 89.4199)),
  DistrictLocation(name: "Meherpur", coordinates: Coordinates(23.7720, 88.6318)),
  DistrictLocation(name: "Narail", coordinates: Coordinates(23.1724, 89.5039)),
  DistrictLocation(name: "Satkhira", coordinates: Coordinates(22.7185, 89.0705)),

  // Barisal Division (বরিশাল বিভাগ)
  DistrictLocation(name: "Barguna", coordinates: Coordinates(22.1566, 90.1208)),
  DistrictLocation(name: "Barisal", coordinates: Coordinates(22.7010, 90.3535)),
  DistrictLocation(name: "Bhola", coordinates: Coordinates(22.6859, 90.6482)),
  DistrictLocation(name: "Jhalokati", coordinates: Coordinates(22.6403, 90.1980)),
  DistrictLocation(name: "Patuakhali", coordinates: Coordinates(22.3582, 90.3206)),
  DistrictLocation(name: "Pirojpur", coordinates: Coordinates(22.5843, 89.9719)),

  // Sylhet Division (সিলেট বিভাগ)
  DistrictLocation(name: "Habiganj", coordinates: Coordinates(24.379 , 91.4178)),
  DistrictLocation(name: "Moulvibazar", coordinates: Coordinates(24.4829, 91.7692)),
  DistrictLocation(name: "Sunamganj", coordinates: Coordinates(25.0715, 91.3992)),
  DistrictLocation(name: "Sylhet", coordinates: Coordinates(24.8949, 91.8687)),

  // Rangpur Division (রংপুর বিভাগ)
  DistrictLocation(name: "Dinajpur", coordinates: Coordinates(25.6279, 88.6332)),
  DistrictLocation(name: "Gaibandha", coordinates: Coordinates(25.3297, 89.5424)),
  DistrictLocation(name: "Kurigram", coordinates: Coordinates(25.8072, 89.6295)),
  DistrictLocation(name: "Lalmonirhat", coordinates: Coordinates(25.9923, 89.2847)),
  DistrictLocation(name: "Nilphamari", coordinates: Coordinates(25.9388, 88.8447)),
  DistrictLocation(name: "Panchagarh", coordinates: Coordinates(26.3411, 88.5542)),
  DistrictLocation(name: "Rangpur", coordinates: Coordinates(25.7439, 89.2752)),
  DistrictLocation(name: "Thakurgaon", coordinates: Coordinates(26.0418, 88.4283)),
];