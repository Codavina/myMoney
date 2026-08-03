import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money/core/cubit/currency/currency_cubit.dart';
import 'package:my_money/core/cubit/currency/currency_state.dart';
import 'package:my_money/core/models/currency_model.dart';
import 'package:my_money/core/utils/app_snackbar.dart';
import 'package:my_money/core/widgets/admin_only.dart';
import 'package:my_money/core/widgets/custom_app_bar.dart';
import 'package:my_money/features/currency_screen/widgets/add_currency_dialog.dart';
import 'package:my_money/features/currency_screen/widgets/currency_body.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_color_extension.dart';
import '../../core/widgets/custom_floating_action_button.dart';
import '../../core/widgets/empty_state.dart';


class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {



  @override
  void initState() {
    super.initState();

  }

  Future<void> _addCurrency()async{

    final CurrencyModel? currency = await showDialog<CurrencyModel>(
      context: context,
      builder: (_) => const AddCurrencyDialog(),
    );
    if(!mounted)return;
    if(currency==null) return;
    context.read<CurrencyCubit>().insert(currency);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Currency Screen Build");
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: CustomAppBar(title: 'currencies'.tr()),
      body: SafeArea(
        child: BlocConsumer<CurrencyCubit, CurrencyState>(
          listener: (context, state) {
            if (state is CurrencyLoaded) {
              if (state.successMessage != null) {
                AppSnackBar.success(
                  context,
                  state.successMessage!,
                );
              }

              if (state.errorMessage != null) {
                AppSnackBar.error(
                  context,
                  state.errorMessage!,
                );
              }
            }

            if (state is CurrencyError) {
              AppSnackBar.error(
                context,
                state.errorMessage,
              );
            }
          },
          builder: (context, state) {
            if (state is CurrencyLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is CurrencyLoaded) {
              if (state.currencies.isEmpty) {
                return const EmptyState(image: AppAssets.emptyCurrencyImage);
              }

              return CurrencyBody(
                currencies: state.currencies,
              );
            }


            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: AdminOnly(
        child: CustomFloatingActionButton(
          onPressed: () => _addCurrency(),
          label: 'add_currency'.tr(),
        ),
      ),
    );
  }
}
