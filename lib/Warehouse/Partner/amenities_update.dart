import 'package:Lisofy/Warehouse/Partner/UpdateWarehouseDimensions.dart';
import 'package:Lisofy/Warehouse/Partner/models/warehouses_model.dart';
import 'package:Lisofy/generated/l10n.dart';
import 'package:flutter/material.dart';

class AmenitiesUpdate extends StatefulWidget {
  final Warehouse warehouse;
  const AmenitiesUpdate({super.key, required this.warehouse});

  @override
  State<AmenitiesUpdate> createState() => _AmenitiesUpdateState();
}
class _AmenitiesUpdateState extends State<AmenitiesUpdate> {
  final TextEditingController electricityController = TextEditingController();
  final TextEditingController tenantsController = TextEditingController();
  final TextEditingController toiletsController = TextEditingController();
  final TextEditingController parkingSlotsController = TextEditingController();
  final TextEditingController constructionAgeController = TextEditingController();
  final TextEditingController bikeSlotsController = TextEditingController();
  final TextEditingController fansController = TextEditingController();
  final TextEditingController lightsController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _numberOfToilets = 0;
  String powerBackup = '';
  String provideOffice = '';
  String dockLevelers = '';
  String fireComplaint = '';
  String cluDocument = '';



  @override
  void initState() {
    super.initState();
    fireComplaint = widget.warehouse.fireComplaints ? "Yes" : "No";
    powerBackup = widget.warehouse.powerBackup ? "Yes" : "No";
    provideOffice = widget.warehouse.officeSpace ? "Yes" : "No";
    cluDocument = widget.warehouse.cluDocument ? "Yes" : "No";
    dockLevelers = widget.warehouse.dockLevelers ? "Yes" : "No";

    _numberOfToilets=widget.warehouse.numberOfToilets;
    // _maintenanceCost.text=widget.warehouse.whouseMaintenance.toString();
    electricityController.text=widget.warehouse.electricity;
    bikeSlotsController.text=widget.warehouse.bikeParkingSlot.toString();
    parkingSlotsController.text=widget.warehouse.truckParkingSlot.toString();
    lightsController.text=widget.warehouse.numberOfLights.toString();
    fansController.text=widget.warehouse.numberOfFans.toString();


  }



  void _increase() {
    setState(() {
      _numberOfToilets++;
    });
  }

  void _decrease() {
    if (_numberOfToilets > 0) {
      setState(() {
        _numberOfToilets--;
      });
    }
  }

  Widget buildToggleButtons(String title, String selectedValue, Function(String) onSelected) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: screenHeight*0.015, horizontal: screenWidth*0.037),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: screenHeight*0.01),
          Row(
            children: [
              buildToggleButton('Yes', selectedValue, onSelected),
              SizedBox(width: screenWidth*0.03),
              buildToggleButton('No', selectedValue, onSelected),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildToggleButton(String label, String selectedValue, Function(String) onSelected) {
    bool isActive = label == selectedValue;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => onSelected(label),
      child: Container(
        width: screenWidth*0.1,
        height: screenHeight*0.03,
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

  Widget buildTextField({required String label, required TextEditingController controller, String hint = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          TextFormField(
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is required';
              }
              return null; // Return null if valid
            },
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
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
            padding:  EdgeInsets.only(left: screenWidth*0.05, top: screenHeight*0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Row(
                  children: [
                    InkWell(child: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white)
                      ,onTap: ()=>Navigator.pop(context),
                    ),
                    SizedBox(width: screenWidth*0.02),
                     Text(S.of(context).edit_warehouse_details, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
                SizedBox(height: screenHeight*0.03),
                 Text(" ${S.of(context).update_warehouse_amenities} 3/4", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildToggleButtons(S.of(context).fire_noc, fireComplaint, (value) => setState(() => fireComplaint = value)),
                      buildToggleButtons(S.of(context).have_clu_document, cluDocument, (value) => setState(() => cluDocument = value)),
                      buildTextField(label: "${S.of(context).electricity_in_kva} *", controller: electricityController, hint: 'ex.440'),
                      buildTextField(label: "${S.of(context).num_of_fans}*", controller: fansController, hint: 'ex. 23'),
                      buildTextField(label: "${S.of(context).num_of_lights}*", controller: lightsController, hint: 'ex. 23'),
                      buildToggleButtons(S.of(context).warehouse_power_backup, powerBackup, (value) => setState(() => powerBackup = value)),
                      // buildTextField(label: "Previous Tenants", controller: tenantsController, hint: 'ex. Amazon, 2 yrs contact details'),
                      buildToggleButtons(S.of(context).provide_office_space, provideOffice, (value) => setState(() => provideOffice = value)),
                      buildToggleButtons(S.of(context).warehouse_dock_levelers, dockLevelers, (value) => setState(() => dockLevelers = value)),
                      // buildTextField(label: "No. of Toilets*", controller: toiletsController, hint: 'ex. 23'),
                      Row(children: [
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: screenHeight*0.015, horizontal: screenWidth*0.037),
                          child:  Text(S.of(context).num_of_toilets,style: const TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w600),),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 17),
                          height: 20,
                          width: 82, // Adjusted width
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(1),
                            color: Colors.blue,
                            border:
                            Border.all(color: Colors.blue),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: _decrease,
                                child: Container(
                                  width:
                                  25, // Width for minus button
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '-',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors
                                            .red),
                                  ),
                                ),
                              ),
                              Container(
                                width:
                                30,
                                color: Colors.blue,
                                alignment: Alignment.center,
                                child: Text(
                                  '$_numberOfToilets',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors
                                          .white),
                                ),
                              ),
                              GestureDetector(
                                onTap: _increase,
                                child: Container(
                                  width:
                                  25, // Width for plus button
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '+',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors
                                            .green), // Adjusted font size
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],),
                      buildTextField(label: "${S.of(context).truck_parking_slots} *", controller: parkingSlotsController, hint: 'ex. 23'),
                      //buildTextField(label: "Construction age*", controller: constructionAgeController, hint: 'ex. 23 Years'),
                      buildTextField(label: "${S.of(context).bike_parking_slots}*", controller: bikeSlotsController, hint: 'ex. 23'),

                      SizedBox(height: screenHeight*0.02),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: screenWidth*0.4,
                            height: screenHeight*0.05,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                // Validate all fields
                                if (!_formKey.currentState!.validate()) {
                                  // Show an error message if validation fails
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please fill all required fields')),
                                  );
                                  return; // Stop execution if validation fails
                                }
                                // Proceed if validation is successful
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateWarehouseDimensions(
                                      electricity: electricityController.text,
                                      tenants: tenantsController.text,
                                      toilets: _numberOfToilets,
                                      parkingSlots: parkingSlotsController.text,
                                      constructionAge: constructionAgeController.text,
                                      bikeSlots: bikeSlotsController.text,
                                      fans: int.parse(fansController.text.trim())??0,
                                      lights: int.parse(lightsController.text.trim())??0,
                                      powerBackup: powerBackup,
                                      provideOffice: provideOffice,
                                      dockLevelers: dockLevelers,
                                      fireComplaint: fireComplaint,
                                      cluDocument: cluDocument,
                                      Id: widget.warehouse.wHouseId,
                                      warehouse: widget.warehouse,
                                    ),
                                  ),
                                );
                              },
                              child:  Text(S.of(context).save, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
