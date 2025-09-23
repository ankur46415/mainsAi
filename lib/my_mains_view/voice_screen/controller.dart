import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mains/app_imports.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceController extends GetxController with WidgetsBindingObserver {
  final FlutterTts flutterTts = FlutterTts();

  final RxString ttsMode = 'sarvam'.obs;
  String? authToken;
  late SharedPreferences prefs;
  final ScrollController scrollController = ScrollController();
  final bool initialChatMode;
  final RxString selectedLanguageLabel = 'en-IN'.obs;
  final RxString selectedVoice = 'karun'.obs;
  final String? questionId;
  var mainTab = 'Settings'.obs;
  final Rx<BookDetails?> bookDetails = Rx<BookDetails?>(null);
  final Rx<AiGuidelines?> aiGuidelines = Rx<AiGuidelines?>(null);
  final RxBool isLoadingBookDetails = false.obs;
  final RxBool showThinkingBubble = false.obs;
  late TextEditingController chatTextController = TextEditingController();
  late TextEditingController textController = TextEditingController();
  final stt.SpeechToText speech = stt.SpeechToText();
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _audioSessionSubscription;
  AudioPlayer? player;
  final RxBool isChatMode = false.obs;
  final RxBool isListening = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, String>> messages = <Map<String, String>>[].obs;
  final RxBool isPlayingResponse = false.obs;
  final RxString currentPlayingMessage = ''.obs;
  final RxDouble currentSoundLevel = 0.0.obs;
  final RxBool isFetchingTts = false.obs;
  final RxBool isManuallyStopped = false.obs;
  final RxBool isAppInForeground = true.obs;
  String userTextInput = '';
  String aiReply = '';
  bool _isSpeechInitialized = false;
  String? googleKey;
  String? googleSourceName;
  String? servamKey;
  String? servamSourceName;
  String? apiKey;
  RxBool showFaqOptions = true.obs;
  final bool? isRagChatAvailable;
  String? currentChatId;
  bool _isControllerDisposed = false;

  void sendMessage(String text) {
    isManuallyStopped.value = false; // Reset flag when sending message
    addMessage({'message': text, 'sender': 'user'});
    showFaqOptions.value = false;
    getHybridAIResponse(text);
  }

  final languageMapping = <String, String>{
    'English (India)': 'en-IN',
    'Hindi (India)': 'hi-IN',
  };

  final voiceMapping = <String, String>{
    'Abhilash (Male)': 'abhilash',
    'Anushka (Female)': 'anushka',
    'Karun (Male)': 'karun',
    'Vidya (Female)': 'vidya',
    'Manisha (Female)': 'manisha',
  };

  final tabData = <String, List<String>>{
    'History': [], // Empty list for History tab
    'Voices': [],
    'Languages': [],
    'Modes': ['Mode 1', 'Mode 2', 'Mode 3'],
  };

  final RxList<String> historyData =
      ['Watched Lecture 1', 'Attempted Quiz 2', 'Downloaded PDF'].obs;
  final RxList<ChatHistory> chatHistory = <ChatHistory>[].obs;
  final RxBool isLoadingHistory = false.obs;

  // Chat details for selected chat
  final RxMap<String, dynamic> selectedChatDetails = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> chatMessages =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoadingChatDetails = false.obs;

  final RxString selectedTab = 'Voices'.obs;
  final RxBool isFirstInteraction = true.obs;
  final RxString selectedItem = ''.obs;
  final RxMap<int, int?> selectedTopics = <int, int?>{}.obs;
  final RxMap<int, bool> expandedChapters = <int, bool>{}.obs;

  VoiceController({
    this.initialChatMode = false,
    this.questionId,
    this.isRagChatAvailable = true,
  });

  @override
  Future<void> onInit() async {
    super.onInit();
    _isControllerDisposed = false;
    WidgetsBinding.instance.addObserver(this);
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    await fetchAppVoiceConfigAndSetGlobals();
    messages.clear();
    isChatMode.value = initialChatMode;
    isListening.value = false;
    isLoading.value = false;
    isPlayingResponse.value = false;
    isManuallyStopped.value = false;
    aiReply = '';
    userTextInput = '';
    currentChatId = null; // Reset chat session

    if (questionId != null && questionId!.isNotEmpty) {
      await fetchBookDetails();
    }

    player = AudioPlayer();
    await _initAudioSession();
    await _initializeSpeech();
    await _initializeFlutterTts();
    tabData['Voices'] = voiceMapping.keys.toList();
    tabData['Languages'] = languageMapping.keys.toList();

    _playerStateSubscription = player?.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlayingResponse.value = false;
        player?.stop();
        // Only reinitialize speech if not manually stopped
        if (!isManuallyStopped.value) {
          _reinitializeSpeech();
        }
        isManuallyStopped.value = false; // Reset flag
      }
    });

    _audioSessionSubscription = await AudioSession.instance.then((session) {
      return session.becomingNoisyEventStream.listen((_) {
        if (player?.playing ?? false) {
          player?.pause();
          isPlayingResponse.value = false;
        }
      });
    });
  }

  @override
  void onReady() {
    super.onReady();
    if (initialChatMode) {
      isChatMode.value = true;
    }
  }

  void addMessage(Map<String, String> message) {
    messages.add(message);
    Future.delayed(Duration(milliseconds: 100), scrollToBottom);
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
    isManuallyStopped.value = false; // Reset flag when selecting tab
    if (tab == 'History' && !isLoadingHistory.value) {
      fetchChatHistory();
    }
  }

  void selectVoice(String voiceName) {
    if (voiceMapping.containsKey(voiceName)) {
      selectedVoice.value = voiceMapping[voiceName]!;
      isManuallyStopped.value = false; // Reset flag when selecting voice
      debugPrint('Selected voice ID: ${selectedVoice.value}');
    } else {
      debugPrint('voiceMapping does not contain key: $voiceName');
    }
  }

  void selectLanguage(String languageLabel) {
    if (languageMapping.containsKey(languageLabel)) {
      selectedLanguageLabel.value = languageMapping[languageLabel]!;
      isManuallyStopped.value = false; // Reset flag when selecting language
      debugPrint('Selected language: ${selectedLanguageLabel.value}');
      _initializeFlutterTts(); // Reinitialize Flutter TTS with new language
    } else {
      debugPrint('languageMapping does not contain key: $languageLabel');
    }
  }

  void toggleChatMode() {
    isChatMode.value = !isChatMode.value;
    isManuallyStopped.value = false; // Reset flag when toggling chat mode
  }

  void markFirstInteractionDone() {
    isFirstInteraction.value = false;
    isManuallyStopped.value =
        false; // Reset flag when marking first interaction done
  }

  void selectItem(String item) {
    selectedItem.value = item;
    isManuallyStopped.value = false; // Reset flag when selecting item
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    isManuallyStopped.value =
        false; // Reset flag when initializing audio session
  }

  Future<void> _initializeSpeech() async {
    _isSpeechInitialized = await speech.initialize(
      onStatus: (status) async {
        debugPrint('Speech recognition status: $status');
      },
      onError: (error) async {
        debugPrint('Speech recognition error: $error');
        isListening.value = false;
      },
    );
    isManuallyStopped.value = false; // Reset flag when initializing speech
  }

  Future<void> toggleListening() async {
    if (!_isSpeechInitialized) {
      debugPrint(
        'Speech recognition not initialized, attempting to initialize...',
      );
      await _reinitializeSpeech();
      if (!_isSpeechInitialized) {
        debugPrint('Failed to initialize speech recognition');
        return;
      }
    }

    try {
      if (isListening.value) {
        await speech.stop();
        isListening.value = false;
      } else {
        if (player?.playing ?? false) {
          await player?.stop();
          isPlayingResponse.value = false;
        }

        userTextInput = '';
        isManuallyStopped.value = false; // Reset flag when starting listening
        isListening.value = true;

        await speech.listen(
          onResult: (result) {
            userTextInput = result.recognizedWords;
            if (result.finalResult) {
              isListening.value = false;
              if (userTextInput.isNotEmpty) {
                _processSpeechInput();
              }
            }
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
          cancelOnError: true,
          localeId: selectedLanguageLabel.value,
        );
      }
    } catch (e) {
      debugPrint('Error in toggleListening: $e');
      isListening.value = false;
      await _reinitializeSpeech();
    }
  }

  Future<void> _processSpeechInput() async {
    if (userTextInput.isEmpty) return;

    isListening.value = false;
    isManuallyStopped.value = false; // Reset flag when processing speech input
    await stopCurrentResponse();
    addMessage({'message': userTextInput, 'sender': 'user'});
    await getHybridAIResponse(userTextInput);
    userTextInput = '';
  }

  Future<void> stopCurrentResponse() async {
    try {
      isManuallyStopped.value = true; // Mark as manually stopped
      if (player?.playing ?? false) {
        await player?.stop();
      }
      await flutterTts.stop();
      isPlayingResponse.value = false;
    } catch (e) {
      debugPrint('Error stopping audio: $e');
      isPlayingResponse.value = false;
    }
  }

  Future<RagChatForBook> ragChatApi(String question) async {
    debugPrint("📡 [ragChatApi] Preparing request (NEW API)...");

    isManuallyStopped.value = false; // Reset flag when calling RAG chat API

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    final userId = prefs.getString('userId');
    debugPrint(
      "🔑 [ragChatApi] Auth token retrieved: ${authToken != null ? '✔️ Present' : '❌ Missing'}",
    );
    debugPrint(
      "👤 [ragChatApi] User ID retrieved: ${userId != null ? '✔️ Present' : '❌ Missing'}",
    );

    final String url =
        'https://test.ailisher.com/api/mobile/public-chat/ask/$questionId';
    debugPrint("🌐 [ragChatApi] URL: $url");

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
    debugPrint("📦 [ragChatApi] Headers: $headers");

    // Prepare request body with chat_id if available
    Map<String, dynamic> requestBody = {
      'question': question,
      'history': [],
      'client_id': 'CLI147189HIGB',
      'user_id': userId,
    };

    if (currentChatId != null) {
      // If we have a chat session, include the chat_id in the request body
      requestBody['chat_id'] = currentChatId;
      debugPrint("💬 [ragChatApi] Using existing chat session: $currentChatId");
    } else {
      debugPrint("🆕 [ragChatApi] Starting new chat session");
    }

    final body = jsonEncode(requestBody);
    debugPrint("✉️ [ragChatApi] Body: $body");

    try {
      debugPrint("🚀 [ragChatApi] Sending POST request...");
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      debugPrint("📬 [ragChatApi] Response Status: ${response.statusCode}");
      debugPrint("📄 [ragChatApi] Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        debugPrint("✅ [ragChatApi] Successfully parsed response.");

        // Store the chat_id for future messages
        if (json['chat_id'] != null) {
          currentChatId = json['chat_id'];
          debugPrint("💾 [ragChatApi] Stored chat_id: $currentChatId");
        }

        // Extract llm_response and map it to answer field
        final data = json['data'];
        if (data != null && data['llm_response'] != null) {
          // Create a modified json with llm_response mapped to answer
          final modifiedJson = {
            'success': json['success'],
            'answer': data['llm_response'], // Map llm_response to answer
            'confidence': data['confidence'],
            'sources': data['sources'],
            'method': data['method'],
            'bookId': data['bookId'],
            'bookTitle': data['bookTitle'],
            'modelUsed': data['modelUsed'],
            'tokensUsed': data['tokensUsed'],
            'timing': data['timing'],
          };
          return RagChatForBook.fromJson(modifiedJson);
        } else {
          throw Exception('❌ No llm_response found in response data');
        }
      } else {
        debugPrint(
          "❌ [ragChatApi] Failed with status code: ${response.statusCode}",
        );
        throw Exception('❌ Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('💥 [ragChatApi] Exception occurred: $e');
      rethrow;
    }
  }

  Future<void> fetchAppVoiceConfigAndSetGlobals() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    isManuallyStopped.value =
        false; 

    final url = Uri.parse(ApiUrls.appConfig);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      debugPrint('🔗 URL: $url');
      debugPrint('🔑 Auth Token: $authToken');
      debugPrint('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        for (var item in jsonList) {
          final config = AppVoiceConfig.fromJson(item);

          for (var model in config.models ?? []) {
            final source = model.sourcename?.trim().toLowerCase();
            debugPrint('🔍 Found model sourcename: "$source"');

            if (source == 'google') {
              googleKey = model.key;
              googleSourceName = model.sourcename;
            } else if (source == 'servam') {
              servamKey = model.key;
              servamSourceName = model.sourcename;
            }
          }
        }

        debugPrint("✅ Google Key: $googleKey");
        debugPrint("✅ Servam Key: $servamKey");
      } else {
        debugPrint('❌ Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
    }
  }

  Future<void> sendIsExpiredFlagLLM() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    final String url = ApiUrls.appExpireConfigLlm;

    isManuallyStopped.value = false; // Reset flag when sending expired flag

    final Map<String, dynamic> payload = {"isExpired": true};

    debugPrint('📡 Preparing to send PUT request to: $url');
    debugPrint('📦 Request payload: $payload');

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(payload),
      );
      debugPrint(
        '📥 Received response with status code: ${response.statusCode}',
      );
      debugPrint('📝 Response body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('❌ PUT failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('🚨 Exception occurred during PUT request: $e');
    }
  }

  Future<void> sendIsExpiredFlagGemini() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    final String url = ApiUrls.appExpireConfigTts;

    isManuallyStopped.value = false; // Reset flag when sending expired flag

    final Map<String, dynamic> payload = {"isExpired": true};

    debugPrint('📡 Preparing to send PUT request to: $url');
    debugPrint('📦 Request payload: $payload');

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(payload),
      );
      debugPrint(
        '📥 Received response with status code: ${response.statusCode}',
      );
      debugPrint('📝 Response body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('❌ PUT failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('🚨 Exception occurred during PUT request: $e');
    }
  }

  Future<void> getAIResponse(String input) async {
    if (input.trim().isEmpty) return;

    debugPrint("[AI] User input: $input");
    isLoading.value = true;
    isManuallyStopped.value = false; // Reset flag when getting AI response
    try {
      apiKey = googleKey;
      final apiUrl =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

      debugPrint("[AI] API URL: $apiUrl");

      final requestBody = {
        "contents": [
          {
            "parts": [
              {
                "text":
                    "You are a helpful assistant. Continue the conversation naturally, using the past user message and your reply as context. Respond in the same language (हिंदी or English) and be concise (20–30 words).\n\nUser: $input",
              },
            ],
          },
        ],
      };

      debugPrint("[AI] Request Body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      debugPrint("[AI] Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final aiText = data['candidates'][0]['content']['parts'][0]['text'];

        debugPrint("[AI] AI Response: $aiText");

        aiReply = aiText;
        addMessage({"sender": "ai", "message": aiText});
        showThinkingBubble.value = false;
      } else if (response.statusCode == 503) {
        debugPrint("[AI] Server overloaded (503)");
        addMessage({
          "sender": "ai",
          "message":
              "We’re experiencing high traffic. Our servers are currently overloaded. Please try again shortly.",
        });
        showThinkingBubble.value = false;
        await sendIsExpiredFlagGemini();
      } else {
        final error = "Error: ${response.statusCode} - ${response.body}";
        debugPrint("[AI] API Error: $error");
        aiReply = error;
        addMessage({
          "sender": "ai",
          "message":
              "We’re experiencing high traffic. Our servers are currently overloaded. Please try again shortly.",
        });
        showThinkingBubble.value = false;
      }
    } catch (e) {
      debugPrint("[AI] Exception: $e");
      aiReply = "Oops! Something went wrong.";
      addMessage({
        "sender": "ai",
        "message":
            "We’re experiencing high traffic. Our servers are currently overloaded. Please try again shortly.",
      });
      showThinkingBubble.value = false;
    } finally {
      isLoading.value = false;
      textController.clear();
      debugPrint("[AI] Finished processing input.");
    }
  }

  Future<void> callLmntForTTS(String text) async {
    // Don't call stopCurrentResponse here to avoid setting isManuallyStopped
    // await stopCurrentResponse();
    isFetchingTts.value = true;
    isManuallyStopped.value = false; // Reset flag when calling LMNT TTS

    const String apiKey = 'ak_k5oc5g5R5QQ6GvfntiwYcn';
    const String voice = 'nova';
    const String language = 'en';

    final Uri wsUri = Uri.parse('wss://api.lmnt.com/v1/streaming');
    final ttsPlayer = AudioPlayer();
    final dir = await getTemporaryDirectory();
    final outFile = File(
      '${dir.path}/lmnt_tts_${DateTime.now().millisecondsSinceEpoch}.wav',
    );
    final sink = outFile.openWrite();
    bool playbackAttempted = false;

    try {
      debugPrint("🔁 Connecting to LMNT WebSocket...");
      final channel = IOWebSocketChannel.connect(
        wsUri,
        headers: {'X-API-Key': apiKey},
      );

      debugPrint("✅ Connected to LMNT");

      // Step 1: Send config
      final config = {"type": "config", "voice": voice, "language": language};
      channel.sink.add(jsonEncode(config));
      debugPrint("📤 Sent config: $config");

      // Step 2: Send text
      channel.sink.add(jsonEncode({"type": "append_text", "text": text}));
      channel.sink.add(
        jsonEncode({"type": "flush"}),
      ); // Optional if you're not appending more

      // Step 3: Listen to audio
      channel.stream.listen(
        (data) async {
          if (data is Uint8List) {
            sink.add(data);
          } else if (data is String) {
            debugPrint("📩 LMNT → $data");
          }
        },
        onError: (error) async {
          debugPrint("🛑 LMNT WS error: $error");
          await sink.close();
          isFetchingTts.value = false;
          if (!playbackAttempted && !isManuallyStopped.value) {
            playbackAttempted = true;
            await callFlutterTts(text);
          }
          if (!isManuallyStopped.value) {
            _reinitializeSpeech();
          }
        },
        onDone: () async {
          await sink.close();
          debugPrint("✅ Audio received, file saved at: ${outFile.path}");

          try {
            await _clearTemporaryFiles();
            if (await outFile.exists() && await outFile.length() > 44) {
              await ttsPlayer.setFilePath(outFile.path);
              isFetchingTts.value = false;
              isPlayingResponse.value = true;
              await ttsPlayer.play();
            } else {
              debugPrint("❌ Audio empty or corrupted");
              isFetchingTts.value = false;
              if (!isManuallyStopped.value) {
                await callFlutterTts(text);
              }
            }
          } catch (e) {
            debugPrint("🎧 Playback error: $e");
            isFetchingTts.value = false;
            if (!isManuallyStopped.value) {
              await callFlutterTts(text);
            }
          }
          if (!isManuallyStopped.value) {
            _reinitializeSpeech();
          }
        },
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint("❌ Exception: $e");
      if (!playbackAttempted && !isManuallyStopped.value) {
        playbackAttempted = true;
        isFetchingTts.value = false;
        await callFlutterTts(text);
      }
      if (!isManuallyStopped.value) {
        _reinitializeSpeech();
      }
    }
  }

  List<String> _splitTextIntoChunks(String text, {int maxLength = 400}) {
    final words = text.split(' ');
    List<String> chunks = [];
    String current = '';

    for (final word in words) {
      if ((current + ' ' + word).trim().length > maxLength) {
        chunks.add(current.trim());
        current = word;
      } else {
        current += ' $word';
      }
    }
    if (current.isNotEmpty) chunks.add(current.trim());
    return chunks;
  }

  Future<void> callSarvamForTTS(String text) async {
    if (ttsMode.value == 'flutter') {
      if (isAppInForeground.value &&
          !isManuallyStopped.value &&
          !_isControllerDisposed) {
        await callFlutterTts(text);
      }
      return;
    }

    // Don't call stopCurrentResponse here to avoid setting isManuallyStopped
    // await stopCurrentResponse();

    selectedVoice.value = 'karun';
    const apiUrl = "https://api.sarvam.ai/text-to-speech";
    apiKey = servamKey;
    final chunks = _splitTextIntoChunks(text);
    debugPrint("🔊 [Sarvam] Total chunks to send: ${chunks.length}");

    try {
      isFetchingTts.value = true;
      isPlayingResponse.value = true;

      for (int i = 0; i < chunks.length; i++) {
        if (!isAppInForeground.value ||
            isManuallyStopped.value ||
            _isControllerDisposed) {
          break; // Do not proceed if app not in foreground or manually stopped
        }
        final chunk = chunks[i];
        final requestBody = {
          "text": chunk,
          "speaker": selectedVoice.value,
          "model": "bulbul:v2",
          "target_language_code": selectedLanguageLabel.value,
        };

        // 🖨️ Log request body
        debugPrint("🔊 [Sarvam] Sending chunk ${i + 1}/${chunks.length}");
        debugPrint("🔊 [Sarvam] Request Body: ${jsonEncode(requestBody)}");

        final response = await http
            .post(
              Uri.parse(apiUrl),
              headers: {
                "Content-Type": "application/json",
                "api-subscription-key": apiKey.toString(),
              },
              body: jsonEncode(requestBody),
            )
            .timeout(const Duration(seconds: 20));

        debugPrint("🔊 [Sarvam] Response Status: ${response.statusCode}");

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['audios'] != null &&
              responseData['audios'].isNotEmpty) {
            final audioBase64 = responseData['audios'][0];
            final audioBytes = base64Decode(audioBase64);
            final directory = await getTemporaryDirectory();
            final tempFile = File(
              '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav',
            );
            await tempFile.writeAsBytes(audioBytes);

            await _clearTemporaryFiles();
            if (isAppInForeground.value &&
                !isManuallyStopped.value &&
                !_isControllerDisposed) {
              await player?.setFilePath(tempFile.path);
              await player?.play();
            }
            await player?.playerStateStream.firstWhere(
              (s) => s.processingState == ProcessingState.completed,
            );
          } else {
            debugPrint("No audio data found for chunk ${i + 1}");
          }
        } else if (response.statusCode == 401) {
          debugPrint("Sarvam API key exhausted (401)");
          await sendIsExpiredFlagLLM();
          // Only fallback to Flutter TTS if not manually stopped
          if (!isManuallyStopped.value &&
              isAppInForeground.value &&
              !_isControllerDisposed) {
            await callFlutterTts(chunk);
          }
        } else {
          debugPrint("Sarvam API Error: ${response.statusCode}");
          // Only fallback to Flutter TTS if not manually stopped
          if (!isManuallyStopped.value &&
              isAppInForeground.value &&
              !_isControllerDisposed) {
            await callFlutterTts(chunk);
          }
        }
      }

      isFetchingTts.value = false;
      isPlayingResponse.value = false;
    } catch (e) {
      debugPrint("Sarvam API Exception: $e");
      isFetchingTts.value = false;
      isPlayingResponse.value = false;
      // Only fallback to Flutter TTS if not manually stopped and app in foreground
      if (!isManuallyStopped.value &&
          isAppInForeground.value &&
          !_isControllerDisposed) {
        await callFlutterTts(text);
      }
    }
  }

  Future<void> callFlutterTts(String text) async {
    // Don't call stopCurrentResponse here to avoid setting isManuallyStopped
    isFetchingTts.value = false;
    try {
      if (!isAppInForeground.value ||
          isManuallyStopped.value ||
          _isControllerDisposed) {
        return; // Do not start TTS if app not foreground or manually stopped
      }
      await flutterTts.setLanguage(selectedLanguageLabel.value);
      await flutterTts.speak(text);
      isPlayingResponse.value = true;
      flutterTts.setCompletionHandler(() {
        isPlayingResponse.value = false;
        // Only reinitialize speech if not manually stopped
        if (!isManuallyStopped.value && isAppInForeground.value) {
          _reinitializeSpeech();
        }
        isManuallyStopped.value = false; // Reset flag
      });
      flutterTts.setErrorHandler((msg) {
        debugPrint("Flutter TTS Error: $msg");
        isPlayingResponse.value = false;
        // Only reinitialize speech if not manually stopped
        if (!isManuallyStopped.value && isAppInForeground.value) {
          _reinitializeSpeech();
        }
        isManuallyStopped.value = false; // Reset flag
      });
    } catch (e) {
      debugPrint("Flutter TTS Exception: $e");
      isPlayingResponse.value = false;
      // Only reinitialize speech if not manually stopped
      if (!isManuallyStopped.value && isAppInForeground.value) {
        _reinitializeSpeech();
      }
      isManuallyStopped.value = false; // Reset flag
    }
  }

  Future<void> _initializeFlutterTts() async {
    try {
      await flutterTts.setLanguage(selectedLanguageLabel.value);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.setVoice({
        "name": "en-in-x-ene-network",
        "locale": "en-IN",
      });
      isManuallyStopped.value =
          false; // Reset flag when initializing Flutter TTS
      debugPrint("Flutter TTS initialized successfully");
    } catch (e) {
      debugPrint("Error initializing Flutter TTS: $e");
    }
  }

  void handleDrawerModeSelection(String mode) {
    if (mode == 'Mode 2') {
      ttsMode.value = 'flutter';
    } else if (mode == 'Mode 3') {
      ttsMode.value = 'lmnt';
    } else {
      ttsMode.value = 'sarvam'; // Mode 1
    }
    isManuallyStopped.value = false; // Reset flag when changing TTS mode
    debugPrint('Selected mode: $mode, TTS mode: ${ttsMode.value}');
  }

  Future<void> playVoiceResponse(Uint8List audioBytes) async {
    try {
      await player?.stop();
      isPlayingResponse.value = false;
      isManuallyStopped.value = false; // Reset flag when playing voice response

      final directory = await getTemporaryDirectory();
      final tempFile = File('${directory.path}/audio.mp3');
      await tempFile.writeAsBytes(audioBytes);

      debugPrint("Saved audio file to: ${tempFile.path}");
      debugPrint("File size: ${await tempFile.length()} bytes");

      if (!isAppInForeground.value || isManuallyStopped.value) {
        return;
      }
      await player?.setFilePath(tempFile.path);
      isPlayingResponse.value = true;
      await player?.play();

      player?.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          isPlayingResponse.value = false;
          player?.stop();
          // Only reinitialize speech if not manually stopped
          if (!isManuallyStopped.value) {
            _reinitializeSpeech();
          }
        }
      });
    } catch (e) {
      debugPrint('Error playing audio: $e');
      isPlayingResponse.value = false;
      await player?.stop();
      // Only reinitialize speech if not manually stopped
      if (!isManuallyStopped.value) {
        _reinitializeSpeech();
      }
    }
  }

  Future<void> sendChatMessage() async {
    final text = chatTextController.text.trim();
    if (text.isEmpty) return;

    isLoading.value = true;
    isManuallyStopped.value = false; // Reset flag when sending chat message
    chatTextController.clear();
    addMessage({'message': text, 'sender': 'user'});
    await getHybridAIResponse(text);
  }

  @override
  void onClose() {
    try {
      _isControllerDisposed = true;
      WidgetsBinding.instance.removeObserver(this);
      _playerStateSubscription?.cancel();
      _audioSessionSubscription?.cancel();

      if (speech.isListening) {
        speech.stop();
      }

      if (player?.playing ?? false) {
        player?.stop();
      }
      player?.dispose();

      flutterTts.stop();

      chatTextController.dispose();
      textController.dispose();
      scrollController.dispose();

      isChatMode.value = false;
      isListening.value = false;
      isPlayingResponse.value = false;
      isLoading.value = false;
      isManuallyStopped.value = false;
      messages.clear();

      _isSpeechInitialized = false;

      _clearTemporaryFiles();
    } catch (e) {
      debugPrint('Error during controller disposal: $e');
    }
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // Stop any audio/TTS as soon as app is not in foreground
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        // Hidden is for web; harmless elsewhere
        state.toString() == 'AppLifecycleState.hidden') {
      isAppInForeground.value = false;
      isManuallyStopped.value = true;
      try {
        if (speech.isListening) {
          await speech.stop();
        }
      } catch (_) {}
      await stopCurrentResponse();
    } else if (state == AppLifecycleState.resumed) {
      isAppInForeground.value = true;
    }
  }

  Future<void> _clearTemporaryFiles() async {
    try {
      final directory = await getTemporaryDirectory();
      final files = directory.listSync();
      for (var file in files) {
        if (file.path.contains('audio.') && file is File) {
          await file.delete();
        }
      }
      isManuallyStopped.value =
          false; // Reset flag when clearing temporary files
    } catch (e) {
      debugPrint('Error clearing temporary files: $e');
    }
  }

  Future<void> _reinitializeSpeech() async {
    try {
      if (speech.isListening) {
        await speech.stop();
      }

      isListening.value = false;
      _isSpeechInitialized = false;

      _isSpeechInitialized = await speech.initialize(
        onStatus: (status) async {
          debugPrint('Speech recognition status: $status');
          if (status == 'done') {
            isListening.value = false;
          }
        },
        onError: (error) async {
          debugPrint('Speech recognition error: $error');
          isListening.value = false;
          // Only reinitialize if not manually stopped
          if (!isManuallyStopped.value) {
            await Future.delayed(const Duration(seconds: 1));
            await _reinitializeSpeech();
          }
        },
      );

      isManuallyStopped.value = false; // Reset flag when reinitializing speech
      debugPrint('Speech recognition reinitialized: $_isSpeechInitialized');
    } catch (e) {
      debugPrint('Error reinitializing speech: $e');
      // Only reinitialize if not manually stopped
      if (!isManuallyStopped.value) {
        await Future.delayed(const Duration(seconds: 1));
        await _reinitializeSpeech();
      }
    }
  }

  void openBottomSheet() {
    isManuallyStopped.value = false; // Reset flag when opening bottom sheet
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.85,
          minHeight: Get.height * 0.5,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 5),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/bookb.png',
                              height: Get.width * 0.16,
                            ),
                            SizedBox(width: Get.width * 0.02),
                            Text(
                              'Geography',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 24),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.grey),
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    5,
                    (chapterIndex) =>
                        Obx(() => _buildChapterCard(chapterIndex)),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(Get.context!).padding.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildChapterCard(int chapterIndex) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Theme(
          data: Theme.of(
            Get.context!,
          ).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: expandedChapters[chapterIndex] ?? false,
            onExpansionChanged: (expanded) {
              expandedChapters[chapterIndex] = expanded;
              isManuallyStopped.value =
                  false; // Reset flag when expanding/collapsing chapter
            },
            title: Text(
              'Chapter ${chapterIndex + 1}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            children: List.generate(
              3,
              (topicIndex) => Obx(() {
                bool isSelected = selectedTopics[chapterIndex] == topicIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      selectedTopics[chapterIndex] = topicIndex;
                      isManuallyStopped.value =
                          false; // Reset flag when selecting topic
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Colors.blue.shade50
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Topic ${topicIndex + 1}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color:
                                  isSelected
                                      ? Colors.blue.shade800
                                      : Colors.black87,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void resetMode(bool chatMode) {
    isChatMode.value = chatMode;
    isManuallyStopped.value = false; // Reset flag when resetting mode
  }

  void resetChatSession() {
    currentChatId = null;
    isManuallyStopped.value = false; // Reset flag when resetting chat session
    debugPrint("🔄 [Chat] Chat session reset");
  }

  Future<void> fetchBookDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    debugPrint("🔄 fetchBookDetails() called");

    if (questionId == null || questionId!.isEmpty) {
      debugPrint("❌ questionId is null or empty");
      return;
    }

    isManuallyStopped.value = false; 

    isLoadingBookDetails.value = true;
    debugPrint("⏳ isLoadingBookDetails set to true");

    try {
      final String url = '${ApiUrls.getBookDetails}$questionId';
      debugPrint("🌐 Request URL: $url");
      debugPrint("📦 Auth token: $authToken");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      debugPrint("📥 Response status: ${response.statusCode}");
      debugPrint("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        debugPrint("✅ JSON decoded");

        if (jsonData['data'] != null) {
          // Parse book details
          final book = BookDetails.fromJson(jsonData['data']);
          bookDetails.value = book;
          aiGuidelines.value = book.aiGuidelines;

          // ✅ Debug raw chapter JSON
          debugPrint(
            "📄 Raw chapters JSON: ${jsonEncode(jsonData['data']['chapters'])}",
          );

          // ✅ Print parsed chapters list
          final chapters = book.chapters;
          if (chapters != null && chapters.isNotEmpty) {
            for (var i = 0; i < chapters.length; i++) {
              final chapter = chapters[i];
              debugPrint("📚 Chapter ${i + 1}: ${chapter.title}");
              debugPrint(
                "➡️ Topics: ${chapter.topics?.join(', ') ?? 'No topics'}",
              );
            }
          } else {
            debugPrint("⚠️ Chapter list is empty or null");
          }

          debugPrint("📘 Book details loaded: ${book.title}");
        } else {
          debugPrint("⚠️ jsonData['data'] is null");
        }
      } else {
        debugPrint("❌ Error fetching book details: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("💥 Exception fetching book details: $e");
    } finally {
      isLoadingBookDetails.value = false;
      debugPrint("✅ isLoadingBookDetails set to false");
    }
  }

  Future<void> getHybridAIResponse(String input) async {
    if (input.trim().isEmpty) {
      return;
    }

    isLoading.value = true;
    isManuallyStopped.value = false; // Reset flag when getting AI response
    showThinkingBubble.value = true;

    try {
      // Always use Gemini (getAIResponse) and skip RAG logic
      await getAIResponse(input);
      showThinkingBubble.value = false;
    } catch (e) {
      // Fallback still uses Gemini
      await getAIResponse(input);
      showThinkingBubble.value = false;
    } finally {
      isLoading.value = false;
      textController.clear();
    }
  }

  Future<void> playSarvamTTS(String message) async {
    if (message.trim().isEmpty) return;
    try {
      if (!isAppInForeground.value) return;
      isManuallyStopped.value = false; // Reset flag before starting
      isPlayingResponse.value = true;
      await callSarvamForTTS(message);
    } catch (e) {
      debugPrint('Error playing Sarvam TTS: $e');
    } finally {
      isPlayingResponse.value = false;
    }
  }

  Future<void> fetchChatHistory() async {
    debugPrint("🚀 [History] fetchChatHistory() called");

    // Prevent multiple simultaneous calls
    if (isLoadingHistory.value) {
      debugPrint("⏳ [History] Already loading, skipping duplicate call");
      return;
    }

    isManuallyStopped.value = false; // Reset flag when fetching chat history

    if (bookDetails.value?.id == null || bookDetails.value!.id!.isEmpty) {
      debugPrint("❌ [History] No book ID available for fetching history");
      return;
    }

    isLoadingHistory.value = true;
    final bookId = bookDetails.value!.id!;
    debugPrint("📚 [History] Fetching chat history for bookId: $bookId");

    final prefs = await SharedPreferences.getInstance();
    debugPrint("🔑 [History] SharedPreferences loaded");

    final authToken = prefs.getString('authToken');
    final userId = prefs.getString('userId');

    debugPrint(
      "🔐 [History] AuthToken: ${authToken != null ? 'Present' : 'NULL'}",
    );
    debugPrint("👤 [History] UserId: ${userId ?? 'NULL'}");

    if (authToken == null || userId == null) {
      debugPrint(
        "❌ [History] Missing auth token or user ID -> Aborting request",
      );
      isLoadingHistory.value = false;
      return;
    }

    try {
      final requestBody = {
        'bookId': bookId,
        'user_id': userId,
        'client_id': 'CLI147189HIGB',
      };

      debugPrint("📤 [History] Sending POST request to API...");
      debugPrint(
        "🌍 [History] URL: https://test.ailisher.com/api/mobile/public-chat/history",
      );
      debugPrint("📝 [History] Request Body: $requestBody");

      final response = await http.post(
        Uri.parse('https://test.ailisher.com/api/mobile/public-chat/history'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint("📬 [History] Response Status Code: ${response.statusCode}");
      debugPrint("📄 [History] Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        debugPrint("🔍 [History] Decoded JSON: $json");

        if (json['success'] == true && json['chats'] != null) {
          final List<dynamic> chatsJson = json['chats'];
          debugPrint("🗂️ [History] Chats JSON Count: ${chatsJson.length}");

          chatHistory.value =
              chatsJson.map((chat) {
                debugPrint("➡️ [History] Parsing Chat Item: $chat");
                return ChatHistory.fromJson(chat);
              }).toList();

          debugPrint("✅ [History] Loaded ${chatHistory.length} chat histories");
        } else {
          debugPrint("⚠️ [History] No chats found or invalid JSON response");
          chatHistory.value = [];
        }
      } else {
        debugPrint(
          "❌ [History] Failed Request - Status: ${response.statusCode}",
        );
        chatHistory.value = [];
      }
    } catch (e, stack) {
      debugPrint("💥 [History] Exception Caught: $e");
      debugPrint("📌 [History] StackTrace: $stack");
      chatHistory.value = [];
    } finally {
      isLoadingHistory.value = false;
      debugPrint("🏁 [History] fetchChatHistory() finished");
    }
  }

  Future<void> deleteChat(String chatId) async {
    debugPrint("🚀 [Delete] deleteChat() called");
    debugPrint("🗑️ [Delete] ChatId to delete: $chatId");

    isManuallyStopped.value = false; // Reset flag when deleting chat

    final prefs = await SharedPreferences.getInstance();
    debugPrint("🔑 [Delete] SharedPreferences loaded");

    final authToken = prefs.getString('authToken');
    final userId = prefs.getString('userId');

    debugPrint(
      "🔐 [Delete] AuthToken: ${authToken != null ? 'Present' : 'NULL'}",
    );
    debugPrint("👤 [Delete] UserId: ${userId ?? 'NULL'}");

    if (authToken == null || userId == null) {
      debugPrint(
        "❌ [Delete] Missing auth token or user ID -> Aborting request",
      );
      return;
    }

    try {
      final requestBody = {
        'chatId': chatId,
        'client_id': 'CLI147189HIGB',
        'user_id': userId,
      };

      debugPrint("📤 [Delete] Sending POST request to API...");
      debugPrint(
        "🌍 [Delete] URL: https://test.ailisher.com/api/mobile/public-chat/chat/delete",
      );
      debugPrint("📝 [Delete] Request Body: $requestBody");

      final response = await http.post(
        Uri.parse(
          'https://test.ailisher.com/api/mobile/public-chat/chat/delete',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint("📬 [Delete] Response Status Code: ${response.statusCode}");
      debugPrint("📄 [Delete] Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        debugPrint("🔍 [Delete] Decoded JSON: $json");

        if (json['success'] == true) {
          debugPrint("✅ [Delete] Chat deleted successfully from server");

          // Remove from local list
          final beforeCount = chatHistory.length;
          chatHistory.removeWhere((chat) => chat.chatId == chatId);
          final afterCount = chatHistory.length;

          debugPrint(
            "🗂️ [Delete] Local chat list updated: before=$beforeCount, after=$afterCount",
          );
        } else {
          debugPrint(
            "❌ [Delete] Server responded with failure -> ${json['message'] ?? 'Unknown error'}",
          );
        }
      } else {
        debugPrint(
          "❌ [Delete] Request failed with status: ${response.statusCode}",
        );
      }
    } catch (e, stack) {
      debugPrint("💥 [Delete] Exception: $e");
      debugPrint("📌 [Delete] StackTrace: $stack");
    } finally {
      debugPrint("🏁 [Delete] deleteChat() finished");
    }
  }

  Future<void> getChatDetails(String chatId) async {
    try {
      isLoadingChatDetails.value = true;
      isManuallyStopped.value = false;

      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      final userId = prefs.getString('userId');

      if (authToken == null || userId == null) {
        return;
      }

      final url =
          'https://test.ailisher.com/api/mobile/public-chat/chat-history';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      };

      final body = {
        'chatId': chatId,
        'client_id': 'CLI147189HIGB',
        'user_id': userId,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['chat'] != null) {
          final chat = data['chat'];

          selectedChatDetails.value = chat;
          chatMessages.value = List<Map<String, dynamic>>.from(
            chat['messages'] ?? [],
          );
          currentChatId = chatId;
          messages.clear();
          isManuallyStopped.value = false;
          for (final message in chatMessages) {
            final role = message['role'] ?? '';
            final content = message['content'] ?? '';
            if (role == 'user') {
              messages.add({'sender': 'user', 'message': content});
            } else if (role == 'assistant') {
              messages.add({'sender': 'ai', 'message': content});
            }
          }

          Get.back();
        } else {}
      } else {}
    } catch (e) {
    } finally {
      isLoadingChatDetails.value = false;
    }
  }
}

class ChatHistory {
  final String chatId;
  final String title;
  final int messageCount;

  ChatHistory({
    required this.chatId,
    required this.title,
    required this.messageCount,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      chatId: json['chatId'] ?? '',
      title: json['title'] ?? '',
      messageCount: json['messageCount'] ?? 0,
    );
  }
}

class VoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VoiceController(initialChatMode: false));
  }
}
