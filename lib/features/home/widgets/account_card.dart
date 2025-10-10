import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../design_system/colors.dart';

class AccountCard extends StatelessWidget {
  final String bankName;
  final String nickname;        // 히카리 별명
  final double balanceJPY;
  final String? logoAsset;
  final VoidCallback? onSend;

  const AccountCard({
    super.key,
    required this.bankName,
    required this.nickname,
    required this.balanceJPY,
    this.logoAsset,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HikariColors.border),
        boxShadow: const [
          // 아주 약한 그림자만
          BoxShadow(color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // 로고
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFF3F5F7),
              backgroundImage: (logoAsset != null) ? AssetImage(logoAsset!) : null,
              child: (logoAsset == null)
                  ? const Icon(Icons.account_balance, color: HikariColors.textSecondary, size: 18)
                  : null,
            ),
            const SizedBox(width: 12),

            // 가운데: 잔액(덜 강조) + 별명
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 잔액 – 굵기/색/크기 낮춤
                  Text(
                    _formatJPY(balanceJPY),
                    style: const TextStyle(
                      fontSize: 14,                      // ↓ 18 → 16
                      fontWeight: FontWeight.w600,       // ↓ w800 → w600
                      color: HikariColors.textPrimary,   // 진한 파랑 X
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 2),
                  // 별명 – 보조톤
                  Text(
                    nickname.isEmpty ? bankName : nickname,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: HikariColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // 오른쪽: 送金 버튼 – 작고 채도 낮은 토널/아웃라인
            _SendButton(onPressed: onSend),
          ],
        ),
      ),
    );
  }

  String _formatJPY(double value) {
    final f = NumberFormat.currency(locale: 'ja_JP', symbol: '¥', decimalDigits: 0);
    return f.format(value);
  }
}

class _SendButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const _SendButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed ?? () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // 작게
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(color: HikariColors.primary.withOpacity(.25)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        foregroundColor: HikariColors.primary,
        backgroundColor: HikariColors.primary.withOpacity(.06), // 채도 낮은 토널
        elevation: 0,
      ),
      child: const Text(
        '送金',
        style: TextStyle(
          fontSize: 13,                 // 작게
          fontWeight: FontWeight.w700,  // 또렷하되 과하지 않게
          letterSpacing: .2,
        ),
      ),
    );
  }
}
