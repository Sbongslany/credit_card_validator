import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:credit_card_validator/util/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../util/permission_helper.dart';
import '../blocs/credit_card_bloc/credit_card_bloc.dart';

class CreditCardScreen extends StatefulWidget {
  @override
  State<CreditCardScreen> createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  final cardNumberController = TextEditingController();

  final cardTypeController = TextEditingController();

  final cvvController = TextEditingController();

  final issuingCountryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void inferCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) {
      cardTypeController.text = 'Visa';
    } else if (cardNumber.startsWith('5')) {
      cardTypeController.text = 'MasterCard';
    } else if (cardNumber.startsWith('3')) {
      cardTypeController.text = 'American Express';
    } else {
      cardTypeController.text = 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Credit Card Validator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera),
            onPressed: () => _checkCameraPermission(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: cardNumberController,
                decoration: Common.getInputDecorator('Card Number'),
                onChanged: (value) {
                  inferCardType(value);
                },
                validator: (val) {
                  if ((val?.isEmpty) ?? true) {
                    return 'Please enter credit card number';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: cardTypeController,
                decoration: Common.getInputDecorator('Card Type'),
                validator: (val) {
                  if ((val?.isEmpty) ?? true) {
                    return 'Please enter credit card type';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: cvvController,
                decoration: Common.getInputDecorator('CVV'),
                validator: (val) {
                  if ((val?.isEmpty) ?? true) {
                    return 'Please enter CVV';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: issuingCountryController,
                decoration: Common.getInputDecorator('Issuing Country'),
                validator: (val) {
                  if ((val?.isEmpty) ?? true) {
                    return 'Please enter issuing country';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  final cardNumber = cardNumberController.text;
                  final cardType = cardTypeController.text;
                  final cvv = cvvController.text;
                  final issuingCountry = issuingCountryController.text;
                  if (_formKey.currentState!.validate()) {
                    context.read<CreditCardBloc>().add(AddCreditCard(
                        cardNumber, cardType, cvv, issuingCountry));
                  }
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocConsumer<CreditCardBloc, CreditCardState>(
                  listener: (context, state) {
                    if (state.errorMessage != null) {
                      Common.showSnackbar(state.errorMessage!);
                    }
                  },
                  builder: (context, state) {
                    if (state.creditCards.isNotEmpty) {
                      return ListView.builder(
                        itemCount: state.creditCards.length,
                        itemBuilder: (context, index) {
                          final card = state.creditCards[index];
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1), borderRadius: BorderRadius.circular(8)),
                                child: ListTile(
                                  title: Text(card.cardNumber!),
                                  subtitle: Text(
                                      '${card.cardType} - ${card.issuingCountry}'),
                                ),
                              ),
                              SizedBox(height: index == state.creditCards.length - 1 ? 0 : 12),
                            ],
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _checkCameraPermission() async {
    List<Permission> permissionsToCheck = [Permission.camera];
    if (await PermissionHelper.checkMultiplePermissions(permissionsToCheck)) {
      final cardDetails = await CardScanner.scanCard();
      if (cardDetails != null) {
        cardNumberController.text = cardDetails.cardNumber;
        inferCardType(cardDetails.cardNumber);
      }
    } else {
      Common.showAlert(context, title: 'Permission Denied', message: 'This app requires camera access to scan card. Please click ok to grant camera permission from settings.', onOkPressed: () => openAppSettings());
    }
  }
}
