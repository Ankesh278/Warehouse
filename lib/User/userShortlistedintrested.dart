import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/DistanceCalculator.dart';
import 'package:warehouse/User/InterestedWarehouseDetailsScreen.dart';
import 'package:warehouse/User/models/ShortListModel.dart';
import 'package:warehouse/User/models/WarehouseModel.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/User/models/interestedDataModel.dart';
import 'package:warehouse/User/wareHouseDetails.dart';
import 'package:warehouse/resources/ImageAssets/ImagesAssets.dart';

class userShortlistedIntrested extends StatefulWidget {
  @override
  State<userShortlistedIntrested> createState() => _userShortlistedIntrestedState();
}

class _userShortlistedIntrestedState extends State<userShortlistedIntrested> {
  bool isShortlisted = true; // State to track toggle between Shortlisted and Interested
  final ScrollController _scrollController = ScrollController();
  List<InteretedModel> interestedWarehouses = [];
  List<ShortListModel> shortlistedWarehouses = [];
  bool isLoading = true;
  String phone="";
  late Future<List<ShortListModel>> _warehousesFuture;

  int _page = 1;

  // This function simulates fetching new data when paginating.
  void _loadMoreData() {
    setState(() {
      _page++; // Simulate pagination by increasing the page
    });
  }


  @override
  void initState() {
    super.initState();
    //Shortlistmethod
    _warehousesFuture = fetchShortlistedWarehouses();
    //Intrest data
    fetchWarehouses();
    // Listen to the scroll controller to detect when the user reaches the end of the scroll.
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData(); // Fetch more data when the user scrolls to the bottom
      }
    });
  }

  // Fetch data from API and filter based on type
  Future<void> fetchWarehouses() async {
    setState(() {
      isLoading = true; // Show loading spinner
    });

    SharedPreferences pref=await SharedPreferences.getInstance();
    phone=pref.getString("phone")!;
    if(phone != null && phone.startsWith("+91")){
      phone=phone.substring(3);
    }
    print("Phone is "+phone);



    // Construct the API URL with the parameter
    final String apiUrl =
        "https://xpacesphere.com/api/Wherehousedt/Intrest_warehousedata?mobile=$phone";

    print("Constructed API URL: $apiUrl"); // Print the URL with parameters

    try {
      // Make the API request
      final response = await http.get(Uri.parse(apiUrl));

      // Log the HTTP status code
      print("HTTP Status Code: ${response.statusCode}");

      // Log the entire response body
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print("API hit successful");

        // Decode the response as a map
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Log the JSON response
        print("Decoded JSON Response: $jsonResponse");

        // Access the list under the 'data' key
        List<dynamic> data = jsonResponse['data']; // 'data' is the key holding the list
        print("Extracted Data List: $data");

        // Create separate lists for interested and shortlisted warehouses
        List<InteretedModel> interested = [];
        List<InteretedModel> shortlisted = [];

        for (var item in data) {
          InteretedModel warehouse = InteretedModel.fromJson(item);

          // Log each warehouse type for debugging
          print("Warehouse Type: ${warehouse.type}");

          // Separate based on the 'type' field
          if (warehouse.type == 'Intrested') { // Typo from 'Intrested' in the API
            interested.add(warehouse);
          } else if (warehouse.type == 'Shortlisted') {
            shortlisted.add(warehouse);
          }
        }

        // Update the state with the filtered lists
        setState(() {
          interestedWarehouses = interested;
          isLoading = false; // Stop loading spinner
        });

        // Log the final interested and shortlisted lists
        print("Interested Warehouses: $interested");
        print("Shortlisted Warehouses: $shortlisted");
      } else {
        // Handle HTTP errors
        print("Error: Failed to load data with status ${response.statusCode}");
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Log any exceptions
      print("Exception occurred: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  ///ShortlistData


  Future<List<ShortListModel>> fetchShortlistedWarehouses() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String phone = pref.getString("phone")!;

    // Ensure the phone number starts with country code, if necessary
    if (phone != null && phone.startsWith("+91")) {
      phone = phone.substring(3);
    }
    print("Phone is $phone");

    String url = 'https://xpacesphere.com/api/Wherehousedt/GetSortlist_warehouse?_mobile=$phone';
    final response = await http.get(Uri.parse(url));

    // Print the full API response body for debugging
    print("API URLShort: $url");
    print("Response BodyShortShort: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("Decoded JSON Response: $jsonResponse");

      if (jsonResponse['status'] == 200) {
        final List data = jsonResponse['data'];
        print("API DataShort: $data");  // Print the actual data being returned

        // Map the data to ShortListModel objects and store them in the list
        shortlistedWarehouses = data.map((json) => ShortListModel.fromJson(json)).toList();



        return shortlistedWarehouses;
      } else {
        throw Exception('Failed to fetch data: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to fetch data: ${response.reasonPhrase}');
    }
  }




  //Distance Calculator
  DistanceCalculator distanceCalculator = DistanceCalculator();

  //print("Distance: ${distance / 1000} km"); // Convert to km for readability



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
                      decoration: BoxDecoration(
                          color: Colors.blue,
                       // border: Border.all(color: Colors.grey)
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
                          height: 30, // Reduced height
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white, // Background color for the toggle container
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isShortlisted = true; // Switch to Shortlisted
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 73, // Half the width of the toggle
                                  padding: EdgeInsets.symmetric(vertical: 4), // Smaller padding for a more compact look
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: isShortlisted ? Colors.blue : Colors.transparent,
                                  ),
                                  child: Text(
                                    "Shortlisted",
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
                                    isShortlisted = false; // Switch to Interested
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 75, // Half the width of the toggle
                                  padding: EdgeInsets.symmetric(vertical: 4), // Smaller padding for a more compact look
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: !isShortlisted ? Colors.blue : Colors.transparent,
                                  ),
                                  child: Text(
                                    "Interested",
                                    style: TextStyle(
                                      color: !isShortlisted ? Colors.white : Colors.blue,
                                      fontSize: 12, // Smaller font size
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.06),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              children: [
                                // Display content based on the state of the toggle
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

  // Function to build the content for Shortlisted section
  Widget _buildShortlistedContent() {
    return Column(
      children: [
        Container(
          height:  MediaQuery.of(context).size.height * 0.6,
          child: shortlistedWarehouses.isEmpty?Center( // Show a static image if no data is available
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/warehousegift.png', // Replace with your static image path
                  height: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  "No Shortlisted Warehouses found.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
              :GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: shortlistedWarehouses.length,
            itemBuilder: (context, index) {
              final warehouse = shortlistedWarehouses[index];
              String whouseAddress = warehouse.whouse_address;
              // Example usage to get the distance
              // double distance =  distanceCalculator.getDistanceFromCurrentToWarehouse(whouseAddress);
              return FutureBuilder(
                future: distanceCalculator.getDistanceFromCurrentToWarehouse(whouseAddress),
                builder: (context,snapshot){
                  double distanceInKm = (snapshot.data ?? 0.0) / 1000; // Convert to km
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: SpinKitCircle(
                      color: Colors.blue, // Specify a color for the spinner
                      size: 50.0, //
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text(' calculating distance'));
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
                                height: 110,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Return a default image when an error occurs
                                  return Image.asset(
                                    ImageAssets.defaultImage, // Path to your default image
                                    width: double.infinity,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                              ,
                            ),
                            const SizedBox(height: 5),
                            Spacer(),
                            Text(
                              warehouse.whouseRent.toString() + " per sq.ft",
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Type: " + warehouse.whouseType1,
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              (distanceInKm != null
                                  ? distanceInKm.toStringAsFixed(3) + " km away"
                                  : "N/A km away"), // Handle null distance gracefully
                              style: TextStyle(
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
    // Build GridView if data is available
    return Column(
      children: [
        Container(
          height:  MediaQuery.of(context).size.height * 0.6,
          child: interestedWarehouses.isEmpty?Center( // Show a static image if no data is available
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/warehousegift.png', // Replace with your static image path
                  height: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                        "No Interested Warehouses found. Express interest to get a callback.",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
              ],
            ),
          )
              :GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: interestedWarehouses.length,
            itemBuilder: (context, index) {
              final warehouse = interestedWarehouses[index];
              String whouseAddress = warehouse.whouse_address;
              // Example usage to get the distance
              // double distance =  distanceCalculator.getDistanceFromCurrentToWarehouse(whouseAddress);
              return FutureBuilder(
                future: distanceCalculator.getDistanceFromCurrentToWarehouse(whouseAddress),
                builder: (context,snapshot){
                  double distanceInKm = (snapshot.data ?? 0.0) / 1000; // Convert to km
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: SpinKitCircle(
                      color: Colors.blue, // Specify a color for the spinner
                      size: 50.0, //
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text(' calculating distance'));
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
                                height: 110,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Return a default image when an error occurs
                                  return Image.asset(
                                    ImageAssets.defaultImage, // Path to your default image
                                    width: double.infinity,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                              ,
                            ),
                            const SizedBox(height: 5),
                            Spacer(),
                            Text(
                              warehouse.whouseRent.toString() + " per sq.ft",
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Type: " + warehouse.whouseType1,
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              (distanceInKm != null
                                  ? distanceInKm.toStringAsFixed(3) + " km away"
                                  : "N/A km away"), // Handle null distance gracefully
                              style: TextStyle(
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


