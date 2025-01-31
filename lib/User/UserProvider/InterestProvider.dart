import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/User/user_shortlisted_intrested.dart';

class CartProvider with ChangeNotifier {
  final String baseUrl = "https://xpacesphere.com/api/Wherehousedt";
  final Map<int, bool> _shortlistedWarehouses = {};

  // Getter to check if a warehouse is shortlisted
  bool isShortlisted(int warehouseId) => _shortlistedWarehouses[warehouseId] ?? false;

  // Fetch shortlist status for a warehouse
  Future<void> fetchShortlistStatus(int warehouseId, String phoneNumber) async {
    try {
      final url = "$baseUrl/GetSortlist_warehouse?_mobile=$phoneNumber&Id=$warehouseId";
      print("Iddd$warehouseId");
      final response = await http.get(Uri.parse(url));
      print("URL: $url");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Response Data: $data");

        if (data['status'] == 200 && data['data'] is List && data['data'].isNotEmpty) {

          final type = data['data'][0]['type'];

          if (type == "Shortlisted") {
            _shortlistedWarehouses[warehouseId] = true;
          } else {
            _shortlistedWarehouses[warehouseId] = false;
          }
        } else {
          _shortlistedWarehouses[warehouseId] = false;
        }


        notifyListeners();
      } else {
        throw Exception("Failed to fetch shortlist status");
      }
    } catch (e) {
      print("Error fetching shortlist status: $e");
    }
  }

  // Add or remove warehouse from shortlist
  Future<void> toggleWarehouse(
      int warehouseId, String phoneNumber, BuildContext context,
      {bool isUndo = false}) async {
    final isCurrentlyShortlisted = _shortlistedWarehouses[warehouseId] ?? false;

    try {
      print("Toggling warehouse: $warehouseId, Phone: $phoneNumber, Undo: $isUndo");

      if (!isUndo) {
        final url = "$baseUrl/Sortlist_warehouse";
        final body = json.encode({
          "mobile": phoneNumber,
          "Warehouse_uid": warehouseId.toString(),
          "Type": "Shortlisted"
        });

        final headers = {"Content-Type": "application/json"};

        // Printing the URL, body, and headers for debugging
        print("URL: $url");
        print("Request Body: $body");
        print("Headers: $headers");

        final response = await http.post(Uri.parse(url), body: body, headers: headers);

        // Printing the response status code and body for debugging
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode != 200 || json.decode(response.body)['status'] != 200) {
          print("Response code for shortlist: ${response.body}");
          throw Exception("Failed to toggle shortlist status");
        }
      }

      // Update local state
      _shortlistedWarehouses[warehouseId] = !isCurrentlyShortlisted;
      notifyListeners();

      // Show appropriate snackbar based on current status
      if (!isCurrentlyShortlisted && !isUndo) {
        print("Warehouse added to shortlist");
        showCustomSnackbar(
          context,
          message: "Added to shortlist",
          actionLabel: "View",
          action: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => userShortlistedIntrested()));
          },
        );
      } else if (isCurrentlyShortlisted && !isUndo) {
        print("Warehouse removed from shortlist");
        showCustomSnackbar(
          context,
          message: "Removed from shortlist",
          actionLabel: "Undo",
          action: () {
            // Undo removal
            toggleWarehouse(warehouseId, phoneNumber, context, isUndo: true);
          },
        );
      }
    } catch (e) {
      print("Error toggling shortlist: $e");
    }
  }


  void showCustomSnackbar(
      BuildContext context, {
        required String message,
        String? actionLabel,
        VoidCallback? action,
      }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      action: actionLabel != null && action != null
          ? SnackBarAction(
        label: actionLabel,
        onPressed: action,
        textColor: actionLabel.toLowerCase() == "view"
            ? Colors.greenAccent
            : Colors.red,
      )
          : null,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.blue.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }




}
