import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../design_system/colors.dart';
import '../transactions/transaction_model.dart';

class AccountDetailSheet extends StatelessWidget {
    final String bankName;
    final String nickname;
    final int currentBalanceJPY;
    final List<TransactionItem> transactions;
    const AccountDetailSheet({
        super.key,
        required this.bankName,
        required this.nickname,
        required this.currentBalanceJPY,
        required this.transactions,
    });

    String _jpy(num v) => NumberFormat.currency(locale: 'ja_JP', symbol: '¥', decimalDigits: 0).format(v);

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            top: false,
            child: Container(
                decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        const SizedBox(height: 8),
                        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(8))),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                            child: Row(
                                children: [
                                    Expanded(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Text(bankName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: HikariColors.textPrimary)),
                                            const SizedBox(height: 4),
                                            Text(nickname, style: const TextStyle(color: HikariColors.textSecondary)),
                                        ]),
                                    ),
                                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                        const Text('Balance', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                        const SizedBox(height: 4),
                                        Text(_jpy(currentBalanceJPY), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                    ]),
                                ],
                            ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                            child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                                itemCount: transactions.length,
                                separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEAECEF)),
                                itemBuilder: (_, i) {
                                    final tx = transactions[i];
                                    final isDebit = tx.type == TxType.debit;
                                    final color = isDebit ? HikariColors.textPrimary : HikariColors.success;
                                    final prefix = isDebit ? '- ' : '+ ';
                                    return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                            radius: 18,
                                            backgroundColor: const Color(0xFFF3F5F7),
                                            child: Icon(tx.icon, size: 18, color: HikariColors.textSecondary),
                                        ),
                                        title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                                        subtitle: Text(
                                            "${DateFormat('MMM d').format(tx.date)} • ${tx.subtitle}",
                                            style: const TextStyle(color: HikariColors.textSecondary),
                                        ),
                                        trailing: Text(
                                            "$prefix${_jpy(tx.amountJPY.abs())}",
                                            style: TextStyle(fontWeight: FontWeight.w700, color: color),
                                        ),
                                    );
                                },
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
