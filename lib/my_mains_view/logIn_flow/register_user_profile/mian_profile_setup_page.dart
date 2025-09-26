import '../../../app_imports.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  late ProfileSetupController controller;

  @override
  void initState() {
    controller = Get.put(ProfileSetupController());
    super.initState();
  }

  final Color primaryColor = Color(0xFF6C63FF);
  final Color secondaryColor = Colors.white;
  final Color successColor = Color(0xFF4CAF50);
  final Color errorColor = Color(0xFFF44336);
  final Color activeChipColor = Color(0xFF6C63FF).withOpacity(0.2);
  final Color inactiveChipColor = Colors.grey.shade100;
  final Color textColor = Color(0xFF333333);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Complete Your Profile",
          style: GoogleFonts.poppins(
            color: secondaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: CustomColors.primaryColor,
        iconTheme: IconThemeData(color: secondaryColor),
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            elevation: 9,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(
                    context,
                  ).colorScheme.copyWith(primary: Colors.green),
                ),
                child: Stepper(
                  currentStep: controller.currentStep.value,
                  onStepContinue: () {
                    if (controller.isStepValid(controller.currentStep.value)) {
                      controller.updateStepCompletion();
                      controller.nextStep();
                    } else {
                      Get.snackbar(
                        'Incomplete Step',
                        'Please complete the required fields before continuing.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: errorColor,
                        colorText: Colors.white,
                      );
                    }
                  },

                  onStepCancel: controller.previousStep,
                  onStepTapped:
                      (step) => controller.currentStep.value = step.clamp(0, 5),
                  controlsBuilder:
                      (context, details) => Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (controller.currentStep.value != 0)
                              OutlinedButton(
                                onPressed: details.onStepCancel,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: errorColor,
                                  side: BorderSide(color: errorColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  "Back",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ElevatedButton(
                              onPressed: details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                controller.currentStep.value == 5
                                    ? "Submit"
                                    : "Next",
                                style: GoogleFonts.poppins(
                                  color: secondaryColor,

                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  steps: [
                    _buildFullNameStep(),
                    _buildAgeStep(),
                    _buildExamStep(),
                    _buildGenderStep(),
                    _buildLanguageStep(),
                    _buildAddressStep(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.cityController.dispose();
    controller.pincodeController.dispose();
    super.dispose();
  }

  Step _buildFullNameStep() {
    return Step(
      title: _stepTitle("Full Name", 0),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What should we call you?",
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: controller.formKeys[0],
              child: TextFormField(
                onChanged: (value) {
                  controller.fullName.value = value;
                  controller.updateStepCompletion();
                },
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  hintText: "Enter full name",
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: Icon(Icons.person_outline, color: primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
      isActive: controller.currentStep.value >= 0,
      state: controller.getStepState(0),
    );
  }

  Step _buildAgeStep() {
    return Step(
      title: _stepTitle("Age", 1),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select your age group",
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children:
                controller.ageOptions.map((ageOption) {
                  return FilterChip(
                    label: Text(
                      ageOption,
                      style: GoogleFonts.poppins(
                        color:
                            controller.selectedAge.value == ageOption
                                ? primaryColor
                                : textColor,
                      ),
                    ),
                    selected: controller.selectedAge.value == ageOption,
                    onSelected: (selected) {
                      controller.selectedAge.value =
                          selected ? ageOption : null;
                      controller.age.value = ageOption;
                      controller.updateStepCompletion();
                    },
                    selectedColor: activeChipColor,
                    backgroundColor: inactiveChipColor,
                    checkmarkColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    showCheckmark: true,
                    elevation: 0,
                  );
                }).toList(),
          ),
        ],
      ),
      isActive: controller.currentStep.value >= 1,
      state: controller.getStepState(1),
    );
  }

  Step _buildExamStep() {
    return Step(
      title: _stepTitle("Exam Focus", 2),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What are you preparing for?",
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Select category",
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                controller.examTypes.map((category) {
                  final isSelected = controller.selectedCategories.contains(
                    category,
                  );

                  return FilterChip(
                    label: Text(
                      category,
                      style: GoogleFonts.poppins(
                        color: isSelected ? primaryColor : textColor,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        if (controller.selectedCategories.length < 3) {
                          controller.selectedCategories.add(category);
                        }
                        // else ignore or show message
                      } else {
                        controller.selectedCategories.remove(category);
                      }
                      // Clear related fields if needed
                      controller.selectedExam.value = null;
                      controller.exam.value = "";
                      controller.updateStepCompletion();
                    },
                    selectedColor: activeChipColor,
                    backgroundColor: inactiveChipColor,
                    checkmarkColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    showCheckmark: true,
                    elevation: 0,
                  );
                }).toList(),
          ),

          // Show TextField if "Others" is selected
          if (controller.selectedCategories.contains('Others')) ...[
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: "Please specify",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                controller.otherExamInput.value = value;
                controller.updateStepCompletion();
              },
            ),
          ],
        ],
      ),
      isActive: controller.currentStep.value >= 2,
      state: controller.getStepState(2),
    );
  }

  Step _buildGenderStep() {
    return Step(
      title: _stepTitle("Gender", 3),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How do you identify yourself?",
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children:
                controller.genderOptions.map((gender) {
                  return FilterChip(
                    label: Text(
                      gender,
                      style: GoogleFonts.poppins(
                        color:
                            controller.selectedGender.value == gender
                                ? primaryColor
                                : textColor,
                      ),
                    ),
                    selected: controller.selectedGender.value == gender,
                    onSelected: (selected) {
                      controller.selectedGender.value =
                          selected ? gender : null;
                      controller.gender.value = gender;
                      controller.updateStepCompletion();
                    },
                    selectedColor: activeChipColor,
                    backgroundColor: inactiveChipColor,
                    checkmarkColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    showCheckmark: true,
                    elevation: 0,
                  );
                }).toList(),
          ),
        ],
      ),
      isActive: controller.currentStep.value >= 3,
      state: controller.getStepState(3),
    );
  }

  Step _buildLanguageStep() {
    return Step(
      title: _stepTitle("Native Language", 4),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's your primary language?",
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children:
                controller.languageOptions.map((lang) {
                  return FilterChip(
                    label: Text(
                      lang,
                      style: GoogleFonts.poppins(
                        color:
                            controller.selectedLanguage.value == lang
                                ? primaryColor
                                : textColor,
                      ),
                    ),
                    selected: controller.selectedLanguage.value == lang,
                    onSelected: (selected) {
                      controller.selectedLanguage.value =
                          selected ? lang : null;
                      controller.nativeLanguage.value = lang;
                      controller.updateStepCompletion();
                    },
                    selectedColor: activeChipColor,
                    backgroundColor: inactiveChipColor,
                    checkmarkColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    showCheckmark: true,
                    elevation: 0,
                  );
                }).toList(),
          ),
        ],
      ),
      isActive: controller.currentStep.value >= 4,
      state: controller.getStepState(4),
    );
  }

  Step _buildAddressStep() {
    return Step(
      title: _stepTitle("Address", 5),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Where are you located?",
            style: GoogleFonts.poppins(
              color: textColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),

          // City
          Text(
            "City",
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller.cityController,
              textInputAction: TextInputAction.next,
              style: GoogleFonts.poppins(),
              onChanged: (_) => controller.updateStepCompletion(),
              decoration: InputDecoration(
                hintText: "Enter your city",
                hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                prefixIcon: const Icon(
                  Icons.location_city_outlined,
                  color: Colors.blueGrey,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 12),
          Text(
            "Pincode",
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller.pincodeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: GoogleFonts.poppins(),
              onChanged: (_) => controller.updateStepCompletion(),
              decoration: InputDecoration(
                counterText: "",
                hintText: "Enter pincode",
                hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                prefixIcon: const Icon(
                  Icons.pin_drop_outlined,
                  color: Colors.blueGrey,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
      isActive: controller.currentStep.value >= 5,
      state: controller.getStepState(5),
    );
  }

  Widget _stepTitle(String text, int index) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Step ${index + 1}",
            style: GoogleFonts.poppins(
              color:
                  controller.currentStep.value >= index
                      ? primaryColor
                      : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            text,
            style: GoogleFonts.poppins(
              color:
                  controller.currentStep.value >= index
                      ? textColor
                      : Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
