import 'package:flutter/material.dart';

enum TxType { debit, credit } // debit = 지출(-), credit = 입금(+)

class TransactionItem {
    final String id;
    final String title;      // Merchant or note
    final String subtitle;   // Category or memo
    final DateTime date;
    final int amountJPY;     // sign 포함 (지출은 음수)
    final TxType type;
    final IconData icon;

    const TransactionItem({
        required this.id,
        required this.title,
        required this.subtitle,
        required this.date,
        required this.amountJPY,
        required this.type,
        this.icon = Icons.receipt_long_rounded,
    });
}
