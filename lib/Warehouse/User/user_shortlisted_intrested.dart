import 'dart:convert';
import 'package:Lisofy/Warehouse/User/interested_warehouse_details_screen.dart';
import 'package:Lisofy/Warehouse/User/models/ShortListModel.dart';
import 'package:Lisofy/Warehouse/User/models/interestedDataModel.dart';
import 'package:Lisofy/distance_calculator.dart';
import 'package:Lisofy/generated/l10n.dart';
import 'package:Lisofy/resources/ImageAssets/ImagesAssets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class userShortlistedIntrested extends StatefulWidget {
  const userShortlistedIntrested({super.key});

  @override
  State<userShortlistedIntrested> createState() => _userShortlistedIntrestedState();
}

class _userShortlistedIntrestedState extends State<userShortlistedIntrested> {
  bool isShortlisted = true;
  List<InterestedModel> interestedWarehouses = [];
  List<ShortListModel> shortlistedWarehouses = [];
  bool isLoading = true;
  String phone="";

  @override
  void initState() {
    super.initState();
    fetchShortlistedWarehouses();
    //Interested data
    fetchWarehouses();
  }

  // Fetch data from API and filter based on type
  Future<void> fetchWarehouses() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      phone = pref.getString("phone") ?? '';
      if (phone.startsWith("+91")) {
        phone = phone.substring(3);
      }
      if (kDebugMode) {
        print("Phone is $phone");
      }
      final String apiUrl =
          "https://xpacesphere.com/api/Wherehousedt/Intrest_warehousedata?mobile=$phone";
      if (kDebugMode) {
        print("Constructed API URL: $apiUrl");
      }
      final response = await http.get(Uri.parse(apiUrl));
      if (kDebugMode) {
        print("HTTP Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("API Response Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("API hit successful");
        }

        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print("Decoded JSON Response: $jsonResponse");
        }

        if (jsonResponse['status'] == 200) {
          List<dynamic> data = jsonResponse['data'] ?? [];
          if (kDebugMode) {
            print("Extracted Data List: $data");
          }
          List<InterestedModel> interested = [];
          for (var item in data) {
            try {
              InterestedModel warehouse = InterestedModel.fromJson(item);
              if (warehouse.type == 'Interested') {
                interested.add(warehouse);
              } else if (warehouse.type == 'Shortlisted') {
              }
            } catch (e) {
              if (kDebugMode) {
                print("Error parsing warehouse data: $e");
              }
            }
          }
          setState(() {
            interestedWarehouses = interested;
            isLoading = false;
          });

          if (kDebugMode) {
            print("Interested Warehouses: $interested");
          }
        } else {
          if (kDebugMode) {
            print("Error: ${jsonResponse['message']}");
          }
          throw Exception(jsonResponse['message']);
        }
      } else {
        if (kDebugMode) {
          print("Error: Failed to load data with status ${response.statusCode}");
        }
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception occurred: $e");
      }
      setState(() {
        isLoading = false;
      });
    }
  }
  ///ShortlistData
  Future<void> fetchShortlistedWarehouses() async {
    setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      phone = pref.getString("phone") ?? '';
      if (phone.startsWith("+91")) {
        phone = phone.substring(3);
      }
      if (kDebugMode) {
        print("Phone is $phone");
      }
      final String apiUrl =
          "https://xpacesphere.com/api/Wherehousedt/GetSortlist_warehouse?_mobile=$phone";
      if (kDebugMode) {
        print("Constructed API URL: $apiUrl");
      }
      final response = await http.get(Uri.parse(apiUrl));
      if (kDebugMode) {
        print("HTTP Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("API Response Body: ${response.body}");
      }
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("API hit successful");
        }
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (kDebugMode) {
          print("Decoded JSON Response: $jsonResponse");
        }
        if (jsonResponse['status'] == 200) {
          List<dynamic> data = jsonResponse['data'] ?? [];
          if (kDebugMode) {
            print("Extracted Data List: $data");
          }
          List<ShortListModel> shortlisted = [];
          for (var item in data) {
            try {
              if (kDebugMode) {
                print("Parsing item: $item");
              }
              ShortListModel warehouse = ShortListModel.fromJson(item);
              shortlisted.add(warehouse);
            } catch (e) {
              if (kDebugMode) {
                print("Error parsing warehouse data: $e");
              }
            }
          }
          setState(() {
            shortlistedWarehouses = shortlisted;
            isLoading = false;
          });
          if (kDebugMode) {
            print("Shortlisted Warehouses: $shortlisted");
          }
        } else {
          if (kDebugMode) {
            print("Error: ${jsonResponse['message']}");
          }
          throw Exception(jsonResponse['message']);
        }
      } else {
        if (kDebugMode) {
          print("Error: Failed to load data with status ${response.statusCode}");
        }
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception occurred: $e");
      }
      setState(() {
        isLoading = false;
      });
    }
  }
  DistanceCalculator distanceCalculator = DistanceCalculator();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue,
              width: double.infinity,
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                      ),
                      height: screenHeight * 0.18,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.065,
                          left: screenWidth * 0.045,
                          right: screenWidth * 0.028,
                          bottom: screenWidth * 0.17,
                        ),
                        child: Container(
                          //height: screenHeight*0.09,
                          width: screenWidth*0.465,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isShortlisted = true;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: screenWidth*0.227,
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: isShortlisted ? Colors.blue : Colors.transparent,
                                  ),
                                  child: Text(
                                    S.of(context).shortlisted,
                                    style: TextStyle(
                                      color: isShortlisted ? Colors.white : Colors.blue,
                                      fontSize: 12, // Smaller font size
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isShortlisted = false;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: screenWidth*0.23,
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: !isShortlisted ? Colors.blue : Colors.transparent,
                                  ),
                                  child: Text(
                                    S.of(context).interested,
                                    style: TextStyle(
                                      color: !isShortlisted ? Colors.white : Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: screenWidth * 0.005),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal:screenWidth * 0.06,vertical: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (isShortlisted)
                                  _buildShortlistedContent()
                                else
                                  _buildInterestedContent(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortlistedContent() {
    final screenHeight = MediaQuery.of(context).size.height;
   // final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height:  MediaQuery.of(context).size.height * 0.6,
          child: shortlistedWarehouses.isEmpty?Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/warehousegift.png',
                  height: screenHeight*0.3,
                ),
                 SizedBox(height: screenHeight*0.05),
                 Text(
                  S.of(context).no_shortlisted_warehouses_found,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
              :GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: shortlistedWarehouses.length,
            itemBuilder: (context, index) {
              final warehouse = shortlistedWarehouses[index];
              String whouseAddress = warehouse.wHouseAddress;
              return FutureBuilder(
                future: distanceCalculator.getDistanceFromCurrentToWarehouse(whouseAddress),
                builder: (context,snapshot){
                  double distanceInKm = (snapshot.data ?? 0.0) / 1000;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: SpinKitCircle(
                      color: Colors.blue,
                      size: 50.0, //
                    ));
                  } else if (snapshot.hasError) {
                    return const Center(child: Text(' calculating distance'));
                  }else{
                    return InkWell(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.9),
                              spreadRadius: 0.5,
                              blurRadius: 0.5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                "https://xpacesphere.com${warehouse.image}",
                                width: double.infinity,
                                height: screenHeight*0.16,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    ImageAssets.defaultImage,
                                    width: double.infinity,
                                    height: screenHeight*0.16,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                              ,
                            ),
                            const SizedBox(height: 5),
                            const Spacer(),
                            Text("${warehouse.wHouseRentPerSQFT} per sq.ft",
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${S.of(context).type}: ${warehouse.wHouseType}",
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              (distanceInKm != null
                                  ? "${distanceInKm.toStringAsFixed(3)} km away"
                                  : "N/A km away"),
                              style: const TextStyle(
                                  fontSize: 8, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InterestedWarehouseDetailsScreen(warehouses: warehouse)),
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Function to build the content for Interested section
  Widget _buildInterestedContent() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height:  MediaQuery.of(context).size.height*0.99,
          child: interestedWarehouses.isEmpty?Center( // Show a static image if no data is available
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/warehousegift.png', // Replace with your static image path
                  height: screenHeight*0.3,
                ),
                SizedBox(height: screenHeight*0.05),
                 Text(
                  S.of(context).express_interest_to_get_callback,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
              ],
            ),
          )
              :GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: interestedWarehouses.length,
            itemBuilder: (context, index) {
              final warehouse = interestedWarehouses[index];
              String whouseAddress = warehouse.wHouseAddress;
              return FutureBuilder(
                future: distanceCalculator.getDistanceFromCurrentToWarehouse(whouseAddress),
                builder: (context,snapshot){
                  double distanceInKm = (snapshot.data ?? 0.0) / 1000;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: SpinKitCircle(
                      color: Colors.blue,
                      size: 50.0,
                    ));
                  } else if (snapshot.hasError) {
                    return const Center(child: Text(' calculating distance'));
                  }else{
                    return InkWell(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.9),
                              spreadRadius: 0.5,
                              blurRadius: 0.5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                "https://xpacesphere.com${warehouse.image}",
                                width: double.infinity,
                                height: screenHeight*0.16,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    ImageAssets.defaultImage,
                                    width: double.infinity,
                                    height: screenHeight*0.16,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                              ,
                            ),
                            const SizedBox(height: 5),
                            const Spacer(),
                            Text(
                              "${warehouse.wHouseRentPerSQFT} per sq.ft",
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${S.of(context).type} ${warehouse.wHouseType}",
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              (distanceInKm != null
                                  ? "${distanceInKm.toStringAsFixed(3)} km away"
                                  : "N/A km away"),
                              style: const TextStyle(
                                  fontSize: 8, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InterestedWarehouseDetailsScreen(warehouses: warehouse)),
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}


