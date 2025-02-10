import 'dart:convert';
import 'package:Lisofy/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
// import 'package:warehouse/generated/l10n.dart';

class searchLocationUser extends StatefulWidget {
  @override
  State<searchLocationUser> createState() => _searchLocationUserState();
}

class _searchLocationUserState extends State<searchLocationUser> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _placeSuggestions = [];
  bool _isUserSelection = false; // Flag to track user selection

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (!_isUserSelection) {
        _onSearchChanged(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String input) async {
    print("User input: $input"); // Debugging input value
    if (input.isNotEmpty) {
      try {
        final suggestions = await fetchPlaceSuggestions(input);
        print("Fetched suggestions: $suggestions"); // Log API response data
        setState(() {
          _placeSuggestions = suggestions;
        });
      } catch (e) {
        print("Error fetching suggestions: $e"); // Error log
      }
    } else {
      setState(() {
        _placeSuggestions = [];
      });
    }
  }

  Future<List> fetchPlaceSuggestions(String input) async {
    const String apiKey = "AIzaSyDxbkZhKCXDGPdtOWxTPxFBg_tjAd3jsTk";
    const String baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    final requestUrl = "$baseUrl?input=$input&key=$apiKey&components=country:in";

    print("Request URL: $requestUrl"); // Debugging the API request URL

    try {
      final response = await http.get(Uri.parse(requestUrl));
      print("API Response Code: ${response.statusCode}"); // Log response code

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("API Response Body: ${response.body}"); // Log response body
        return data['predictions'] ?? [];
      } else {
        print(
            "Failed to fetch suggestions. Status Code: ${response.statusCode}"); // Log if response code is not 200
        throw Exception("Failed to fetch suggestions");
      }
    } catch (e) {
      print("Exception during API call: $e"); // Log any exceptions
      return [];
    }
  }

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
                    // Top Section with Back Button
                    Container(
                      color: Colors.blue,
                      height: screenHeight * 0.18,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.070,
                          left: screenWidth * 0.045,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Main Content Section
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
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                // Input TextField
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      hintText: 'Enter a location',
                                      label: Text(
                                        S.of(context).location,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Display Suggestions
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _placeSuggestions.length,
                                  itemBuilder: (context, index) {
                                    final suggestion =
                                    _placeSuggestions[index];
                                    return ListTile(
                                      title: Text(
                                        suggestion['description'] ?? '',
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _isUserSelection = true; // Prevent listener
                                          _controller.text =
                                              suggestion['description'] ?? '';
                                          _placeSuggestions = [];
                                        });
                                        Future.delayed(Duration(milliseconds: 300), () {
                                          _isUserSelection = false; // Re-enable listener
                                        });
                                        print(
                                            "Selected Place: ${suggestion['description']}"); // Log selected place
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(S.of(context).radius_in_km,style: const TextStyle(fontWeight: FontWeight.w800,fontSize: 16),)),
                                ),
                                SizedBox(height: 0),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [5, 10, 20, "KM"].map((value) {
                                    return Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),

                                      ),
                                      child: Container(
                                        width: 50,
                                        height: 40,
                                        decoration: BoxDecoration(color: Color(0xffD9D9D9),border: Border.all(color: Color(0xff585858),),borderRadius: BorderRadius.circular(10)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$value',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
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
}

