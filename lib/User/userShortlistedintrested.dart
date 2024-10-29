import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/DistanceCalculator.dart';
import 'package:warehouse/User/InterestedWarehouseDetailsScreen.dart';
import 'package:warehouse/User/models/WarehouseModel.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/User/models/interestedDataModel.dart';
import 'package:warehouse/User/wareHouseDetails.dart';

class userShortlistedIntrested extends StatefulWidget {
  @override
  State<userShortlistedIntrested> createState() => _userShortlistedIntrestedState();
}

class _userShortlistedIntrestedState extends State<userShortlistedIntrested> {
  bool isShortlisted = true; // State to track toggle between Shortlisted and Interested
  final ScrollController _scrollController = ScrollController();
  List<InteretedModel> interestedWarehouses = [];
  List<InteretedModel> shortlistedWarehouses = [];
  bool isLoading = true;

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

    try {
      final response = await http.get(Uri.parse(
          "https://xpacesphere.com/api/Wherehousedt/Intrest_warehousedata?mobile=7007221531"));

      if (response.statusCode == 200) {
        print("API hit successful");
        print("API response: " + response.body);

        // Decode the response as a map
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Access the list under the 'data' key
        List<dynamic> data = jsonResponse['data']; // 'data' is the key holding the list

        print("Data: " + data.toString());

        // Create separate lists for interested and shortlisted warehouses
        List<InteretedModel> interested = [];
        List<InteretedModel> shortlisted = [];

        for (var item in data) {
          InteretedModel warehouse = InteretedModel.fromJson(item);

          // Separate based on the 'type' field
          if (warehouse.type == 'Intrested') {  // Typo from 'Intrested' in the API
            interested.add(warehouse);
          } else if (warehouse.type == 'Shortlisted') {
            shortlisted.add(warehouse);
          }
        }

        // Update the state with the filtered lists
        setState(() {
          interestedWarehouses = interested;
          shortlistedWarehouses = shortlisted;
          isLoading = false; // Stop loading spinner
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Container(
                height: screenHeight*0.25,
                width: screenWidth*0.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      spreadRadius: 0.5, // How much the shadow spreads
                      blurRadius: 0.5, // The blur effect
                      offset: Offset(0, 2), // Only shift the shadow downwards
                    ),
                  ],
                ),
                child: Stack(
                  children: [Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15), // Set this value to half the width/height to make it circular
                        child: Image.asset(
                          'assets/images/slider2.jpg',
                          width: double.infinity, // Define width
                          height: 110, // Define height
                          fit: BoxFit.cover, // Ensures the image covers the whole container
                        ),
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(children: [
                            Text("₹ 15.00-18.000",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w800),),
                            Text("  per sq.ft",style: TextStyle(fontSize: 5,fontWeight: FontWeight.w400,color: Colors.black),),

                          ],),
                          Row(children: [
                            Text("Type: ",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w400,color: Colors.grey),),
                            Text("Shed",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w600,color: Colors.black),),

                          ],)

                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(children: [
                            SizedBox(width: 5,),
                            Image.asset("assets/images/Scaleup.png",height: 20,width: 20,),
                            Text("₹45000.00",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w800),),
                            Text(" per sq.ft",style: TextStyle(fontSize: 5,fontWeight: FontWeight.w400,color: Colors.black),),

                          ],),


                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(children: [
                            Icon(Icons.location_on,size: 12,),
                            Text("6.0 kms away",style: TextStyle(fontSize: 8,fontWeight: FontWeight.w400,color: Colors.grey),),

                          ],),
                          Row(children: [
                            Image.asset("assets/images/people.png",height: 20,width: 17,),
                            SizedBox(width: 5,),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.black,width: 2)
                              ),
                              child: Center(child: Text("P",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 13),)),
                            )

                          ],)

                        ],
                      ),


                    ],
                  ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            color: Colors.white,
                            child: Icon(Icons.file_download_outlined,color: Colors.blue,),
                          )
                      ),
                    )
                  ],
                )
            ),
          ],
        )


       // Display page for Shortlisted
      ],
    );
  }

  // Function to build the content for Interested section
  Widget _buildInterestedContent() {
    // if (isLoading) {
    //   return Center(child: SpinKitCircle(color: Colors.blue));
    // }
    //
    // if (interestedWarehouses.isEmpty) {
    //   // If there are no interested warehouses, show a message or UI
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Image.asset("assets/images/warehousegift.png", scale: 1.5),
    //         const SizedBox(height: 20),
    //         const Text(
    //           "No Interested Warehouses found. Express interest to get a callback.",
    //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    //           textAlign: TextAlign.center,
    //         ),
    //       ],
    //     ),
    //   );
    // }

    // Build GridView if data is available
    return Column(
      children: [
        Container(
          height:  MediaQuery.of(context).size.height * 0.6,
          child: GridView.builder(
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
                              ),
                            ),
                            const SizedBox(height: 5),
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


