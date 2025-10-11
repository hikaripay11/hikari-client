import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../design_system/colors.dart';
import 'widgets/account_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  String _formatJPY(num value) {
    final f = NumberFormat.currency(locale: 'ja_JP', symbol: '¥', decimalDigits: 0);
    return f.format(value);
  }

  @override
  Widget build(BuildContext context) {
    // 🇯🇵 연결된 은행(모크 데이터)
    final accounts = [
      AccountCard(
        bankName: 'SMBC',
        nickname: '生活費口座',
        balanceJPY: 12503490,
        logoAsset: 'assets/images/banks/smbc.png',
        onSend: () {}, // TODO: 送金フロー
      ),
      AccountCard(
        bankName: 'PayPay銀行',
        nickname: '給与受取',
        balanceJPY: 2890000,
        logoAsset: 'assets/images/banks/paypay.png',
        onSend: () {},
      ),
      AccountCard(
        bankName: 'セブン銀行',
        nickname: '貯金用',
        balanceJPY: 75896410,
        logoAsset: 'assets/images/banks/seven.png',
        onSend: () {},
      ),
    ];

    // 총자산/이번달 지출(모크)
    final totalBalance = accounts.fold<num>(0, (sum, a) => sum + a.balanceJPY);
    final monthlySpent = 158200; // TODO: 이번달 지출 합계로 교체

    return Scaffold(
      backgroundColor: HikariColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'ようこそ、佐藤 翔太さん',
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
          // ── 総合サマリー 카드 (총자산 / 이번달 지출)
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
                        label: '総資産',
                        value: _formatJPY(totalBalance),
                        valueColor: HikariColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SummaryItem(
                        label: '今月の支出',
                        value: _formatJPY(monthlySpent),
                        valueColor: HikariColors.danger, // 살짝 강조
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── 口座一覧 헤더
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                children: [
                  Text(
                    '口座一覧',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text('管理 >')),
                ],
              ),
            ),
          ),

          // ── 계좌 리스트
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.builder(
              itemCount: accounts.length,
              itemBuilder: (_, i) => accounts[i],
            ),
          ),

          // 하단 네비게이션 여백
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

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
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
