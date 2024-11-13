import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  String? selectedFilter; // Tracks currently selected filter category
  Map<String, bool> selectedOptions = {}; // Tracks selected options for filters
  RangeValues rentRange = const RangeValues(0, 10000); // Rent range values

  // Set the selected filter type and options
  void selectFilter(String? filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  // Toggle an option for multi-choice filters
  void toggleOption(String option) {
    selectedOptions[option] = !(selectedOptions[option] ?? false);
    notifyListeners();
  }

  // Set rent range values
  void setRentRange(RangeValues range) {
    rentRange = range;
    notifyListeners();
  }
  // Clear all filters
  void clearFilters() {
    selectedFilter = null;
    selectedOptions.clear();
    rentRange = const RangeValues(0, 10000);
    notifyListeners();
  }

  // Apply filters (you might call an API or fetch data based on these filters)
  void applyFilters() {
    // Example: Fetch data based on current filter settings
    // e.g., fetchData(selectedOptions, rentRange)
    notifyListeners();
  }
}
