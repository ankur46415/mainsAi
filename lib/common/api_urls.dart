class ApiUrls {
  static const String baseUrl = 'https://api.mobishaala.com/';
  static const String baseUrl3 = 'https://test.ailisher.com/';
  static const String baseUrl4 = 'https://test.ailisher.com';

  static const String apiUrl = '${baseUrl}api/v1/';

  ///https://test.ailisher.com
  static const String apiUrl2 =
      '${baseUrl3}api/clients/CLI147189HIGB/mobile/auth/';
  static const String subjectiveTestStart =
      '${baseUrl4}/api/subjectivetest/clients/CLI147189HIGB/tests/';
  static const String apiUrl3 = '${baseUrl3}api/clients/CLI147189HIGB/mobile/';
  static const String apiUrl5 = '${baseUrl3}api/clients/CLI147189HIGB';

  static const String getOtp = '${apiUrl}pre-login/';
  static const String verifyOtp = '${apiUrl}login/';
  static const String checkUser = '${baseUrl3}check-user/';
  static const String register = '${apiUrl2}login/';
  static const String getProfile = '${apiUrl2}profile/';
  static const String updateProfile =
      '${baseUrl3}api/clients/CLI147189HIGB/mobile/auth/profile/';
  static const String getAllBook = '$apiUrl3/book';
  static const String getDashboard = '$apiUrl5/homepage';
  static const String getBookDetails = '$apiUrl5/book/details?book_id=';
  static const String addMyBooks = '$apiUrl5/mobile/mybooks/add';
  static const String getMyFavBooks = '$apiUrl5/mobile/mybooks/list';
  static const String getTestSubmissions = '$apiUrl5/mobile/submitted-answers';
  static const String removeMyFavBooks = '$apiUrl5/mobile/mybooks/remove';
  static const String reviewForAnswer = '$apiUrl5/mobile/review/request';
  static const String submitFeedBack = '$apiUrl5/mobile/userAnswers/questions';
  static const String checkBook = '$apiUrl5/mobile/mybooks/check/';
  static const String uploadImages = '$apiUrl5/mobile/userAnswers/questions/';
  static const String acceptRequest = '$apiUrl5/mobile/review/request/';
  static const String getAllReviewRequest = '${baseUrl3}api/review/pending';
  static const String annotationImages = '${baseUrl3}api/review/';
  static const String s3 = '${baseUrl3}api/review/annotated-image-upload-url';
  static const String viewQRQuestionBase = '${baseUrl3}api/aiswb/qr/questions/';
  static const String userAnswersBase =
      '${baseUrl3}api/clients/CLI147189HIGB/mobile/userAnswers/questions/';
  static const String appConfig = '${baseUrl3}api/config/clients/CLI147189HIGB';

  static const String appExpireConfigLlm =
      '${baseUrl3}api/config/clients/CLI147189HIGB/config/LLM/expire/685bba1ea5326be311a7ad04';
  static const String subjectiveTestSubmitBase =
      '${baseUrl4}/api/subjectivetest/clients/CLI147189HIGB/tests/';
  static const String appExpireConfigTts =
      '${baseUrl3}api/config/clients/CLI147189HIGB/config/TTS/expire/685bba74a5326be311a7ad16';
  static const String getAssetData = '${baseUrl3}api/qrcode/book-data/';
  static const String bookfullAnalysis = '${apiUrl3}submitted-answers/';
  static const String courseDetaile = '${baseUrl3}api/book/';
  static const String workBookData = '$apiUrl5/workbooks/getworkbooks';
  static const String workBookBookDetailes = '$apiUrl5/workbooks/';
  static const String workBookAllQuestiones = '$apiUrl5/workbooks/';
  static const String addMyWorkBook = '$apiUrl5/mobile/myworkbooks/add';
  static const String getMyWorkBookLibrary = '$apiUrl5/mobile/myworkbooks/list';
  static const String ragChatBoook =
      '${baseUrl4}api/enhanced-pdf-chat/chat-book-knowledge-base';

  static const String subjectiveTestQns =
      '${baseUrl4}/api/subjectivetest-questions/clients/CLI147189HIGB/mobile/';
  static const String marketing =
      '${baseUrl3}api/clients/CLI147189HIGB/mobile/marketing/user';
  static const String objectiveTestQnsBase =
      '${baseUrl4}/api/objectivetest-questions/clients/CLI147189HIGB/mobile/';
  static const String subjectiveAnswersBase =
      '$baseUrl4/api/clients/CLI147189HIGB/mobile/userAnswers/subjective-tests';
  static const String objectiveTestSubmitBase =
      'https://test.ailisher.com/api/objectivetest/clients/CLI147189HIGB/';

  static const String objectiveTestStartBase =
      'https://test.ailisher.com/api/objectivetest/clients/CLI147189HIGB/';
  static const String reelsPopular = '${baseUrl3}api/reels/popular';
  static const String dleteMyWorkBookLibrary =
      '$apiUrl5/mobile/myworkbooks/remove';
  static const String reelsUser = '${apiUrl3}reels/user';
  static const String reelsBase = '${apiUrl3}reels';
  static const String subjectiveTestList =
      '$baseUrl4/api/subjectivetest/clients/CLI147189HIGB/get-test';
  static const String objectiveTestList =
      '$baseUrl4/api/objectivetest/clients/CLI147189HIGB/get-test';
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
