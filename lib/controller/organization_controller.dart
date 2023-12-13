import 'package:flutter/cupertino.dart';
import '../helper/database_helper.dart';
import '../models/organization_model.dart';

class OrganizationController extends ChangeNotifier {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<OrganizationModel> _organizations = [];
  String? _selectedOrganization;
  double? _selectedOrganizationPrice;

  List<OrganizationModel> get organizations => _organizations;
  int get organizationCount => _organizations.length;
  String? get selectedOrganization => _selectedOrganization;
  double? get selectedOrganizationPrice => _selectedOrganizationPrice;


  // Fetch organizations
  Future<void> fetchOrganizations() async {
    List<OrganizationModel> fetchedOrganizations = await databaseHelper.getOrganizations();
    _organizations = fetchedOrganizations;
    if (_organizations.length == 1) {
      print(_organizations[0].organizationName);
      print(_organizations[0].orgPrice);
      _selectedOrganization = _organizations[0].organizationName;
      _selectedOrganizationPrice = double.parse(_organizations[0].orgPrice);
    }
    notifyListeners();
  }

  selectedOrg({required String orgName, required orgPrice}){
    _selectedOrganization = orgName;
    _selectedOrganizationPrice = orgPrice;
    notifyListeners();
  }


  // // Insert a new organization
  // void insertOrganization(String organization) {
  //   _organizations.add(organization);
  //   notifyListeners();
  // }

  // Delete an organization
  void deleteOrganization(String organization) {
    databaseHelper.deleteOrganization(organization);
    if (_selectedOrganization == organization) {
      _selectedOrganization = null;
      _selectedOrganizationPrice = null;
    }
    fetchOrganizations();
    notifyListeners();
  }

   String calculateTotalWages(Duration duration, double orgPrice) {
    double durationInHours = duration.inMinutes / 60.0;
    // Calculate total wages
    double totalWages = durationInHours * orgPrice;

    return totalWages.toStringAsFixed(2);
  }
}