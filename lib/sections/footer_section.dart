import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width < 1024 && size.width >= 768;
    final isMobile = size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 30 : 40),
        vertical: isMobile ? 30 : 40,
      ),
      child: GlassContainer(
        padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 25 : 30)),
        child: Column(
          children: [
            // Separator line
            Container(
              height: 1,
              width: double.infinity,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            ),
            SizedBox(height: isMobile ? 20 : 30),
            isMobile
                ? Column(
                    children: [
                      // Copyright
                      Text(
                        '© 2025 Sarankumar All rights reserved.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Quick links
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 15,
                        runSpacing: 10,
                        children: [
                          _buildFooterLink(context, 'About', () {}, isMobile),
                          _buildFooterLink(context, 'Projects', () {}, isMobile),
                          _buildFooterLink(context, 'Contact', () {}, isMobile),
                          GlassContainer(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: InkWell(
                              onTap: () {
                                // Download resume
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.download,
                                    size: 14,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Resume',
                                    style: Theme.of(context).textTheme.bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Copyright
                      Text(
                        '© 2025 Sarankumar All rights reserved.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: isTablet ? 13 : 14),
                      ),
                      // Quick links
                      Row(
                        children: [
                          _buildFooterLink(context, 'About', () {}, isMobile),
                          SizedBox(width: isTablet ? 15 : 20),
                          _buildFooterLink(context, 'Projects', () {}, isMobile),
                          SizedBox(width: isTablet ? 15 : 20),
                          _buildFooterLink(context, 'Contact', () {}, isMobile),
                          SizedBox(width: isTablet ? 15 : 20),
                          GlassContainer(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 10 : 12,
                              vertical: isTablet ? 5 : 6,
                            ),
                            child: InkWell(
                              onTap: () {
                                // Download resume
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.download,
                                    size: isTablet ? 14 : 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  SizedBox(width: isTablet ? 3 : 4),
                                  Text(
                                    'Resume',
                                    style: Theme.of(context).textTheme.bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: isTablet ? 13 : 14,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink(
    BuildContext context,
    String text,
    VoidCallback onTap,
    bool isMobile,
  ) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontSize: isMobile ? 12 : 14,
        ),
      ),
    );
  }
}
