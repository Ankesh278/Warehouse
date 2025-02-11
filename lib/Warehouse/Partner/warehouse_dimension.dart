import 'dart:convert';
import 'package:Lisofy/Warehouse/Partner/home_screen.dart';
import 'package:Lisofy/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class WarehouseService extends StatefulWidget {
  final String electricity;
  final String tenants;
  final int toilets;
  final String parkingSlots;
  final String constructionAge;
  final String bikeSlots;
  final int fans;
  final int lights;
  final String powerBackup;
  final String provideOffice;
  final String dockLevelers;
  final String cluDocument;
  final String fireComplaint;
  final int id;
  const WarehouseService({
    super.key,
    required this.electricity,
    required this.tenants,
    required this.toilets,
    required this.parkingSlots,
    required this.constructionAge,
    required this.bikeSlots,
    required this.fans,
    required this.lights,
    required this.powerBackup,
    required this.provideOffice,
    required this.dockLevelers,
    required this.fireComplaint,
    required this.cluDocument,
    required this.id,
  });

  @override
  State<WarehouseService> createState() => _WarehouseServiceState();
}

class _WarehouseServiceState extends State<WarehouseService> {
  final TextEditingController _noOfDocks = TextEditingController();
  final TextEditingController _dockHeight = TextEditingController();
  final TextEditingController _sideHeight = TextEditingController();
  final TextEditingController _centreHeight = TextEditingController();
  final TextEditingController _width = TextEditingController();
  final TextEditingController _length = TextEditingController();

  String? _selectedFlooringType;
  String? _selectedFurnishingType;
  String flexingModel = '';

  final List<String> _flooringType = ['Epoxy', 'VDF', 'Concrete'];
  final List<String> _furnishingType = [
    'Full Furnished',
    'Semi Furnished',
    'Unfurnished',
    'Others'
  ];

  void _showCupertinoSheet(List<String> options, Function(String) onSelected) {
    int selectedIndex = 0;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        return Container(
          height: screenHeight * 0.4,
          padding: EdgeInsets.all(screenHeight * 0.05),
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  itemExtent: screenWidth * 0.17,
                  onSelectedItemChanged: (index) {
                    FocusScope.of(context).unfocus();
                    selectedIndex = index;
                  },
                  children: options.map((option) => Text(option)).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child:  Text(S.of(context).cancel,
                        style: const TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () {
                      onSelected(options[selectedIndex]);
                      Navigator.pop(context);
                    },
                    child:  Text(S.of(context).done,
                        style: const TextStyle(color: Colors.blue)),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _submitForm() async {
    if ([_noOfDocks, _dockHeight, _sideHeight, _centreHeight, _width, _length]
            .any((controller) => controller.text.isEmpty) ||
        _selectedFlooringType == null ||
        _selectedFurnishingType == null) {
      return;
    }

    _showProgressIndicator();

    try {
      final bodyData = _prepareBodyData();
      if (kDebugMode) {
        print("Request Body: $bodyData");
      }

      final response = await http.post(
        Uri.parse(
            'https://xpacesphere.com/api/Amenitiesdt/InsAmenities_Details'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(bodyData),
      );

      if (kDebugMode) {
        print("Response: ${response.statusCode}, Body: ${response.body}");
      }

      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        _showSuccessPopup();
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error: $error");
      }
      Navigator.of(context).pop();
    }
  }

  void _showProgressIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SpinKitCircle(color: Colors.blue, size: 50.0),
      ),
    );
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/addedAnimation.json',
                width: 120,
                height: 120,
                repeat: false,
              ),
              const SizedBox(height: 10),
              const Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Your warehouse has been Published Successfully...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      _navigateToHomeScreen();
    });
  }

  void _navigateToHomeScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  Map<String, dynamic> _prepareBodyData() {
    return {
      "Electricity": widget.electricity ?? "0.0",
      "Power_backup": widget.powerBackup.toLowerCase() == "yes",
      "Office_space": widget.provideOffice.toLowerCase() == "yes",
      "Dock_levelers": widget.dockLevelers.toLowerCase() == "yes",
      "NumberOfToilets": widget.toilets,
      "Truck_ParkingSlot": int.tryParse(widget.parkingSlots) ?? 0,
      "Bike_ParkingSlot": int.tryParse(widget.bikeSlots) ?? 0,
      "NumberOfFans": widget.fans,
      "NumberOfLights": widget.lights,
      "FireComplaints": widget.fireComplaint.toLowerCase() == "yes",
      "NumberOfDocks": _noOfDocks.text.trim(),
      "Length": _length.text.trim(),
      "Width": _width.text.trim(),
      "SideHeight": _sideHeight.text.trim(),
      "CenterHeight": _centreHeight.text.trim(),
      "DocksOfHeight": _dockHeight.text.trim(),
      "FlexiModel": flexingModel.toLowerCase() == "yes",
      "CluDocument": widget.cluDocument.toLowerCase() == "yes",
      "FlooringType": _selectedFlooringType,
      "FurnishingType": _selectedFurnishingType,
      "WhouseId": widget.id,
      "mobile": widget.id,
    };
  }

  @override
  void dispose() {
    _noOfDocks.dispose();
    _dockHeight.dispose();
    _sideHeight.dispose();
    _centreHeight.dispose();
    _width.dispose();
    _length.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            height: screenHeight * 0.18,
            width: double.infinity,
            padding: EdgeInsets.only(
                left: screenWidth * 0.07, top: screenHeight * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        child: const Icon(Icons.arrow_back_ios_new_outlined,
                            color: Colors.white),
                        onTap: () => Navigator.pop(context),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                       Text(S.of(context).add_warehouse_details,
                          style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                 Text("${S.of(context).warehouse_dimensions} 4/4",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.005,
                  horizontal: screenWidth * 0.045),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.blue),
                            keyboardType: TextInputType.number,
                            controller: _length,
                            decoration:  InputDecoration(
                              labelText: S.of(context).inner_length,
                              labelStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                              hintText: "ex2",
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.025),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.blue),
                            keyboardType: TextInputType.number,
                            controller: _width,
                            decoration:  InputDecoration(
                              labelText: S.of(context).inner_width,
                              labelStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                              hintText: "ex2",
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.blue),
                            keyboardType: TextInputType.number,
                            controller: _sideHeight,
                            decoration:  InputDecoration(
                              labelText: S.of(context).side_height,
                              labelStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                              hintText: "ex2",
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.025),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.blue),
                            keyboardType: TextInputType.number,
                            controller: _centreHeight,
                            decoration:  InputDecoration(
                              labelText: S.of(context).centre_height,
                              labelStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                              hintText: "ex2",
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.blue),
                            controller: _noOfDocks,
                            decoration:  InputDecoration(
                              labelText: S.of(context).num_of_docks,
                              labelStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                              hintText: "ex2",
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.025),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.blue),
                            controller: _dockHeight,
                            decoration:  InputDecoration(
                              labelText: S.of(context).docks_height,
                              labelStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                              hintText: "ex2",
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ListTile(
                      tileColor: Colors.blue[50],
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.1)),
                      title:  Text(
                        S.of(context).flooring_type,
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(_selectedFlooringType ?? 'None',
                          style: const TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.blue)),
                      trailing: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.blue),
                      onTap: () => _showCupertinoSheet(
                        _flooringType,
                        (value) =>
                            setState(() => _selectedFlooringType = value),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ListTile(
                      tileColor: Colors.blue[50],
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.1)),
                      title:  Text(S.of(context).furnishing_type),
                      subtitle: Text(_selectedFurnishingType ?? 'None',
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.blue,
                          )),
                      trailing: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.blue),
                      onTap: () => _showCupertinoSheet(
                        _furnishingType,
                        (value) =>
                            setState(() => _selectedFurnishingType = value),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    buildToggleButtons(
                        S.of(context).flexi_model_interest,
                        flexingModel,
                        (value) => setState(() => flexingModel = value)),
                    SizedBox(height: screenHeight * 0.04),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 8, // Add elevation
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.06),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.15,
                              vertical: screenHeight * 0.01),
                        ),
                        child:  Text(
                          S.of(context).submit,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToggleButtons(
      String title, String selectedValue, Function(String) onSelected) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.015, horizontal: screenWidth * 0.037),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
              buildToggleButton('Yes', selectedValue, onSelected),
              SizedBox(width: screenWidth * 0.03),
              buildToggleButton('No', selectedValue, onSelected),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildToggleButton(
      String label, String selectedValue, Function(String) onSelected) {
    bool isActive = label == selectedValue;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => onSelected(label),
      child: Container(
        width: screenWidth * 0.1,
        height: screenHeight * 0.03,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

