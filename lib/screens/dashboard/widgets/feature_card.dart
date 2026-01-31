import 'package:dream_pos/screens/dashBoard/models/feature_model.dart';
import 'package:dream_pos/screens/dashBoard/responsive_helper.dart';
import 'package:dream_pos/widgets/appColors.dart';
import 'package:flutter/material.dart';

/// 🔹 Feature Card Widget - Fluid Responsive
class FeatureCard extends StatefulWidget {
  final FeatureItem feature;
  final ResponsiveHelper responsive;

  const FeatureCard({
    super.key,
    required this.feature,
    required this.responsive,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.responsive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r.featureCardBorderRadius),
          border: Border.all(
            color: _isHovered
                ? widget.feature.iconColor.withOpacity(0.3)
                : AppColors.cardBorder,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? widget.feature.iconColor.withOpacity(0.15)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _isHovered ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // TODO: Navigate to respective screens
            },
            borderRadius: BorderRadius.circular(r.featureCardBorderRadius),
            child: Padding(
              padding: EdgeInsets.all(r.featureCardPadding),
              child: Row(
                children: [
                  // Icon Container - Fluid Size
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: r.featureIconContainerSize,
                    height: r.featureIconContainerSize,
                    decoration: BoxDecoration(
                      color: widget.feature.bgColor,
                      borderRadius: BorderRadius.circular(
                        r.featureIconBorderRadius,
                      ),
                    ),
                    child: Icon(
                      widget.feature.icon,
                      color: widget.feature.iconColor,
                      size: r.featureIconSize,
                    ),
                  ),
                  SizedBox(width: r.featureInternalSpacing),
                  // Text Content - Fluid Sizes
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.feature.title,
                          style: TextStyle(
                            fontSize: r.featureTitleSize,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: r.scale(2, 6)),
                        Text(
                          widget.feature.subtitle,
                          style: TextStyle(
                            fontSize: r.featureSubtitleSize,
                            color: AppColors.textGrey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Arrow Icon - Show on hover
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isHovered ? 1.0 : 0.0,
                    child: Container(
                      padding: EdgeInsets.all(r.scale(6, 10)),
                      decoration: BoxDecoration(
                        color: widget.feature.bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: r.scale(12, 16),
                        color: widget.feature.iconColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
