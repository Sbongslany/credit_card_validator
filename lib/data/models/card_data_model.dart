// To parse this JSON data, do
//
//     final cardDataModel = cardDataModelFromJson(jsonString);

import 'dart:convert';

List<CardDataModel> cardDataModelFromJson(String str) => List<CardDataModel>.from(json.decode(str).map((x) => CardDataModel.fromJson(x)));

String cardDataModelToJson(List<CardDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CardDataModel {
  String? cardNumber;
  String? cardType;
  String? cvv;
  String? issuingCountry;

  CardDataModel({
    this.cardNumber,
    this.cardType,
    this.cvv,
    this.issuingCountry,
  });

  factory CardDataModel.fromJson(Map<String, dynamic> json) => CardDataModel(
    cardNumber: json["cardNumber"],
    cardType: json["cardType"],
    cvv: json["cvv"],
    issuingCountry: json["issuingCountry"],
  );

  Map<String, dynamic> toJson() => {
    "cardNumber": cardNumber,
    "cardType": cardType,
    "cvv": cvv,
    "issuingCountry": issuingCountry,
  };
}
