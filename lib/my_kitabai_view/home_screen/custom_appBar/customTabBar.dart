import 'package:mains/app_imports.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;

  const CustomTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    TabControllerManager tabControllerManager;
    try {
      tabControllerManager = Get.find<TabControllerManager>();
      if (!tabControllerManager.isControllerValid) {
        tabControllerManager.setTabController(tabController);
      }
    } catch (e) {
      tabControllerManager = Get.put(TabControllerManager(tabController));
    }

    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            Expanded(
              child: CustomTabButton(
                isSelected: tabControllerManager.selectedIndex.value == 0,
                onTap: () => tabControllerManager.animateTo(0),
                icon: Icon(
                  Icons.auto_awesome,
                  size: 32,
                  color:
                      tabControllerManager.selectedIndex.value == 0
                          ? CustomColors.meeting
                          : Colors.grey,
                ),
                label: 'AI WorkBooks',
              ),
            ),
            Expanded(
              child: CustomTabButton(
                isSelected: tabControllerManager.selectedIndex.value == 1,
                onTap: () => tabControllerManager.animateTo(1),
                icon: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    tabControllerManager.selectedIndex.value == 1
                        ? CustomColors.meeting
                        : Colors.black,
                    BlendMode.srcIn,
                  ),
                  child: CustomLoopingGif(
                    assetPath: 'assets/gif/aiBookgif.gif',
                    height: 48,
                    width: 48,
                    fit: BoxFit.contain,
                  ),
                ),
                label: 'AI Tests',
              ),
            ),
            Expanded(
              child: CustomTabButton(
                isSelected: tabControllerManager.selectedIndex.value == 2,
                onTap: () => tabControllerManager.animateTo(2),
                icon: Lottie.asset(
                  'assets/lottie/book_loading.json',
                  height: 48,
                  width: 48,
                  fit: BoxFit.contain,
                  delegates: LottieDelegates(
                    values: [
                      ValueDelegate.color(
                        const ['**'],
                        value:
                            tabControllerManager.selectedIndex.value == 2
                                ? CustomColors.meeting
                                : Colors.grey,
                      ),
                    ],
                  ),
                ),
                label: 'AI Books',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTabButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget icon;
  final String label;

  const CustomTabButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform:
            isSelected
                ? Matrix4.translationValues(0, -8, 0)
                : Matrix4.translationValues(0, 0, 0),
        curve: Curves.easeOutBack,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ICON
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: SizedBox(height: 48, width: 48, child: icon),
            ),

            // LABEL (tight font height)
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: isSelected ? CustomColors.meeting : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                height: 1.0, // Tighter line height
              ),
              textAlign: TextAlign.center,
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
                applyHeightToLastDescent: false,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
