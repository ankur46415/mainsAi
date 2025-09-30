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
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with gradient background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CustomColors.gradientBueStart,
                        CustomColors.gradientBueEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Profile',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 24),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),

                // Form content
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Name field
                        _buildFormField(
                          controller: nameController,
                          label: 'Name',
                          hint: 'Enter your full name',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20),

                        // Gender dropdown
                        Obx(
                          () => _buildDropdownField(
                            label: 'Gender',
                            value: selectedGender.value,
                            items: genderOptions,
                            onChanged: (value) => selectedGender.value = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a gender';
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(height: 20),

                        // Language dropdown
                        Obx(
                          () => _buildDropdownField(
                            label: 'Native Language',
                            value: selectedLanguage.value,
                            items: languageOptions,
                            onChanged:
                                (value) => selectedLanguage.value = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a language';
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(height: 20),

                        // Age dropdown
                        Obx(
                          () => _buildDropdownField(
                            label: 'Age Group',
                            value: selectedAge.value,
                            items: ageOptions,
                            onChanged: (value) => selectedAge.value = value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an age group';
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(height: 24),

                        // Exams section
                        Obx(() => _buildExamsSection()),

                        SizedBox(height: 32),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(child: _buildCancelButton()),
                            SizedBox(width: 16),
                            Expanded(child: _buildSaveButton()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 300),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required FormFieldValidator<String> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: CustomColors.textColor,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: CustomColors.primaryColor,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required FormFieldValidator<String> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: CustomColors.textColor,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: CustomColors.primaryColor,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildExamsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exams (Select up to 3)',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: CustomColors.textColor,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              examOptions.map((exam) {
                final isSelected = selectedExams.contains(exam);
                return FilterChip(
                  label: Text(
                    exam,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : CustomColors.textColor,
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
                  selectedColor: CustomColors.primaryColor,
                  checkmarkColor: Colors.white,
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color:
                          isSelected
                              ? CustomColors.primaryColor
                              : Colors.grey[300]!,
                      width: 1,
                    ),
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
                color: CustomColors.errorRed,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return Container(
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: CustomColors.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () => Get.back(),
        child: Text(
          'Cancel',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: CustomColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
          elevation: 2,
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
            final bool success = await updateUserProfile(updatedProfileData);
            if (success && (Get.isDialogOpen ?? false)) {
              Get.back();
            }
          }
        },
        child: Text(
          'Save Changes',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
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
