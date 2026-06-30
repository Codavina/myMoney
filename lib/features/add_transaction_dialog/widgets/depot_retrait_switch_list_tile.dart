import 'package:flutter/material.dart';

class DepositWithdrawSwitchListTile extends StatelessWidget {
  const DepositWithdrawSwitchListTile({
    super.key,
    required this.isDeposit,
    this.onChanged,
  });

  final bool isDeposit;

  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      activeThumbColor: Colors.teal,
      inactiveThumbColor: Colors.orange,
      inactiveTrackColor: Colors.deepOrange,
      value: isDeposit,
      title: isDeposit
          ? _buildDepositText()
          : _buildWithdrawText(),
      onChanged: onChanged,
    );
  }

  Text _buildWithdrawText() {
    return const Text(
      'Withdraw',
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    );
  }

  Text _buildDepositText() {
    return const Text(
      'Deposit',
      style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
    );
  }
}
