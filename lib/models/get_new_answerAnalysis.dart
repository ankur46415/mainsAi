// class GetAnswerAnalysis {
//   bool? success;
//   String? message;
//   Data? data;

//   GetAnswerAnalysis({this.success, this.message, this.data});

//   factory GetAnswerAnalysis.fromJson(Map<String, dynamic> json) {
//     return GetAnswerAnalysis(
//       success: json['success'],
//       message: json['message'],
//       data: json['data'] != null ? Data.fromJson(json['data']) : null,
//     );
//   }
// }

// class Data {
//   Answer? answer;

//   Data({this.answer});

//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       answer: json['answer'] != null ? Answer.fromJson(json['answer']) : null,
//     );
//   }
// }

// class Answer {
//   String? id;
//   String? questionId;
//   int? attemptNumber;
//   String? submissionStatus;
//   String? reviewStatus;
//   String? publishStatus;
//   String? popularityStatus;
//   String? submittedAt;
//   String? evaluatedAt;
//   String? requestID;
//   String? requestnote;
//   bool? analysisAvailable;
//   List<Annotation>? annotations;
//   Question? question;
//   Submission? submission;
//   Evaluation? evaluation;
//   FeedbackModel? feedback;
//   String? reviewedBy;

//   Answer({
//     this.id,
//     this.questionId,
//     this.attemptNumber,
//     this.submissionStatus,
//     this.reviewStatus,
//     this.publishStatus,
//     this.popularityStatus,
//     this.submittedAt,
//     this.evaluatedAt,
//     this.requestID,
//     this.requestnote,
//     this.analysisAvailable,
//     this.annotations,
//     this.question,
//     this.submission,
//     this.evaluation,
//     this.feedback,
//     this.reviewedBy,
//   });

//   factory Answer.fromJson(Map<String, dynamic> json) {
//     return Answer(
//       id: json['_id'],
//       questionId: json['questionId'],
//       attemptNumber: json['attemptNumber'],
//       submissionStatus: json['submissionStatus'],
//       reviewStatus: json['reviewStatus'],
//       publishStatus: json['publishStatus'],
//       popularityStatus: json['popularityStatus'],
//       submittedAt: json['submittedAt'],
//       evaluatedAt: json['evaluatedAt'],
//       requestID: json['requestID'],
//       requestnote: json['requestnote'],
//       analysisAvailable: json['analysisAvailable'],
//       annotations:
//           (json['annotations'] as List?)
//               ?.map((e) => Annotation.fromJson(e))
//               .toList() ??
//           [],
//       question:
//           json['question'] != null ? Question.fromJson(json['question']) : null,
//       submission:
//           json['submission'] != null
//               ? Submission.fromJson(json['submission'])
//               : null,
//       evaluation:
//           json['evaluation'] != null
//               ? Evaluation.fromJson(json['evaluation'])
//               : null,
//       feedback:
//           json['feedback'] != null
//               ? FeedbackModel.fromJson(json['feedback'])
//               : null,
//       reviewedBy: json['reviewedBy'],
//     );
//   }
// }

// class Annotation {
//   // Fill this class if annotations start returning items
//   Annotation();

//   factory Annotation.fromJson(Map<String, dynamic> json) {
//     return Annotation();
//   }
// }

// class Question {
//   String? text;
//   String? detailedAnswer;
//   String? modalAnswer;
//   List<String>? answerVideoUrls;
//   Metadata? metadata;
//   String? languageMode;
//   String? evaluationMode;

//   Question({
//     this.text,
//     this.detailedAnswer,
//     this.modalAnswer,
//     this.answerVideoUrls,
//     this.metadata,
//     this.languageMode,
//     this.evaluationMode,
//   });

//   factory Question.fromJson(Map<String, dynamic> json) {
//     return Question(
//       text: json['text'],
//       detailedAnswer: json['detailedAnswer'],
//       modalAnswer: json['modalAnswer'],
//       answerVideoUrls: (json['answerVideoUrls'] as List?)?.cast<String>() ?? [],
//       metadata:
//           json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null,
//       languageMode: json['languageMode'],
//       evaluationMode: json['evaluationMode'],
//     );
//   }
// }

// class Metadata {
//   QualityParameters? qualityParameters;
//   List<String>? keywords;
//   String? difficultyLevel;
//   int? wordLimit;
//   int? estimatedTime;
//   int? maximumMarks;

//   Metadata({
//     this.qualityParameters,
//     this.keywords,
//     this.difficultyLevel,
//     this.wordLimit,
//     this.estimatedTime,
//     this.maximumMarks,
//   });

//   factory Metadata.fromJson(Map<String, dynamic> json) {
//     return Metadata(
//       qualityParameters:
//           json['qualityParameters'] != null
//               ? QualityParameters.fromJson(json['qualityParameters'])
//               : null,
//       keywords: (json['keywords'] as List?)?.cast<String>() ?? [],
//       difficultyLevel: json['difficultyLevel'],
//       wordLimit: json['wordLimit'],
//       estimatedTime: json['estimatedTime'],
//       maximumMarks: json['maximumMarks'],
//     );
//   }
// }

// class QualityParameters {
//   Body? body;
//   bool? intro;
//   bool? conclusion;

//   QualityParameters({this.body, this.intro, this.conclusion});

//   factory QualityParameters.fromJson(Map<String, dynamic> json) {
//     return QualityParameters(
//       body: json['body'] != null ? Body.fromJson(json['body']) : null,
//       intro: json['intro'],
//       conclusion: json['conclusion'],
//     );
//   }
// }

// class Body {
//   bool? enabled;
//   bool? features;
//   bool? examples;
//   bool? facts;
//   bool? diagram;

//   Body({this.enabled, this.features, this.examples, this.facts, this.diagram});

//   factory Body.fromJson(Map<String, dynamic> json) {
//     return Body(
//       enabled: json['enabled'],
//       features: json['features'],
//       examples: json['examples'],
//       facts: json['facts'],
//       diagram: json['diagram'],
//     );
//   }
// }

// class Submission {
//   List<AnswerImage>? answerImages;
//   String? textAnswer;
//   List<String>? extractedTexts;
//   int? timeSpent;
//   String? sourceType;

//   Submission({
//     this.answerImages,
//     this.textAnswer,
//     this.extractedTexts,
//     this.timeSpent,
//     this.sourceType,
//   });

//   factory Submission.fromJson(Map<String, dynamic> json) {
//     return Submission(
//       answerImages:
//           (json['answerImages'] as List?)
//               ?.map((e) => AnswerImage.fromJson(e))
//               .toList() ??
//           [],
//       textAnswer: json['textAnswer'],
//       extractedTexts: (json['extractedTexts'] as List?)?.cast<String>() ?? [],
//       timeSpent: json['timeSpent'],
//       sourceType: json['sourceType'],
//     );
//   }
// }

// class AnswerImage {
//   String? imageUrl;
//   String? cloudinaryPublicId;
//   String? originalName;
//   String? uploadedAt;
//   String? id;

//   AnswerImage({
//     this.imageUrl,
//     this.cloudinaryPublicId,
//     this.originalName,
//     this.uploadedAt,
//     this.id,
//   });

//   factory AnswerImage.fromJson(Map<String, dynamic> json) {
//     return AnswerImage(
//       imageUrl: json['imageUrl'],
//       cloudinaryPublicId: json['cloudinaryPublicId'],
//       originalName: json['originalName'],
//       uploadedAt: json['uploadedAt'],
//       id: json['_id'],
//     );
//   }
// }

// class Evaluation {
//   int? relevancy;
//   int? score;
//   String? remark;
//   bool? feedbackStatus;
//   UserFeedback? userFeedback;
//   List<String>? comments;
//   Analysis? analysis;

//   Evaluation({
//     this.relevancy,
//     this.score,
//     this.remark,
//     this.feedbackStatus,
//     this.userFeedback,
//     this.comments,
//     this.analysis,
//   });

//   factory Evaluation.fromJson(Map<String, dynamic> json) {
//     return Evaluation(
//       relevancy: json['relevancy'],
//       score: json['score'],
//       remark: json['remark'],
//       feedbackStatus: json['feedbackStatus'],
//       userFeedback:
//           json['userFeedback'] != null
//               ? UserFeedback.fromJson(json['userFeedback'])
//               : null,
//       comments: (json['comments'] as List?)?.cast<String>() ?? [],
//       analysis:
//           json['analysis'] != null ? Analysis.fromJson(json['analysis']) : null,
//     );
//   }
// }

// class UserFeedback {
//   String? message;
//   String? submittedAt;

//   UserFeedback({this.message, this.submittedAt});

//   factory UserFeedback.fromJson(Map<String, dynamic> json) {
//     return UserFeedback(
//       message: json['message'],
//       submittedAt: json['submittedAt'],
//     );
//   }
// }

// class Analysis {
//   List<String>? strengths;
//   List<String>? weaknesses;
//   List<String>? suggestions;
//   List<String>? feedback;

//   Analysis({this.strengths, this.weaknesses, this.suggestions, this.feedback});

//   factory Analysis.fromJson(Map<String, dynamic> json) {
//     return Analysis(
//       strengths: (json['strengths'] as List?)?.cast<String>() ?? [],
//       weaknesses: (json['weaknesses'] as List?)?.cast<String>() ?? [],
//       suggestions: (json['suggestions'] as List?)?.cast<String>() ?? [],
//       feedback: (json['feedback'] as List?)?.cast<String>() ?? [],
//     );
//   }
// }

// class FeedbackModel {
//   List<String>? suggestions;
//   ExpertReview? expertReview;

//   FeedbackModel({this.suggestions, this.expertReview});

//   factory FeedbackModel.fromJson(Map<String, dynamic> json) {
//     return FeedbackModel(
//       suggestions: (json['suggestions'] as List?)?.cast<String>() ?? [],
//       expertReview:
//           json['expertReview'] != null
//               ? ExpertReview.fromJson(json['expertReview'])
//               : null,
//     );
//   }
// }

// class ExpertReview {
//   List<String>? annotatedImages;
//   String? reviewedAt;

//   ExpertReview({this.annotatedImages, this.reviewedAt});

//   factory ExpertReview.fromJson(Map<String, dynamic> json) {
//     return ExpertReview(
//       annotatedImages: (json['annotatedImages'] as List?)?.cast<String>() ?? [],
//       reviewedAt: json['reviewedAt'],
//     );
//   }
// }
