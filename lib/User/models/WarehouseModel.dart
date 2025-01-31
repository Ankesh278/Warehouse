class WarehouseModel {
  final int id;
  final double distance;
  final double latitude;
  final double longitude;
  final String whouseAddress; // Updated from whouse_address to match API response
  final double? wHouseRentPerSQFT; // whouse_rentPerSQFT from API
  final int? securityDeposit; // securityDeposit from API
  final String? totalArea; // totalArea from API
  final String? currentAddress; // current_address from API
  final int? constructionAge; // cunstructiontAge from API
  final String groundFloor; // graundFloor from API
  final String? wHouseType1; // whouse_type1 from API
  final String wHouseType; // whouse_type from API
  final String? wHouseType2; // whouse_type2 from API
  final String wHouseConstructionType; // whouse_Cunstructiontype from API
  final int wHouseFloor; // whouse_floor from API
  final double? wHouseCarpetArea; // whouse_carperarea from API
  final double? warehouseCarpetArea; // warehouse_carpetarea from API
  final int? isAvailable; // isavilable from API
  final int isAvailableForRent; // isavilableForRent from API
  final double? wHouseRent; // whouse_rent from API
  final String? wHouseMaintenance; // whouse_maintenance from API
  final String? wHouseTokenAdvance; // whouse_tokenAdvance from API
  final String? wHouseExpected; // whouse_expected from API
  final String? wHouseToken; // whouse_token from API
  final int? wHouseLockinPeriod; // whouseLockinPeriod from API
  final String wHouseName; // whouse_name from API
  final String status; // status from API
  final String filePath; // filepath from API
  final String mobile; // mobile from API
  final String? image; // image from API
  final int amenityId; // amenityId from API
  final String electricity; // electricity from API
  final bool powerBackup; // power_backup from API
  final bool officeSpace; // office_space from API
  final bool dockLevelers; // dock_levelers from API
  final int numberOfToilets; // numberOfToilets from API
  final int truckParkingSlot; // truck_ParkingSlot from API
  final int bikeParkingSlot; // bike_ParkingSlot from API
  final int numberOfFans; // numberOfFans from API
  final int numberOfLights; // numberOfLights from API
  final bool fireComplaints; // fireComplaints from API
  final String numberOfDocks; // numberOfDocks from API
  final String length; // length from API
  final String width; // width from API
  final String sideHeight; // sideHeight from API
  final String centerHeight; // centerHeight from API
  final String docksOfHeight; // docksOfHeight from API
  final bool flexingModel; // flexiModel from API
  final String flooringType; // flooringType from API
  final String furnishingType; // furnishingType from API
  final bool cluDocument; // cluDocument from API
  final int whouseId; // whouseId from API

  WarehouseModel({
    required this.id,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.whouseAddress,
    this.wHouseRentPerSQFT,
    this.securityDeposit,
    this.totalArea,
    this.currentAddress,
    this.constructionAge,
    required this.groundFloor,
    this.wHouseType1,
    required this.wHouseType,
    this.wHouseType2,
    required this.wHouseConstructionType,
    required this.wHouseFloor,
    this.wHouseCarpetArea,
    this.warehouseCarpetArea,
    this.isAvailable,
    required this.isAvailableForRent,
    this.wHouseRent,
    this.wHouseMaintenance,
    this.wHouseTokenAdvance,
    this.wHouseExpected,
    this.wHouseToken,
    this.wHouseLockinPeriod,
    required this.wHouseName,
    required this.status,
    required this.filePath,
    required this.mobile,
    this.image,
    required this.amenityId,
    required this.electricity,
    required this.powerBackup,
    required this.officeSpace,
    required this.dockLevelers,
    required this.numberOfToilets,
    required this.truckParkingSlot,
    required this.bikeParkingSlot,
    required this.numberOfFans,
    required this.numberOfLights,
    required this.fireComplaints,
    required this.numberOfDocks,
    required this.length,
    required this.width,
    required this.sideHeight,
    required this.centerHeight,
    required this.docksOfHeight,
    required this.flexingModel,
    required this.flooringType,
    required this.furnishingType,
    required this.cluDocument,
    required this.whouseId,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: int.tryParse(json['id'].toString()) ?? 0, // Safe parsing
      distance: (json['distance'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      whouseAddress: json['whouse_address'] ?? '',
      wHouseRentPerSQFT: json['whouse_rentPerSQFT'] != null
          ? (json['whouse_rentPerSQFT'] as num).toDouble()
          : null,
      securityDeposit: json['securityDeposit'] != null
          ? int.tryParse(json['securityDeposit'].toString()) // Safe parsing
          : null,
      totalArea: json['totalArea'] ?? '',
      currentAddress: json['current_address'] ?? '',
      constructionAge: json['cunstructiontAge'] != null
          ? int.tryParse(json['cunstructiontAge'].toString()) // Safe parsing
          : null,
      groundFloor: json['graundFloor'] ?? '',
      wHouseType1: json['whouse_type1'],
      wHouseType: json['whouse_type'] ?? '',
      wHouseType2: json['whouse_type2'],
      wHouseConstructionType: json['whouse_Cunstructiontype'] ?? '',
      wHouseFloor: int.tryParse(json['whouse_floor'].toString()) ?? 0, // Safe parsing
      wHouseCarpetArea: json['whouse_carperarea'] != null
          ? (json['whouse_carperarea'] as num).toDouble()
          : null,
      warehouseCarpetArea: json['warehouse_carpetarea'] != null
          ? (json['warehouse_carpetarea'] as num).toDouble()
          : null,
      isAvailable: json['isavilable'],
      isAvailableForRent: int.tryParse(json['isavilableForRent'].toString()) ?? 0, // Safe parsing
      wHouseRent: json['whouse_rent'] != null
          ? (json['whouse_rent'] as num).toDouble()
          : null,
      wHouseMaintenance: json['whouse_maintenance'],
      wHouseTokenAdvance: json['whouse_tokenAdvance'],
      wHouseExpected: json['whouse_expected'],
      wHouseToken: json['whouse_token'],
      wHouseLockinPeriod: int.tryParse(json['whouseLockinPeriod'].toString()) ?? 0, // Safe parsing
      wHouseName: json['whouse_name'] ?? '',
      status: json['status'] ?? '',
      filePath: json['filepath'] ?? '',
      mobile: json['mobile'] ?? '',
      image: json['image'],
      amenityId: int.tryParse(json['amenityId'].toString()) ?? 0, // Safe parsing
      electricity: json['electricity'] ?? '',
      powerBackup: json['power_backup'] ?? false,
      officeSpace: json['office_space'] ?? false,
      dockLevelers: json['dock_levelers'] ?? false,
      numberOfToilets: int.tryParse(json['numberOfToilets'].toString()) ?? 0, // Safe parsing
      truckParkingSlot: int.tryParse(json['truck_ParkingSlot'].toString()) ?? 0, // Safe parsing
      bikeParkingSlot: int.tryParse(json['bike_ParkingSlot'].toString()) ?? 0, // Safe parsing
      numberOfFans: int.tryParse(json['numberOfFans'].toString()) ?? 0, // Safe parsing
      numberOfLights: int.tryParse(json['numberOfLights'].toString()) ?? 0, // Safe parsing
      fireComplaints: json['fireComplaints'] ?? false,
      numberOfDocks: json['numberOfDocks'] ?? '',
      length: json['length'] ?? '',
      width: json['width'] ?? '',
      sideHeight: json['sideHeight'] ?? '',
      centerHeight: json['centerHeight'] ?? '',
      docksOfHeight: json['docksOfHeight'] ?? '',
      flexingModel: json['flexiModel'] ?? false,
      flooringType: json['flooringType'] ?? '',
      furnishingType: json['furnishingType'] ?? '',
      cluDocument: json['cluDocument'] ?? false,
      whouseId: int.tryParse(json['whouseId'].toString()) ?? 0, // Safe parsing
    );
  }
}
