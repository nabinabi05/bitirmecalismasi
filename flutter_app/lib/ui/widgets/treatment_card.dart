import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/disease_treatments.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TreatmentCard — result_screen ve history_screen tarafından paylaşılır.
//
// [rawLabel]     : modelin döndürdüğü ham etiket (ör. "Apple___Apple_scab")
// [initiallyExpanded] : varsayılan açık/kapalı durumu
// ─────────────────────────────────────────────────────────────────────────────

class TreatmentCard extends StatefulWidget {
  final String rawLabel;
  final bool initiallyExpanded;

  const TreatmentCard({
    super.key,
    required this.rawLabel,
    this.initiallyExpanded = true,
  });

  @override
  State<TreatmentCard> createState() => _TreatmentCardState();
}

class _TreatmentCardState extends State<TreatmentCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final info = DiseaseTreatments.forLabel(widget.rawLabel);
    if (info == null) return const SizedBox.shrink();

    final bool isHealthy = info.severity == 'healthy';
    final Color accentColor =
        isHealthy ? AppColors.healthy : _severityColor(info.severity);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCardBg
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Başlık ──────────────────────────────────────────────────────
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.lg, vertical: AppPadding.md),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isHealthy
                          ? Icons.verified_rounded
                          : Icons.healing_rounded,
                      color: accentColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isHealthy
                          ? 'Koruyucu Bakım Önerileri'
                          : 'Tedavi Önerileri',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: accentColor,
                  ),
                ],
              ),
            ),
          ),

          if (_expanded) ...[
            Divider(height: 1, color: accentColor.withValues(alpha: 0.2)),
            Padding(
              padding: const EdgeInsets.all(AppPadding.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Açıklama
                  Text(
                    info.description,
                    style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.textSecondary),
                  ),

                  // Tedavi adımları (sağlıklıda gösterme)
                  if (!isHealthy && info.treatments.isNotEmpty) ...[
                    const SizedBox(height: AppPadding.md),
                    TreatmentSectionTitle(
                        icon: Icons.medical_services_outlined,
                        label: 'Tedavi Adımları',
                        color: accentColor),
                    const SizedBox(height: 8),
                    ...info.treatments
                        .map((t) => TreatmentBulletItem(text: t, color: accentColor)),
                  ],

                  // Önleme
                  if (info.prevention.isNotEmpty) ...[
                    const SizedBox(height: AppPadding.md),
                    TreatmentSectionTitle(
                        icon: Icons.shield_outlined,
                        label: isHealthy
                            ? 'Koruyucu Önlemler'
                            : 'Önleme Yöntemleri',
                        color: accentColor),
                    const SizedBox(height: 8),
                    ...info.prevention
                        .map((p) => TreatmentBulletItem(text: p, color: accentColor)),
                  ],

                  // Şiddet etiketi
                  if (!isHealthy) ...[
                    const SizedBox(height: AppPadding.md),
                    Row(
                      children: [
                        const Text('Şiddet:  ',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _severityLabel(info.severity),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: accentColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'low':
        return Colors.amber.shade700;
      case 'medium':
        return Colors.orange.shade700;
      case 'high':
        return AppColors.diseased;
      default:
        return AppColors.primary;
    }
  }

  String _severityLabel(String severity) {
    switch (severity) {
      case 'low':
        return 'Düşük';
      case 'medium':
        return 'Orta';
      case 'high':
        return 'Yüksek';
      default:
        return severity;
    }
  }
}

class TreatmentSectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const TreatmentSectionTitle(
      {super.key, required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

class TreatmentBulletItem extends StatelessWidget {
  final String text;
  final Color color;

  const TreatmentBulletItem(
      {super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
