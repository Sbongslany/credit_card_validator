import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:credit_card_validator/data/models/card_data_model.dart';
import 'package:equatable/equatable.dart';

import '../../../util/prefs_helper.dart';

part 'credit_card_event.dart';

part 'credit_card_state.dart';

class CreditCardBloc extends Bloc<CreditCardEvent, CreditCardState> {
  final List<String> bannedCountries;
  final prefsHelper = PrefsHelper();

  CreditCardBloc(this.bannedCountries) : super(CreditCardState.initial()) {
    on<AddCreditCard>(_onAddCreditCard);
    on<LoadCreditCards>(_onLoadCreditCards);
  }

  Future<void> _onAddCreditCard(
      AddCreditCard event, Emitter<CreditCardState> emit) async {
    List<CardDataModel>? cardDataModelList = [];
    if (prefsHelper.prefs.containsKey('cardDataModel')) {
      cardDataModelList = await prefsHelper.getCardsList();
    }

    if (!bannedCountries.contains(event.issuingCountry) &&
        !((cardDataModelList
                ?.any((card) => card.cardNumber == event.cardNumber)) ??
            false)) {
      CardDataModel cardDataModel = CardDataModel(
          cardNumber: event.cardNumber,
          cardType: event.cardType,
          cvv: event.cvv,
          issuingCountry: event.issuingCountry);
      cardDataModelList?.insert(cardDataModelList.length, cardDataModel);
      await prefsHelper.setCardsList(cardDataModelList!);
      emit(state.copyWith(creditCards: cardDataModelList));
    }
    else{
      if(bannedCountries.contains(event.issuingCountry)){
        emit(state.copyWith(errorMessage: '${event.issuingCountry} is not allowed'));
      }
      else {
        emit(state.copyWith(errorMessage: '${event.cardNumber} is already added'));
      }
    }
  }

  void _onLoadCreditCards(
      LoadCreditCards event, Emitter<CreditCardState> emit) async {
    List<CardDataModel>? cardDataModelList = [];
    if (prefsHelper.prefs.containsKey('cardDataModel')) {
      cardDataModelList = await prefsHelper.getCardsList();
    }
    emit(state.copyWith(creditCards: cardDataModelList));
  }
}
