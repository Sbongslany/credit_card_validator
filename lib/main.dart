import 'package:credit_card_validator/presentation/blocs/credit_card_bloc/credit_card_bloc.dart';
import 'package:credit_card_validator/presentation/screens/credit_card_screen.dart';
import 'package:credit_card_validator/util/prefs_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefsHelper = PrefsHelper();
  await prefsHelper.init();
  final bannedCountries = ['Country1', 'Country2']; // Example banned countries
  runApp(MyApp( bannedCountries));
}

class MyApp extends StatelessWidget {
  final List<String> bannedCountries;

  MyApp( this.bannedCountries);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => CreditCardBloc( bannedCountries)..add(LoadCreditCards()),
        child: CreditCardScreen(),
      ),
    );
  }
}

