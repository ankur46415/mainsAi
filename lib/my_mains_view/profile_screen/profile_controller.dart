import 'package:mains/app_imports.dart';
import '../../models/profile_model.dart';

class ProfileController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;

  var userProfile = Rxn<ProfileData>();
  final isLoading = true.obs;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final selectedGender = RxnString();
  final selectedLanguage = RxnString();
  final selectedAge = RxnString();
  final selectedExams = <String>[].obs;

  final genderOptions = ['Male', 'Female', 'Other'];
  final languageOptions = ['Hindi', 'English', 'Bengali', 'Tamil', 'Other'];
  final ageOptions = ['<15', '15-18', '19-25', '26-31', '32-40', '40+'];
  final List<String> examOptions = [
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

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    await fetchUserProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  void initializeEditProfile() {
    final profile = userProfile.value?.profile;
    if (profile == null) return;
    nameController.text = profile.name ?? '';
    selectedGender.value = profile.gender;
    selectedLanguage.value = profile.nativeLanguage;
    selectedAge.value = profile.age;
    selectedExams.value = profile.exams ?? [];
  }

  void showEditProfileDialog() {
    initializeEditProfile();
    final dialogKey = GlobalKey();
    Get.dialog(
      Dialog(
        key: dialogKey,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Profile',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                Divider(height: 24, thickness: 1),
                SizedBox(height: 8),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        height: Get.width * 0.12,
                        child: TextFormField(
                          controller: nameController,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Obx(
                        () => Container(
                          height: Get.width * 0.12,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              labelStyle: GoogleFonts.poppins(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            value: selectedGender.value,
                            items:
                                genderOptions.map((String gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender,
                                    child: Text(
                                      gender,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              selectedGender.value = newValue;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a gender';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Obx(
                        () => Container(
                          height: Get.width * 0.12,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Language',
                              labelStyle: GoogleFonts.poppins(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            value: selectedLanguage.value,
                            items:
                                languageOptions.map((String language) {
                                  return DropdownMenuItem<String>(
                                    value: language,
                                    child: Text(
                                      language,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              selectedLanguage.value = newValue;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a language';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Obx(
                        () => Container(
                          height: Get.width * 0.12,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Age Group',
                              labelStyle: GoogleFonts.poppins(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            value: selectedAge.value,
                            items:
                                ageOptions.map((String age) {
                                  return DropdownMenuItem<String>(
                                    value: age,
                                    child: Text(
                                      age,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              selectedAge.value = newValue;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an age group';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Exams',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 8,
                              children:
                                  examOptions.map((exam) {
                                    final isSelected = selectedExams.contains(
                                      exam,
                                    );
                                    return FilterChip(
                                      label: Text(
                                        exam,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.black,
                                        ),
                                      ),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        if (selected) {
                                          if (selectedExams.length < 3) {
                                            selectedExams.add(exam);
                                          }
                                        } else {
                                          selectedExams.remove(exam);
                                        }
                                      },
                                      selectedColor: Colors.blue.withAlpha(20),
                                      checkmarkColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    );
                                  }).toList(),
                            ),
                            if (selectedExams.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Please select at least one exam',
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => Get.back(),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  if (selectedExams.isEmpty) return;
                                  final updatedProfileData = {
                                    'name': nameController.text.trim(),
                                    'gender': selectedGender.value,
                                    'native_language': selectedLanguage.value,
                                    'age': selectedAge.value,
                                    'exams': selectedExams,
                                  };
                                  final bool success = await updateUserProfile(
                                    updatedProfileData,
                                  );
                                  if (success && (Get.isDialogOpen ?? false)) {
                                    Get.back();
                                  }
                                }
                              },
                              child: Text(
                                'Save',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
      transitionDuration: Duration.zero,
    );
  }

  Future<void> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    isLoading.value = true;
    if (authToken == null) {
      isLoading.value = false;
      return;
    }
    final url = ApiUrls.getProfile;
    await callWebApiGet(
      null,
      url,
      onResponse: (response) {
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final profileData = ProfileData.fromJson(jsonData);
          userProfile.value = profileData;
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          SharedPreferences.getInstance().then((prefs) async {
            await prefs.clear();
            Get.offAll(() => User_Login_option());
          });
        }
        isLoading.value = false;
      },
      onError: () {
        isLoading.value = false;
      },
      token: authToken,
      showLoader: false,
      hideLoader: false,
    );
  }

  Future<bool> updateUserProfile(Map<String, dynamic> updatedData) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    if (authToken == null) return false;

    final transformedData = {
      'name': updatedData['name']?.toString().trim(),
      'gender': updatedData['gender'],
      'native_language': updatedData['native_language'],
      'age': updatedData['age'],
      'exams': updatedData['exams'],
    };

    final url = ApiUrls.updateProfile;
    showSmallLoadingDialog();
    bool isSuccess = false;

    await callWebApiPut(
      null,
      url,
      transformedData,
      onResponse: (response) async {
        // Close the loading dialog first
        if (Get.isDialogOpen ?? false) Get.back();

        if (response.statusCode == 200) {
          await fetchUserProfile();
          isSuccess = true;

          // Now also close the edit profile dialog if still open
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
        }
      },
      onError: () {
        if (Get.isDialogOpen ?? false) Get.back();
      },
      token: authToken,
      showLoader: false,
      hideLoader: false,
    );

    return isSuccess;
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}
