import 'package:mains/app_imports.dart';

class WorkBookCategoryController extends GetxController {
  // View state management
  var isGrid = true.obs;

  // Methods for managing view state
  void toggleView() {
    isGrid.value = !isGrid.value;
  }

  void setGridView() {
    isGrid.value = true;
  }

  void setListView() {
    isGrid.value = false;
  }
}
