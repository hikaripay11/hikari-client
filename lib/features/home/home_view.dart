import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import 'widgets/account_card.dart';
import 'widgets/txn_wave_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🇯🇵 은행 3개 (SMBC / PayPay / Seven)
    final accounts = [
      AccountCard(
        bankName: 'SMBC',
        nickname: '生活費口座',             // 히카리 별명
        balanceJPY: 12503490,
        logoAsset: 'assets/images/banks/smbc.png',
        onSend: () { /* TODO: 送金フローへ */ },
      ),
      AccountCard(
        bankName: 'PayPay銀行',
        nickname: '給与受取',
        balanceJPY: 2890000,
        logoAsset: 'assets/images/banks/paypay.png',   // ← 파일 추가 필요
        onSend: () {},
      ),
      AccountCard(
        bankName: 'セブン銀行',
        nickname: '貯金用',
        balanceJPY: 75896410,
        logoAsset: 'assets/images/banks/seven.png',    // ← 파일 추가 필요
        onSend: () {},
      ),
    ];

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
            fontSize: 20,
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
          // 口座一覧
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Text('口座一覧',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.black54, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text('管理 >')),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.builder(
              itemCount: accounts.length,
              itemBuilder: (_, i) => accounts[i],
            ),
          ),

          // 아래 트랜잭션 섹션은 필요 시 유지/삭제
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _Section('入金 (Incoming Transactions)', children: const [
                TxnWaveCard(
                  name: 'Johnny Bairstow',
                  date: '2020年12月23日',
                  amount: 54.23,
                  avatarUrl: 'https://i.pravatar.cc/100?img=12',
                ),
                TxnWaveCard(
                  name: 'Johnson Charles',
                  date: '2020年12月23日',
                  amount: 62.54,
                  avatarUrl: 'https://i.pravatar.cc/100?img=5',
                ),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              child: _Section('出金 (Outgoing Transactions)', children: const [
                TxnWaveCard(
                  name: 'John Morrison',
                  date: '2021年12月12日',
                  amount: -396.84,
                  avatarUrl: 'https://i.pravatar.cc/100?img=18',
                ),
                TxnWaveCard(
                  name: 'Mellony Storks',
                  date: '2021年12月12日',
                  amount: -45.21,
                  avatarUrl: 'https://i.pravatar.cc/100?img=32',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section(this.title, {required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54)),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text('すべて表示 >')),
        ]),
        const SizedBox(height: 10),
        SizedBox(
          height: 190,
          child: ListView(scrollDirection: Axis.horizontal, children: children),
        ),
      ],
    );
  }
}
