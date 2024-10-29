class InteretedModel {
  final int id;
  final double? distance; // Distance may be null
  final double? latitude; // Latitude may be null
  final double? longitude; // Longitude may be null
  final String whouseType1;
  final String whouseType2;
  final int whouseFloor;
  final double whouseCarperArea;
  final double warehouseCarpetArea;
  final int isAvailable;
  final double whouseRent;
  final String whouseMaintenance;
  final String whouseExpected;
  final String whouseToken;
  final String whouseLockIn;
  final String whouseName;
  final String filePath;
  final String mobile;
  final String image;
  final String type;
  final String whouse_address;

  InteretedModel({
    required this.id,
    this.distance,
    this.latitude,
    this.longitude,
    required this.whouseType1,
    required this.whouseType2,
    required this.whouseFloor,
    required this.whouseCarperArea,
    required this.warehouseCarpetArea,
    required this.isAvailable,
    required this.whouseRent,
    required this.whouseMaintenance,
    required this.whouseExpected,
    required this.whouseToken,
    required this.whouseLockIn,
    required this.whouseName,
    required this.filePath,
    required this.mobile,
    required this.image,
    required this.type,
    required this.whouse_address
  });

  factory InteretedModel.fromJson(Map<String, dynamic> json) {
    return InteretedModel(
      id: json['id'] ?? 0, // Default to 0 if null
      distance: json['distance'] != null ? (json['distance'] as num).toDouble() : null, // Handle null for distance
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null, // Handle null for latitude
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null, // Handle null for longitude
      whouseType1: json['whouse_type1'] ?? '',
      whouseType2: json['whouse_type2'] ?? '',
      whouseFloor: json['whouse_floor'] ?? 0, // Default to 0 if null
      whouseCarperArea: (json['whouse_carperarea'] as num?)?.toDouble() ?? 0.0, // Handle null and cast to double
      warehouseCarpetArea: (json['warehouse_carpetarea'] as num?)?.toDouble() ?? 0.0, // Handle null and cast to double
      isAvailable: json['isavilable'] ?? 0, // Default to 0 if null
      whouseRent: (json['whouse_rent'] as num?)?.toDouble() ?? 0.0, // Handle null and cast to double
      whouseMaintenance: json['whouse_maintenance'] ?? '',
      whouseExpected: json['whouse_expected'] ?? '',
      whouseToken: json['whouse_token'] ?? '',
      whouseLockIn: json['whouse_lockin'] ?? '',
      whouseName: json['whouse_name'] ?? '',
      filePath: json['filepath'] ?? '',
      mobile: json['mobile'] ?? '',
      image: json['image'] ?? '',
      type: json['type'] ?? '',
      whouse_address: json['whouse_address'] ?? '',
    );
  }
}
