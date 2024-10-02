import 'dart:convert';

class Warehouse {
  final int id;
  final String whouseAddress;
  final String whouseType1;
  final String whouseType2;
  final int whouseFloor;
  final int whouseCarpetArea;
  final bool isAvailable;
  final int whouseRent;
  final String whouseMaintenance;
  final String whouseExpected;
  final String whouseToken;
  final String whouseLockin;
  final String whouseName;
  final String whouseImg1;
  final String whouseImg2;
  final String whouseVid1;
  final String whouseVid2;
  final String mobile;
  final DateTime dateTime;

  Warehouse({
    this.id = 0, // Default value for int
    this.whouseAddress = '', // Default value for String
    this.whouseType1 = '',
    this.whouseType2 = '',
    this.whouseFloor = 0, // Default value for int
    this.whouseCarpetArea = 0, // Default value for int
    this.isAvailable = false, // Default value for bool
    this.whouseRent = 0, // Default value for int
    this.whouseMaintenance = '', // Default value for String
    this.whouseExpected = '', // Default value for String
    this.whouseToken = '', // Default value for String
    this.whouseLockin = '', // Default value for String
    this.whouseName = '', // Default value for String
    this.whouseImg1 = '', // Default value for String
    this.whouseImg2 = '', // Default value for String
    this.whouseVid1 = '', // Default value for String
    this.whouseVid2 = '', // Default value for String
    this.mobile = '', // Default value for String
    DateTime? dateTime, // DateTime initialized below
  }) : dateTime = dateTime ?? DateTime.now(); // Default to current time

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'] ?? 0,
      whouseAddress: json['whouse_address'] ?? '',
      whouseType1: json['whouse_type1'] ?? '',
      whouseType2: json['whouse_type2'] ?? '',
      whouseFloor: json['whouse_floor'] ?? 0,
      whouseCarpetArea: json['whouse_carperarea'] ?? 0,
      isAvailable: json['is_available'] ?? false,
      whouseRent: json['whouse_rent'] ?? 0,
      whouseMaintenance: json['whouse_maintenance'] ?? '',
      whouseExpected: json['whouse_expected'] ?? '',
      whouseToken: json['whouse_token'] ?? '',
      whouseLockin: json['whouse_lockin'] ?? '',
      whouseName: json['whouse_name'] ?? '',
      whouseImg1: json['whouse_img1'] ?? '',
      whouseImg2: json['whouse_img_2'] ?? '',
      whouseVid1: json['whouse_vid1'] ?? '',
      whouseVid2: json['whouse_vid2'] ?? '',
      mobile: json['mobile'] ?? '',
      dateTime: json['dateTime'] != null ? DateTime.parse(json['dateTime']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'whouse_address': whouseAddress,
      'whouse_type1': whouseType1,
      'whouse_type2': whouseType2,
      'whouse_floor': whouseFloor,
      'whouse_carperarea': whouseCarpetArea,
      'is_available': isAvailable,
      'whouse_rent': whouseRent,
      'whouse_maintenance': whouseMaintenance,
      'whouse_expected': whouseExpected,
      'whouse_token': whouseToken,
      'whouse_lockin': whouseLockin,
      'whouse_name': whouseName,
      'whouse_img1': whouseImg1,
      'whouse_img_2': whouseImg2,
      'whouse_vid1': whouseVid1,
      'whouse_vid2': whouseVid2,
      'mobile': mobile,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}

class WarehouseResponse {
  final int status;
  final String message;
  final List<Warehouse> data;

  WarehouseResponse({
    this.status = 0, // Default value for int
    this.message = '', // Default value for String
    this.data = const [], // Default empty list
  });

  factory WarehouseResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List? ?? [];
    List<Warehouse> warehouseList = list.map((i) => Warehouse.fromJson(i)).toList();

    return WarehouseResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: warehouseList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((warehouse) => warehouse.toJson()).toList(),
    };
  }
}
