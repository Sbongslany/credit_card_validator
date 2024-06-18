part of 'credit_card_bloc.dart';

// Events
abstract class CreditCardEvent extends Equatable {
  const CreditCardEvent();
}

class AddCreditCard extends CreditCardEvent {
  final String cardNumber;
  final String cardType;
  final String cvv;
  final String issuingCountry;

  const AddCreditCard(this.cardNumber, this.cardType, this.cvv, this.issuingCountry);

  @override
  List<Object> get props => [cardNumber, cardType, cvv, issuingCountry];
}

class LoadCreditCards extends CreditCardEvent {
  @override
  List<Object> get props => [];
}


