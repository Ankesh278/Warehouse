import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/User/userShortlistedintrested.dart';

class CartProvider with ChangeNotifier {
  final String baseUrl = "https://xpacesphere.com/api/Wherehousedt";
  final Map<int, bool> _shortlistedWarehouses = {};

  // Getter to check if a warehouse is shortlisted
  bool isShortlisted(int warehouseId) => _shortlistedWarehouses[warehouseId] ?? false;

  // Fetch shortlist status for a warehouse
  Future<void> fetchShortlistStatus(int warehouseId, String phoneNumber) async {
    try {
      final url = "$baseUrl/GetSortlist_warehouse?_mobile=$phoneNumber&Id=$warehouseId";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 200 && data['data'] is List && data['data'].isNotEmpty) {
          final type = data['data'][0]['type'];
          _shortlistedWarehouses[warehouseId] = (type == "Shortlist");
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
      if (!isUndo) {
        final url = "$baseUrl/Sortlist_warehouse";
        final body = json.encode({
          "mobile": phoneNumber,
          "Warehouse_uid": warehouseId.toString(),
        });

        final headers = {"Content-Type": "application/json"};
        final response =
        await http.post(Uri.parse(url), body: body, headers: headers);

        if (response.statusCode != 200 || json.decode(response.body)['status'] != 200) {
          throw Exception("Failed to toggle shortlist status");
        }
      }

      // Update local state
      _shortlistedWarehouses[warehouseId] = !isCurrentlyShortlisted;
      notifyListeners();

      if (!isCurrentlyShortlisted && !isUndo) {
        // Show added snackbar
        showCustomSnackbar(
          context,
          message: "Added to shorlist",
          actionLabel: "View",
          action: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>userShortlistedIntrested()));
          },
        );
      } else if (isCurrentlyShortlisted && !isUndo) {
        // Show removed snackbar with undo
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
