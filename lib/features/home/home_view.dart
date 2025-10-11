import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../design_system/colors.dart';
import 'widgets/account_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  String _formatJPY(num value) =>
      NumberFormat.currency(locale: 'ja_JP', symbol: '¥', decimalDigits: 0).format(value);

  @override
  Widget build(BuildContext context) {
    // Connected accounts (mock)
    final accounts = [
      AccountCard(
        bankName: 'SMBC',
        nickname: 'Living Expense',
        balanceJPY: 142380,
        logoAsset: 'assets/images/banks/smbc.png',
        onSend: () {},
      ),
      AccountCard(
        bankName: 'PayPay Bank',
        nickname: 'Salary',
        balanceJPY: 86720,
        logoAsset: 'assets/images/banks/paypay.png',
        onSend: () {},
      ),
      AccountCard(
        bankName: 'Seven Bank',
        nickname: 'Savings',
        balanceJPY: 1256000,
        logoAsset: 'assets/images/banks/seven.png',
        onSend: () {},
      ),
    ];

    final totalBalance = accounts.fold<num>(0, (sum, a) => sum + a.balanceJPY);
    final monthlySpent = 218400; // mock

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
