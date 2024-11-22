class ShortListModel {
  final int id;
  final String whouse_address;
  final String whouseType1;
  final String whouseType2;
  final int whouseFloor;
  final num whouseCarperArea; // Handles both int and double
  final num warehouseCarpetArea; // Handles both int and double
  final num whouseRent; // Handles both int and double
  final String whouseMaintenance;
  final String whouseExpected;
  final String whouseToken;
  final String whouseLockIn;
  final String whouseName;
  final String filePath;
  final String mobile;
  final String image;
  final String type;
  final bool isAvailable; // Changed to bool for clarity

  ShortListModel({
    this.id = 0,
    this.whouse_address = "",
    this.whouseType1 = "",
    this.whouseType2 = "",
    this.whouseFloor = 0,
    this.whouseCarperArea = 0.0,
    this.warehouseCarpetArea = 0.0,
    this.whouseRent = 0.0,
    this.whouseMaintenance = "",
    this.whouseExpected = "",
    this.whouseToken = "",
    this.whouseLockIn = "",
    this.whouseName = "",
    this.filePath = "",
    this.mobile = "",
    this.image = "",
    this.type = "",
    this.isAvailable = false,
  });

  factory ShortListModel.fromJson(Map<String, dynamic> json) {
    return ShortListModel(
      id: json['id'] ?? 0,
      whouse_address: json['whouse_address'] ?? "",
      whouseType1: json['whouse_type1'] ?? "",
      whouseType2: json['whouse_type2'] ?? "",
      whouseFloor: json['whouse_floor'] ?? 0,
      whouseCarperArea: json['whouse_carperarea']?.toDouble() ?? 0.0,
      warehouseCarpetArea: json['warehouse_carpetarea']?.toDouble() ?? 0.0,
      whouseRent: json['whouse_rent']?.toDouble() ?? 0.0,
      whouseMaintenance: json['whouse_maintenance'] ?? "",
      whouseExpected: json['whouse_expected'] ?? "",
      whouseToken: json['whouse_token'] ?? "",
      whouseLockIn: json['whouse_lockin'] ?? "",
      whouseName: json['whouse_name'] ?? "",
      filePath: json['filepath'] ?? "",
      mobile: json['mobile'] ?? "",
      image: json['image'] ?? "",
      type: json['type'] ?? "",
      isAvailable: (json['isavilable'] ?? 0) == 1, // Treat 1 as true, 0 as false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'whouse_address': whouse_address,
      'whouse_type1': whouseType1,
      'whouse_type2': whouseType2,
      'whouse_floor': whouseFloor,
      'whouse_carperarea': whouseCarperArea,
      'warehouse_carpetarea': warehouseCarpetArea,
      'whouse_rent': whouseRent,
      'whouse_maintenance': whouseMaintenance,
      'whouse_expected': whouseExpected,
      'whouse_token': whouseToken,
      'whouse_lockin': whouseLockIn,
      'whouse_name': whouseName,
      'filepath': filePath,
      'mobile': mobile,
      'image': image,
      'type': type,
      'isavilable': isAvailable ? 1 : 0,
    };
  }
}
