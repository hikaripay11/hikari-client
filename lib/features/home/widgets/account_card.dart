import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../design_system/colors.dart';

class AccountCard extends StatelessWidget {
  final String bankName;       // e.g. "SMBC"
  final String nickname;       // e.g. "Living Expense"
  final double balanceJPY;     // current balance in JPY
  final String? logoAsset;     // e.g. assets/images/banks/smbc.png
  final VoidCallback? onSend;
  final VoidCallback? onTap;   // open detail sheet

  const AccountCard({
    super.key,
    required this.bankName,
    required this.nickname,
    required this.balanceJPY,
    this.logoAsset,
    this.onSend,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: HikariColors.border),
            boxShadow: const [
              BoxShadow(color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Logo
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFF3F5F7),
                  backgroundImage: (logoAsset != null) ? AssetImage(logoAsset!) : null,
                  child: (logoAsset == null)
                      ? const Icon(Icons.account_balance, color: HikariColors.textSecondary, size: 18)
                      : null,
                ),

                const SizedBox(width: 12),

                // Balance (subtle) + Nickname
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatJPY(balanceJPY),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: HikariColors.textPrimary,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 2),
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

                // Right: Send button (compact, low-chroma)
                OutlinedButton(
                  onPressed: onSend ?? () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide(color: HikariColors.primary.withOpacity(.25)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    foregroundColor: HikariColors.primary,
                    backgroundColor: HikariColors.primary.withOpacity(.06),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatJPY(double value) {
    final f = NumberFormat.currency(locale: 'ja_JP', symbol: '¥', decimalDigits: 0);
    return f.format(value);
    // 필요시: NumberFormat.compactCurrency(locale: 'ja_JP', symbol: '¥') 도 가능
  }
}
