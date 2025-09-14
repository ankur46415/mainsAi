import 'package:http/http.dart' as http;
import 'package:mains/app_imports.dart';

class VoiceScreen extends StatefulWidget {
  final bool initialChatMode;
  final bool isFromBottomNav;
  final String? questionId;
  final String? welcomeAiMessages;
  final String? welcomeAiFAQsForChat;
  final bool? isRagChatAvailable;

  const VoiceScreen({
    super.key,
    this.initialChatMode = false,
    this.isFromBottomNav = false,
    this.questionId,
    this.welcomeAiMessages,
    this.welcomeAiFAQsForChat,
    this.isRagChatAvailable,
  });

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen>
    with AutomaticKeepAliveClientMixin {
  late VoiceController controller;
  bool _isControllerInitialized = false;
  late AudioPlayer welcomePlayer;
  bool showWelcome = true;

  List<FAQs> get initialFaqs {
    if (widget.welcomeAiFAQsForChat == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(widget.welcomeAiFAQsForChat!);
      return decoded.map((e) => FAQs.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();

    _initializeController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final msg = widget.welcomeAiMessages;
      if (msg != null && msg.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 300));
        await controller.flutterTts.setLanguage(
          controller.selectedLanguageLabel.value,
        );
        await controller.flutterTts.speak(msg);
      }
    });
  }

  void _initializeController() {
    if (!_isControllerInitialized) {
      if (Get.isRegistered<VoiceController>()) {
        Get.delete<VoiceController>(force: true);
      }
      controller = Get.put(
        VoiceController(
          initialChatMode: widget.initialChatMode,
          questionId: widget.questionId,
          isRagChatAvailable: widget.isRagChatAvailable,
        ),
        permanent: widget.isFromBottomNav,
      );
      _isControllerInitialized = true;
    }
  }

  @override
  void dispose() {
    if (!widget.isFromBottomNav) {
      if (Get.isRegistered<VoiceController>()) {
        if (controller.speech.isListening) {
          controller.speech.stop();
        }
        if (controller.player?.playing ?? false) {
          controller.player?.stop();
        }
        Get.delete<VoiceController>(force: true);
      }
    }
    super.dispose();
  }

  @override
  bool get wantKeepAlive => widget.isFromBottomNav;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_isControllerInitialized) {
      _initializeController();
    }

    final theme = Theme.of(context);

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (!widget.isFromBottomNav) {
          if (controller.speech.isListening) {
            await controller.speech.stop();
          }
          if (controller.player?.playing ?? false) {
            await controller.player?.stop();
          }
          if (Get.isRegistered<VoiceController>()) {
            Get.delete<VoiceController>(force: true);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: _buildDrawer(),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color.fromARGB(255, 247, 201, 127),
                  Colors.white,
                ],
              ),
            ),
            child: Column(
              children: [
                _buildAppBar(context),
                if (widget.questionId != null)
                  Obx(() {
                    if (controller.isLoadingBookDetails.value) {
                      return Container(
                        margin: EdgeInsets.all(Get.width * 0.04),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(child: Text("Loading Book...")),
                      );
                    }

                    final book = controller.bookDetails.value;
                    if (book == null) return SizedBox.shrink();

                    return InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          builder: (context) => _buildBottomSheet(context),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: Get.width * 0.04,
                          right: Get.width * 0.04,
                          bottom: Get.width * 0.02,
                        ),
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  book.cover_image_url ?? '',
                                  height: Get.width * 0.16,
                                  width: Get.width * 0.14,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/bookb.png',
                                      height: Get.width * 0.16,
                                      width: Get.width * 0.14,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: Get.width * 0.04),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title ?? 'Untitled',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          book.examName ?? '',
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey[700],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        SizedBox(width: Get.width * 0.02),
                                        Text(
                                          book.paperName ?? '',
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey[700],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
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
                    );
                  }),

                Expanded(child: _buildChatList(controller, theme)),
                _buildBottomBar(controller, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    // Removed: final VoiceController controller = Get.find<VoiceController>();
    // Now using the controller from the state class directly

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: Get.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red.shade100,
                  radius: 32,
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.orange.shade800,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Settings',
                  style: GoogleFonts.poppins(
                    color: Colors.red.shade900,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Customize your experience',
                  style: GoogleFonts.poppins(
                    color: Colors.orange.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          Obx(() {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    ['Voices', 'Languages', 'History'].map((tab) {
                      final isSelected = controller.selectedTab.value == tab;
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.red.shade50
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border:
                              isSelected
                                  ? Border.all(
                                    color: Colors.orange.shade300,
                                    width: 1.5,
                                  )
                                  : null,
                        ),
                        child: GestureDetector(
                          onTap: () => controller.selectTab(tab),
                          child: Text(
                            tab,
                            style: GoogleFonts.poppins(
                              color:
                                  isSelected
                                      ? Colors.orange.shade800
                                      : Colors.grey.shade700,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            );
          }),

          // Tab Content
          Obx(() {
            final selected = controller.selectedTab.value;
            final items = controller.tabData[selected] ?? [];

            return Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: items.length,
                separatorBuilder:
                    (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (_, index) {
                  final item = items[index];
                  if (selected == 'Voices') {
                    return Obx(() {
                      final selectedKey = controller.voiceMapping.keys
                          .firstWhere(
                            (key) =>
                                controller.voiceMapping[key] ==
                                controller.selectedVoice.value,
                            orElse: () => '',
                          );
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color:
                              item == selectedKey
                                  ? Colors.red.shade50
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          title: Text(
                            item,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color:
                                  item == selectedKey
                                      ? Colors.red.shade800
                                      : Colors.grey.shade800,
                            ),
                          ),
                          trailing: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    item == selectedKey
                                        ? Colors.red.shade600
                                        : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                            child:
                                item == selectedKey
                                    ? Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.red.shade600,
                                    )
                                    : null,
                          ),
                          onTap: () => controller.selectVoice(item),
                        ),
                      );
                    });
                  } else if (selected == 'Languages') {
                    return Obx(() {
                      final selectedKey = controller.languageMapping.keys
                          .firstWhere(
                            (key) =>
                                controller.languageMapping[key] ==
                                controller.selectedLanguageLabel.value,
                            orElse: () => '',
                          );
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color:
                              item == selectedKey
                                  ? Colors.red.shade50
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          leading: Icon(
                            Icons.language,
                            color: Colors.red.shade600,
                          ),
                          title: Text(
                            item,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color:
                                  item == selectedKey
                                      ? Colors.red.shade800
                                      : Colors.grey.shade800,
                            ),
                          ),
                          trailing: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    item == selectedKey
                                        ? Colors.red.shade600
                                        : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                            child:
                                item == selectedKey
                                    ? Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.red.shade600,
                                    )
                                    : null,
                          ),
                          onTap: () => controller.selectLanguage(item),
                        ),
                      );
                    });
                  } else if (selected == 'History') {
                    // History tab - show chat history
                    return Obx(() {
                      if (controller.isLoadingHistory.value) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(color: Colors.red),
                                SizedBox(height: 12),
                                Text(
                                  'Loading chat history...',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (controller.chatHistory.isEmpty) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.chat_bubble_outline, 
                                     size: 48, 
                                     color: Colors.grey[400]),
                                SizedBox(height: 12),
                                Text(
                                  'No chat history found',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Start a conversation to see your history here',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.chatHistory.length,
                        itemBuilder: (context, index) {
                          final chat = controller.chatHistory[index];
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red.shade200,
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, 
                                vertical: 8,
                              ),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.red.shade600,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                chat.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red.shade800,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${chat.messageCount} messages',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.red.shade600,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red.shade400,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      _showDeleteDialog(chat.chatId, chat.title);
                                    },
                                    tooltip: 'Delete chat',
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.red.shade600,
                                  ),
                                ],
                              ),
                              onTap: () {
                                // TODO: Navigate to specific chat
                                debugPrint('Chat tapped: ${chat.chatId}');
                              },
                            ),
                          );
                        },
                      );
                    });
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Get.width * 0.02,
        left: Get.width * 0.05,
        right: Get.width * 0.05,
        bottom: Get.width * 0.03,
      ),
      child: Row(
        children: [
          Builder(
            builder:
                (context) => Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.menu, color: Colors.orange.shade800),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    padding: EdgeInsets.zero,
                    iconSize: 24,
                  ),
                ),
          ),

          SizedBox(width: Get.width * 0.05),

          Spacer(),

          SizedBox(width: Get.width * 0.05),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.qr_code_scanner, color: Colors.orange.shade800),
              onPressed: () {
                Get.toNamed(AppRoutes.getAsset);
              },

              padding: EdgeInsets.zero,
              iconSize: 24,
            ),
          ),
          SizedBox(width: 16),
          InkWell(
            onTap: () {
              if (widget.isFromBottomNav) {
                Get.find<BottomNavController>().currentIndex.value = 0;
              } else {
                Get.back();
              }
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.cancel, color: Colors.orange.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(VoiceController controller, ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(
        left: Get.width * 0.05,
        right: Get.width * 0.05,
        bottom: Get.width * 0.03,
      ),
      height: Get.height * 0.6,

      child: Obx(() {
        final messages = controller.messages;
        final showThinking = controller.showThinkingBubble.value;
        final List<Widget> chatBubbles = [];

        if (widget.isFromBottomNav && showWelcome && messages.isEmpty) {
          chatBubbles.add(
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 16.0,
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFC107),
                        Color.fromARGB(255, 236, 87, 87),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFFFFC107), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFFC107).withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school, color: Colors.white, size: 40),
                      const SizedBox(height: 12),
                      Text(
                        "Welcome to mAIns",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "UPSC / PCS Mains Answer Writing",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (messages.isEmpty) {
          final dynamicWelcome = widget.welcomeAiMessages;
          if (dynamicWelcome != null && dynamicWelcome.isNotEmpty) {
            chatBubbles.add(
              MessageBubble(
                message: dynamicWelcome,
                isUser: false,
                theme: theme,
              ),
            );
          }

          final faqs = initialFaqs;
          if (faqs.isNotEmpty) {
            chatBubbles.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.width * 0.35),
                  Text(
                    "Ask Anything",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children:
                        faqs.map((faq) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ActionChip(
                              label: Text(
                                faq.question ?? '',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: Colors.grey[200],
                              onPressed:
                                  () => controller.sendMessage(
                                    faq.question ?? '',
                                  ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            );
          }
        } else {
          for (final message in messages) {
            final isUser = message['sender'] == 'user';
            chatBubbles.add(
              MessageBubble(
                message: message['message'] ?? '',
                isUser: isUser,
                theme: theme,
              ),
            );
          }

          if (showThinking) {
            chatBubbles.add(
              MessageBubble(
                message: "Thinking...",
                isUser: false,
                theme: theme,
                isTyping: true,
              ),
            );
          }
        }

        return ListView(
          controller: controller.scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: chatBubbles,
        );
      }),
    );
  }

  Widget _buildBottomBar(VoiceController controller, ThemeData theme) {
    return Container(
      padding: EdgeInsets.only(
        bottom: Get.width * 0.03,
        right: Get.width * 0.03,
        left: Get.width * 0.03,
      ),

      child: Obx(() {
        final isListening = controller.isListening.value;
        final isProcessing =
            controller.isLoading.value || controller.isPlayingResponse.value;
        final isChatMode = controller.isChatMode.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  isChatMode ? Icons.mic : Icons.chat,
                  size: 18,
                  color: Color.fromARGB(255, 235, 176, 2),
                ),
                onPressed: () {
                  controller.toggleChatMode();
                },
              ),
            ),
            SizedBox(width: Get.width * 0.03),
            Expanded(
              child: Center(
                child:
                    isChatMode
                        ? Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: TextField(
                                  controller: controller.chatTextController,
                                  decoration: const InputDecoration(
                                    hintText: "Type a message",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showWelcome = false;
                                  });
                                  controller.sendChatMessage();
                                },
                              ),
                            ),
                          ],
                        )
                        : _buildMic(controller, isListening, isProcessing),
              ),
            ),
            isChatMode ? const SizedBox(width: 0) : const SizedBox(width: 20),
          ],
        );
      }),
    );
  }

  Widget _buildMic(
    VoiceController controller,
    bool isListening,
    bool isProcessing,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isListening ? 120 : 80,
      height: isListening ? 120 : 60,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isListening
                  ? [Color(0xFFFFC107), Color.fromARGB(255, 236, 87, 87)]
                  : [Color(0xFFFFC107), Color.fromARGB(255, 236, 87, 87)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFC107).withOpacity(isListening ? 0.4 : 0.3),
            blurRadius: isListening ? 20 : 10,
            spreadRadius: isListening ? 2 : 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(60),
          onTap:
              isProcessing
                  ? null
                  : () {
                    if (controller.isChatMode.value) {
                      controller.toggleChatMode();
                    } else {
                      controller.toggleListening();
                    }
                  },
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isListening)
                SpinKitSpinningLines(
                  color: Colors.white.withOpacity(0.6),
                  size: 100.0,
                ),
              Icon(
                isListening ? Icons.mic : Icons.mic_none,
                size: isListening ? 36 : 30,
                color: Colors.white,
              ),

              if (isListening)
                const Positioned(
                  bottom: 20,
                  child: Text(
                    "Listening...",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    final book = controller.bookDetails.value;

    final hasChapters = book?.chapters != null && book!.chapters!.isNotEmpty;
    final hasIndex = book?.index != null && book!.index!.isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📘 Book Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      book?.cover_image_url ?? '',
                      height: 90,
                      width: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/mains-logo.png',
                          height: 90,
                          width: 70,
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      book?.title ?? 'Untitled Book',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade300),

              Text(
                "📚 Chapters",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              if (hasChapters)
                ...book!.chapters!.map(_buildChapterTile).toList()
              else if (hasIndex)
                ...book!.index!.map(_buildIndexChapterTile).toList()
              else
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      "🚫 No chapters available.",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndexChapterTile(IndexChapter chapter) {
    return Card(
      color: Colors.white,
      elevation: 7,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.only(
            left: 16,
            bottom: 12,
            right: 12,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  chapter.chapterName ?? 'Untitled Chapter',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: Get.width * 0.05),
                child: Container(
                  width: Get.width * 0.07,
                  height: Get.width * 0.07,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      icon: const Icon(Icons.remove_red_eye, color: Colors.red),
                      tooltip: 'Show Chapter Data',
                      onPressed: () {
                        final bookId = controller.bookDetails.value?.id;
                        final chapterId = chapter.chapterId;

                        print("bookId : $bookId");
                        print("chapterId : $chapterId");
                        if (bookId != null && chapterId != null) {
                          final assetUrl = '$bookId/chapters/$chapterId';
                          Get.toNamed(
                            AppRoutes.assetResult,
                            arguments: {
                              'assetUrl': assetUrl,
                              'isDirectPath': true,
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          children:
              (chapter.topics?.isNotEmpty ?? false)
                  ? chapter.topics!
                      .map(
                        (topic) => ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          leading: const Icon(Icons.bookmark_outline),
                          title: Text(
                            topic.topicName ?? 'Untitled Topic',
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.red,
                            ),
                            tooltip: 'Show Chapter Data',
                            onPressed: () {
                              final bookId = controller.bookDetails.value?.id;
                              final topicId = topic.topicId;
                              final chapterId = chapter.chapterId;

                              print("bookId: $bookId");
                              print("chapterId: $topicId");

                              if (bookId != null && topicId != null) {
                                final assetUrl =
                                    '$bookId/chapters/$chapterId/topics/$topicId';
                                Get.toNamed(
                                  AppRoutes.assetResult,
                                  arguments: {
                                    'assetUrl': assetUrl,
                                    'isDirectPath': true,
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      )
                      .toList()
                  : [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "No topics available",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
        ),
      ),
    );
  }

  Widget _buildChapterTile(Chapter chapter) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.only(
            left: 16,
            bottom: 12,
            right: 12,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  chapter.title ?? 'Untitled Chapter',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_red_eye, color: Colors.blue),
                tooltip: 'Show Chapter Data',
                onPressed: () {
                  final bookId = controller.bookDetails.value?.id;
                  final chapterId = chapter.id;
                  if (bookId != null && chapterId != null) {
                    final assetUrl = '$bookId/chapters/$chapterId';
                    Get.toNamed(
                      AppRoutes.assetResult,
                      arguments: {'assetUrl': assetUrl},
                    );
                  }
                },
              ),
            ],
          ),
          subtitle:
              chapter.subtitle != null
                  ? Text(
                    chapter.subtitle!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )
                  : null,
          children:
              (chapter.topics?.isNotEmpty ?? false)
                  ? chapter.topics!
                      .map(
                        (topic) => ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          leading: const Icon(Icons.bookmark_outline),
                          title: Text(
                            topic,
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          // No navigation on topic tap
                        ),
                      )
                      .toList()
                  : [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "No topics available",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
        ),
      ),
    );
  }

  void _showDeleteDialog(String chatId, String chatTitle) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Chat',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "$chatTitle"?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteChat(chatId);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
