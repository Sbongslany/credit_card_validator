import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/card_data_model.dart';

class PrefsHelper {
  static final PrefsHelper _instance = PrefsHelper._internal();

  late SharedPreferences prefs;

  factory PrefsHelper() {
    return _instance;
  }

  PrefsHelper._internal();

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setCardsList(List<CardDataModel> cardDataModel) async {
    return await prefs.setString('cardDataModel', cardDataModelToJson(cardDataModel));
  }

  Future<List<CardDataModel>?> getCardsList() async {
    String? data = await prefs.getString('cardDataModel');
    if (data == null || data.isEmpty) {
      return null;
    } else {
      return cardDataModelFromJson(data);
    }
  }
}
