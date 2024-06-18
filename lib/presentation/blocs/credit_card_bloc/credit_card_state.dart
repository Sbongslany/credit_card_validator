part of 'credit_card_bloc.dart';

class CreditCardState extends Equatable {
  final String? errorMessage;
  final List<CardDataModel> creditCards;

  const CreditCardState({this.errorMessage, this.creditCards = const []});

  factory CreditCardState.initial() {
    return const CreditCardState();
  }

  @override
  List<Object?> get props => [creditCards, errorMessage];

  CreditCardState copyWith(
      {String? errorMessage, final List<CardDataModel>? creditCards}) {
    return CreditCardState(
        errorMessage: errorMessage,
        creditCards: creditCards ?? this.creditCards);
  }
}
