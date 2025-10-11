import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../design_system/colors.dart';
import 'widgets/account_card.dart';
import '../account_detail/account_detail_sheet.dart';
import '../transactions/transaction_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  String _formatJPY(num value) =>
      NumberFormat.currency(locale: 'ja_JP', symbol: '¥', decimalDigits: 0).format(value);

  List<TransactionItem> _mockFor(String key) {
    final now = DateTime.now();
    switch (key) {
      case 'SMBC':
        return [
          TransactionItem(
              id: 't1',
              title: 'FamilyMart',
              subtitle: 'Convenience',
              date: now.subtract(const Duration(days: 1)),
              amountJPY: -620,
              type: TxType.debit,
              icon: Icons.local_grocery_store_rounded),
          TransactionItem(
              id: 't2',
              title: 'Toei Subway',
              subtitle: 'Transport',
              date: now.subtract(const Duration(days: 1)),
              amountJPY: -310,
              type: TxType.debit,
              icon: Icons.directions_subway_rounded),
          TransactionItem(
              id: 't3',
              title: 'TEPCO',
              subtitle: 'Electricity',
              date: now.subtract(const Duration(days: 3)),
              amountJPY: -5430,
              type: TxType.debit,
              icon: Icons.light_mode_rounded),
          TransactionItem(
              id: 't4',
              title: 'Spotify',
              subtitle: 'Subscription',
              date: now.subtract(const Duration(days: 5)),
              amountJPY: -980,
              type: TxType.debit,
              icon: Icons.music_note_rounded),
          TransactionItem(
              id: 't5',
              title: 'Salary Split',
              subtitle: 'From PayPay',
              date: now.subtract(const Duration(days: 6)),
              amountJPY: 60000,
              type: TxType.credit,
              icon: Icons.swap_horiz_rounded),
        ];
      case 'PayPay Bank':
        return [
          TransactionItem(
              id: 'p1',
              title: 'Company Payroll',
              subtitle: 'Salary',
              date: now.subtract(const Duration(days: 6)),
              amountJPY: 350000,
              type: TxType.credit,
              icon: Icons.payments_rounded),
          TransactionItem(
              id: 'p2',
              title: 'Auto transfer',
              subtitle: 'To SMBC',
              date: now.subtract(const Duration(days: 6)),
              amountJPY: -60000,
              type: TxType.debit,
              icon: Icons.swap_horiz_rounded),
          TransactionItem(
              id: 'p3',
              title: 'Auto transfer',
              subtitle: 'To Savings',
              date: now.subtract(const Duration(days: 6)),
              amountJPY: -200000,
              type: TxType.debit,
              icon: Icons.savings_rounded),
        ];
      default: // Seven Bank
        return [
          TransactionItem(
              id: 's1',
              title: 'Monthly Deposit',
              subtitle: 'Savings plan',
              date: now.subtract(const Duration(days: 6)),
              amountJPY: 200000,
              type: TxType.credit,
              icon: Icons.savings_rounded),
          TransactionItem(
              id: 's2',
              title: 'Bonus',
              subtitle: 'Summer bonus',
              date: now.subtract(const Duration(days: 35)),
              amountJPY: 300000,
              type: TxType.credit,
              icon: Icons.card_giftcard_rounded),
          TransactionItem(
              id: 's3',
              title: 'ATM Withdrawal',
              subtitle: 'Emergency',
              date: now.subtract(const Duration(days: 10)),
              amountJPY: -15000,
              type: TxType.debit,
              icon: Icons.atm_rounded),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Connected accounts (realistic mock)
    final accounts = [
      AccountCard(
        bankName: 'SMBC',
        nickname: 'Living Expense',
        balanceJPY: 142380,
        logoAsset: 'assets/images/banks/smbc.png',
        onSend: () {},
        onTap: () => _openSheet(
          context,
          bankName: 'SMBC',
          nickname: 'Living Expense',
          balance: 142380,
          txs: _mockFor('SMBC'),
        ),
      ),
      AccountCard(
        bankName: 'PayPay Bank',
        nickname: 'Salary',
        balanceJPY: 86720,
        logoAsset: 'assets/images/banks/paypay.png',
        onSend: () {},
        onTap: () => _openSheet(
          context,
          bankName: 'PayPay Bank',
          nickname: 'Salary',
          balance: 86720,
          txs: _mockFor('PayPay Bank'),
        ),
      ),
      AccountCard(
        bankName: 'Seven Bank',
        nickname: 'Savings',
        balanceJPY: 1256000,
        logoAsset: 'assets/images/banks/seven.png',
        onSend: () {},
        onTap: () => _openSheet(
          context,
          bankName: 'Seven Bank',
          nickname: 'Savings',
          balance: 1256000,
          txs: _mockFor('Seven Bank'),
        ),
      ),
    ];

    final totalBalance = accounts.fold<num>(0, (sum, a) => sum + a.balanceJPY);
    final monthlySpent = 218400; // realistic monthly spend

    return Scaffold(
      backgroundColor: HikariColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Welcome, Shota Sato',
          style: TextStyle(
            color: HikariColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Summary (Total / Spent)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 4)),
                  ],
                  border: Border.all(color: HikariColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: _SummaryItem(
                        label: 'Total Assets',
                        value: _formatJPY(totalBalance),
                        isDanger: false,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SummaryItem(
                        label: 'Spent this month',
                        value: _formatJPY(monthlySpent),
                        isDanger: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Accounts header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Accounts',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text('Manage >')),
                ],
              ),
            ),
          ),

          // Accounts list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.builder(
              itemCount: accounts.length,
              itemBuilder: (_, i) => accounts[i],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  void _openSheet(
    BuildContext context, {
    required String bankName,
    required String nickname,
    required int balance,
    required List<TransactionItem> txs,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.86,
        child: AccountDetailSheet(
          bankName: bankName,
          nickname: nickname,
          currentBalanceJPY: balance,
          transactions: txs,
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDanger;
  const _SummaryItem({required this.label, required this.value, this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDanger ? HikariColors.danger : HikariColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
