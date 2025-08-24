import 'package:flutter/material.dart';
import '../../../config/theme.dart';

class TabNavigationBar extends StatelessWidget {
  final List<TabItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;

  const TabNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
          child: Row(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;
              
              return Expanded(
                child: _buildTabItem(
                  context,
                  item,
                  isSelected,
                  () => onTap(index),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    TabItem item,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final color = isSelected
        ? (selectedColor ?? AppTheme.primaryPink)
        : (unselectedColor ?? Colors.grey.shade500);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingS,
          vertical: AppTheme.spacingS,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppTheme.shortAnimation,
              child: Icon(
                isSelected ? item.activeIcon ?? item.icon : item.icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXXS),
            AnimatedDefaultTextStyle(
              duration: AppTheme.shortAnimation,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 12,
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalTabBar extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const HorizontalTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacingS),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.lightGray,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == currentIndex;

          return Expanded(
            child: _buildTab(context, tab, isSelected, () => onTap(index)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return AnimatedContainer(
      duration: AppTheme.shortAnimation,
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXXS),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
          child: AnimatedContainer(
            duration: AppTheme.shortAnimation,
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spacingS,
              horizontal: AppTheme.spacingM,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: AppTheme.shortAnimation,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isSelected
                      ? (selectedColor ?? AppTheme.primaryPink)
                      : (unselectedColor ?? Colors.grey.shade600),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchTabBar extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const SearchTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == currentIndex;
          return Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacingM),
            child: _buildSearchTab(
              context,
              tabs[index],
              isSelected,
              () => onTap(index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchTab(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        child: AnimatedContainer(
          duration: AppTheme.shortAnimation,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingL,
            vertical: AppTheme.spacingM,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryPink : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
            border: isSelected
                ? null
                : Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: AppTheme.shortAnimation,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}

class TabItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String? badge;

  const TabItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.badge,
  });
}