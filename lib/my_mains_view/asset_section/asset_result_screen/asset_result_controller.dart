import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:mains/models/asset_list.dart';
import '../../../common/api_urls.dart';
import '../../../common/api_services.dart';

class AssetResultController extends GetxController {
  final String assetUrls;
  final bool isDirectPath;

  AssetResultController({required this.assetUrls, this.isDirectPath = false});

  var isLoading = false.obs;
  var assetData = Rxn<AssetListGet>();
  var chapters = <Chapters>[].obs;
  var bookList = <Book>[].obs;
  var summaries = <Summaries>[].obs;
  var videos = <dynamic>[].obs;
  var pyqs = <dynamic>[].obs;
  var subjectiveL1 = <dynamic>[].obs;
  var subjectiveL2 = <dynamic>[].obs;
  var objectiveL1 = <L1>[].obs;
  var objectiveL2 = <L1>[].obs;
  var objectiveL3 = <L1>[].obs;
  late String extractedPath;

  @override
  void onInit() {
    super.onInit();

    extractedPath = extractAssetId(assetUrls);
  }

  String extractAssetId(String url) {
    const key = "mobile-asset-view/";
    final startIndex = url.indexOf(key);

    if (startIndex == -1) {
      return "";
    }

    final result = url.substring(startIndex + key.length);

    return result;
  }

  Future<void> fetchQrResponse() async {
    isLoading.value = true;

    try {
      // Use correct URL based on isDirectPath
      final fullUrl =
          isDirectPath
              ? "${ApiUrls.getAssetData}$assetUrls"
              : "${ApiUrls.getAssetData}$extractedPath";

      debugPrint("Fetching response from: $fullUrl");

      await callWebApiGet(
        null,
        fullUrl,
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          debugPrint("Status Code: ${response.statusCode}");
          try {
            final jsonData = json.decode(response.body);
            final parsedData = AssetListGet.fromJson(jsonData);

            assetData.value = parsedData;
            bookList.assignAll(parsedData.book != null ? [parsedData.book!] : []);
            chapters.assignAll(parsedData.chapters ?? []);
            summaries.assignAll(parsedData.summaries ?? []);
            videos.assignAll(parsedData.videos ?? []);
            pyqs.assignAll(parsedData.pyqs ?? []);
            subjectiveL1.assignAll(parsedData.subjectiveQuestionSets?.l1 ?? []);
            subjectiveL2.assignAll(parsedData.subjectiveQuestionSets?.l2 ?? []);
            objectiveL1.assignAll(parsedData.objectiveQuestionSets?.l1 ?? []);
            objectiveL2.assignAll(parsedData.objectiveQuestionSets?.l2 ?? []);
            objectiveL3.assignAll(parsedData.objectiveQuestionSets?.l3 ?? []);

            debugPrint("🔹 Data loaded into RxLists");
          } catch (e) {
            debugPrint("Failed to parse AssetListGet: $e");
          }
        },
        onError: () {
          debugPrint("HTTP Error while fetching asset data");
        },
      );
    } catch (e) {
      debugPrint("Exception during fetch: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
