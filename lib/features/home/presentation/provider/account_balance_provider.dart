import 'package:flutter/cupertino.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/presentation/provider/auth_provider.dart';
import 'package:otlob_gas/features/home/domain/usecases/charge_balance_use_case.dart';
import 'package:provider/provider.dart';

class AccountBalanceProvider extends ChangeNotifier {
  final ChargeBalanceUseCase _chargeBalanceUseCase;
  AccountBalanceProvider(this._chargeBalanceUseCase);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController cardNumberController;

  initPage() async {
    cardNumberController = TextEditingController();
  }

  void disposePage() {
    cardNumberController.dispose();
  }

  static const chargeBalanceDialogName = 'AccountBalance';
  double currentBalance = 0;
  chargeBalance() async {
    final context = NavigationService.context;
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) {
      return;
    }
    Utils.hideCustomDialog(name: chargeBalanceDialogName);
    Utils.showLoading();
    final result =
        await _chargeBalanceUseCase(cardNumber: cardNumberController.text);
    Utils.hideLoading();
    result.fold((failure) => Utils.handleFailures(failure), (holdingWith) {
      currentBalance = holdingWith.data;
      notifyListeners();
      Utils.showToast(holdingWith.message);
      context.read<AuthProvider>().editUser(wallet: currentBalance);
    });
  }
}
