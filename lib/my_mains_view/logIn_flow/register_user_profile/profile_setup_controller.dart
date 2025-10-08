import '../../../app_imports.dart';
import '../../../common/decider.dart';
import 'package:http/http.dart' as http;

class ProfileSetupController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  RxBool isLoading = false.obs;
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
  }

  final currentStep = 0.obs;
  final selectedCategories = <String>[].obs;
  var otherExamInput = ''.obs;
  final selectedExam = RxnString();
  final selectedLanguage = RxnString();
  final selectedGender = RxnString();
  final selectedAge = RxnString();

  final fullName = ''.obs;
  final gender = ''.obs;
  final nativeLanguage = ''.obs;
  final exam = ''.obs;
  final age = ''.obs;

  final stepCompleted = List<bool>.filled(6, false).obs;

  final formKeys = List.generate(6, (_) => GlobalKey<FormState>());

  final List<String> examTypes = [
    'UPSC',
    'JPSC',
    'MPPCS',
    'RAS',
    'BPSC',
    'UPPCS',
    'Teacher',
    'CA',
    'CMA',
    'CS',
    'NET/JRF',
    'SSC',
    'Judiciary',
  ];

  final ageOptions = ['<15', '15-18', '19-25', '26-31', '32-40', '40+'];
  final languageOptions = ['Hindi', 'English', 'Bengali', 'Tamil', 'Other'];
  final genderOptions = ['Male', 'Female'];

  bool isStepValid(int step) {
    switch (step) {
      case 0:
        return fullName.value.trim().isNotEmpty;
      case 1:
        return selectedAge.value != null;
      case 2:
        return selectedCategories.isNotEmpty &&
            (!selectedCategories.contains('Others') ||
                otherExamInput.value.trim().isNotEmpty);
      case 3:
        return selectedGender.value != null;
      case 4:
        return selectedLanguage.value != null;
      case 5:
        final city = cityController.text.trim();
        final pin = pincodeController.text.trim();
        final pinValid = RegExp(r'^\d{6}$').hasMatch(pin);
        return city.isNotEmpty && pinValid;
      default:
        return false;
    }
  }

  void updateStepCompletion() {
    stepCompleted[0] = fullName.isNotEmpty;
    stepCompleted[1] = selectedAge.value != null;
    stepCompleted[2] =
        selectedCategories.isNotEmpty && selectedExam.value != null;
    stepCompleted[3] = selectedGender.value != null;
    stepCompleted[4] = selectedLanguage.value != null;
    stepCompleted[5] =
        cityController.text.trim().isNotEmpty &&
        RegExp(r'^\d{6}$').hasMatch(pincodeController.text.trim());
    stepCompleted.refresh();
  }

  void nextStep() {
    if (currentStep.value < 5) {
      currentStep.value += 1;
    } else {
      updateStepCompletion();
      sendProfileData();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) currentStep.value -= 1;
  }

  StepState getStepState(int step) {
    if (currentStep.value > step) return StepState.complete;
    if (currentStep.value == step) return StepState.editing;
    return StepState.indexed;
  }

  @override
  void onClose() {
    cityController.dispose();
    pincodeController.dispose();
    super.onClose();
  }

  Future<void> sendProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(Constants.authToken);

    const String url = ApiUrls.getProfile;

    final Map<String, dynamic> data = {
      "name": fullName.value,
      "age": selectedAge.value ?? '',
      "gender": selectedGender.value ?? '',
      "exams":
          selectedCategories.map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      "native_language": selectedLanguage.value ?? '',
      "city": cityController.text.trim(),
      "pincode": pincodeController.text.trim(),
    };


    try {
      showSmallLoadingDialog();
      await callWebApi(
        null,
        url,
        data,
        onResponse: (response) async {
          if (response.statusCode == 200 || response.statusCode == 201) {
            // Mark profile complete and add transient flag to avoid immediate redirect
            await prefs.setBool('is_profile_complete', true);
            await prefs.setBool('profile_just_completed', true);
            Get.offAll(() => const Decider());
          } else if (response.statusCode == 401 || response.statusCode == 403) {
            SharedPreferences.getInstance().then((prefs) async {
              await prefs.clear();
              Get.offAll(() => UseerLogInScreen());
            });
          } else {
          }
        },
        onError: () {
        },
        token: authToken ?? '',
        showLoader: false,
        hideLoader: false,
      );
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
      isLoading.value = false;
    }
  }
}

class ProfileSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileSetupController());
  }
}
