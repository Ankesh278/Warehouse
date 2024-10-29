class interestedModel {
  final int id;
  final double distance;
  final double latitude;
  final double longitude;
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
  //final String type;

  interestedModel({
    required this.id,
    required this.distance,
    required this.latitude,
    required this.longitude,
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
   // required this.type,
  });

  factory interestedModel.fromJson(Map<String, dynamic> json) {
    return interestedModel(
      id: json['id'],
      distance: (json['distance'] as num).toDouble(), // Casting to double
      latitude: (json['latitude'] as num).toDouble(), // Casting to double
      longitude: (json['longitude'] as num).toDouble(), // Casting to double
      whouseType1: json['whouse_type1'],
      whouseType2: json['whouse_type2'],
      whouseFloor: json['whouse_floor'],
      whouseCarperArea: (json['whouse_carperarea'] as num).toDouble(), // Casting to double
      warehouseCarpetArea: (json['warehouse_carpetarea'] as num).toDouble(), // Casting to double
      isAvailable: json['isavilable'],
      whouseRent: (json['whouse_rent'] as num).toDouble(), // Casting to double
      whouseMaintenance: json['whouse_maintenance'],
      whouseExpected: json['whouse_expected'],
      whouseToken: json['whouse_token'],
      whouseLockIn: json['whouse_lockin'],
      whouseName: json['whouse_name'],
      filePath: json['filepath'],
      mobile: json['mobile'],
      image: json['image'],
     // type: json['type'],
    );
  }
}
