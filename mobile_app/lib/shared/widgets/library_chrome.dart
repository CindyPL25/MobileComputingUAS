import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_environment.dart';
import '../../core/theme/app_theme.dart';

class LibraryChrome {
  const LibraryChrome._();

  static String asset(BuildContext context, String path) {
    return AppEnvironment.fromDartDefine().assetUrl(path);
  }
}

class LibraryBrandBar extends StatelessWidget {
  const LibraryBrandBar({
    super.key,
    this.trailing,
    this.showNav = false,
    this.onLogout,
  });

  final Widget? trailing;
  final bool showNav;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final navItems = [
      ('Home', '/landing'),
      ('Katalog', '/catalog'),
      ('Scan QR', '/qr'),
      ('Riwayat', '/history'),
      ('Profil', '/profile'),
      ('Admin', '/admin-login'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useStackedNav = showNav && constraints.maxWidth < 620;
        final nav = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: navItems.map((item) {
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _NavPill(
                  label: item.$1,
                  onTap: () => context.go(item.$2),
                ),
              );
            }).toList(),
          ),
        );

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.navy.withValues(alpha: 0.94),
            border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
          ),
          child: SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppTheme.gold,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.local_library, color: AppTheme.navy, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Mobile E-Library',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (showNav && !useStackedNav)
                          Flexible(
                            flex: 2,
                            child: Align(alignment: Alignment.centerRight, child: nav),
                          ),
                        if (trailing != null) ...[
                          const SizedBox(width: 8),
                          trailing!,
                        ],
                        if (onLogout != null) ...[
                          const SizedBox(width: 4),
                          IconButton(
                            tooltip: 'Logout',
                            onPressed: onLogout,
                            icon: const Icon(Icons.logout, color: Colors.white),
                          ),
                        ],
                      ],
                    ),
                    if (useStackedNav) ...[
                      const SizedBox(height: 10),
                      SizedBox(width: double.infinity, child: nav),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LibraryHeroPanel extends StatelessWidget {
  const LibraryHeroPanel({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.actions = const [],
    this.compact = false,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final String imagePath;
  final List<Widget> actions;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isPhone = constraints.maxWidth < 600;
        final titleSize = compact ? (isPhone ? 27.0 : 30.0) : (isPhone ? 34.0 : 44.0);
        final verticalPadding = compact ? (isPhone ? 24.0 : 28.0) : (isPhone ? 36.0 : 46.0);

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: compact ? (isPhone ? 190 : 210) : (isPhone ? 360 : 320)),
          decoration: BoxDecoration(
            color: AppTheme.navy,
            image: DecorationImage(
              image: NetworkImage(LibraryChrome.asset(context, imagePath)),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(AppTheme.navy.withValues(alpha: 0.56), BlendMode.srcOver),
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(20, verticalPadding, 20, compact ? verticalPadding : verticalPadding - 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppTheme.navy.withValues(alpha: 0.95),
                  AppTheme.navy.withValues(alpha: 0.78),
                  AppTheme.navy.withValues(alpha: isPhone ? 0.46 : 0.26),
                ],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isPhone ? 520 : 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          eyebrow.toUpperCase(),
                          style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          subtitle,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.88), fontSize: isPhone ? 14 : (compact ? 14 : 16), height: 1.45),
                        ),
                        if (actions.isNotEmpty) ...[
                          const SizedBox(height: 22),
                          Wrap(spacing: 10, runSpacing: 10, children: actions),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LibrarySectionHeader extends StatelessWidget {
  const LibrarySectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.action,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eyebrow.toUpperCase(), style: const TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: AppTheme.navy, fontSize: 22, fontWeight: FontWeight.w900, height: 1.08)),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(subtitle!, style: const TextStyle(color: AppTheme.muted, height: 1.4)),
              ],
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class LibraryContent extends StatelessWidget {
  const LibraryContent({
    super.key,
    required this.child,
    this.maxWidth = 1180,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}

class LibraryResponsiveGrid extends StatelessWidget {
  const LibraryResponsiveGrid({
    super.key,
    required this.children,
    this.minTileWidth = 220,
    this.spacing = 12,
    this.runSpacing = 12,
  });

  final List<Widget> children;
  final double minTileWidth;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : minTileWidth;
        final columns = (availableWidth / minTileWidth).floor().clamp(1, children.length);
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            final width = (availableWidth - (spacing * (columns - 1))) / columns;
            return SizedBox(width: width, child: child);
          }).toList(),
        );
      },
    );
  }
}

class LibraryStatCard extends StatelessWidget {
  const LibraryStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.line),
        boxShadow: [BoxShadow(color: AppTheme.navy.withValues(alpha: 0.06), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 14),
          Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.navy)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
        ],
      ),
    );
  }
}

class LibrarySurfaceCard extends StatelessWidget {
  const LibrarySurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.width,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.line),
        boxShadow: [BoxShadow(color: AppTheme.navy.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: child,
    );
  }
}

class _NavPill extends StatelessWidget {
  const _NavPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
      ),
    );
  }
}
