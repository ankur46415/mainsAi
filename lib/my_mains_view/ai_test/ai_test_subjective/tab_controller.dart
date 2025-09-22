import 'package:get/get.dart';

class TestTabController extends GetxController {
  var selectedSubcategories = <String, String>{}.obs;

  void setSelected(String category, String subCategory) {
    selectedSubcategories[category] = subCategory;
  }

  String? getSelected(String category) => selectedSubcategories[category];
}
