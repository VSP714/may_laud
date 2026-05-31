import 'package:flutter/material.dart';

// ===================== ANNOUNCEMENTS FEED SCREEN =====================
class AnnouncementsFeedScreen extends StatelessWidget {
  const AnnouncementsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final bg = isDark ? cs.background : const Color(0xFFF6F1FA);
    final dark = isDark ? cs.onSurface : const Color(0xFF2D145F);
    final muted = isDark ? cs.onSurface.withOpacity(0.55) : const Color(0xFF7C7487);
    final cardBg = isDark ? cs.surface : Colors.white;
    final searchBg = isDark ? cs.surface : const Color(0xFFF0EAF5);

    return Scaffold(
      backgroundColor: bg,
      bottomNavigationBar: Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: isDark ? cs.surface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _BottomNavItem(icon: Icons.home_outlined, label: 'HOME'),
            _BottomNavItem(icon: Icons.newspaper, label: 'NEWS', active: true),
            _BottomNavItem(icon: Icons.event_note_outlined, label: 'EVENTS'),
            _BottomNavItem(icon: Icons.person_outline, label: 'PROFILE'),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                children: [
                  Icon(Icons.menu, color: dark),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Civic Square',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: dark,
                      ),
                    ),
                  ),
                  const CircleAvatar(radius: 18, child: Icon(Icons.person)),
                ],
              ),
              const SizedBox(height: 26),
              const Text(
                'THE DAILY FLOW',
                style: TextStyle(
                  color: Color(0xFF7A5BC8),
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Announcements',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w500,
                  color: dark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your digital porch for everything happening in Milaor, from emergency alerts to local festivities.',
                style: TextStyle(fontSize: 16, height: 1.6, color: muted),
              ),
              const SizedBox(height: 20),
              // ── Search bar ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: searchBg,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: muted),
                    const SizedBox(width: 10),
                    Text(
                      'Find specific updates...',
                      style: TextStyle(
                        color: isDark
                            ? cs.onSurface.withOpacity(0.35)
                            : const Color(0xFFB0A9BA),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // ── Filter chips ──
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _FilterChip(label: 'All', active: true),
                  _FilterChip(label: 'Emergency'),
                  _FilterChip(label: 'Events'),
                  _FilterChip(label: 'Public Notices'),
                ],
              ),
              const SizedBox(height: 28),
              // ── Cards ──
              _AnnouncementCard(
                cardBg: cardBg,
                dark: dark,
                image: 'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?q=80&w=1200&auto=format&fit=crop',
                tag: 'EMERGENCY',
                time: '2 hours ago',
                title: 'Bicol River Level Warning: Precautionary Measures',
                desc: 'Local authorities advise residents near the riverbank to remain vigilant as water levels rise due to monsoon rains.',
                footer: 'Read Full Alert  ➜',
                footerPurple: true,
              ),
              const SizedBox(height: 22),
              _TextOnlyCard(cardBg: cardBg, dark: dark),
              const SizedBox(height: 22),
              _RecyclingCard(cardBg: cardBg, dark: dark),
              const SizedBox(height: 22),
              _SpotlightCard(isDark: isDark),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Announcement image card ──────────────────────────────────────────
class _AnnouncementCard extends StatelessWidget {
  final Color cardBg;
  final Color dark;
  final String image, tag, time, title, desc, footer;
  final bool footerPurple;

  const _AnnouncementCard({
    required this.cardBg,
    required this.dark,
    required this.image,
    required this.tag,
    required this.time,
    required this.title,
    required this.desc,
    required this.footer,
    this.footerPurple = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bodyColor = isDark
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.65)
        : const Color(0xFF6D6678);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
            child: Image.network(image,
                height: 220, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE2E2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(tag,
                        style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFD14A4A),
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 10),
                  Text(time, style: const TextStyle(color: Color(0xFF9B94A5))),
                ]),
                const SizedBox(height: 18),
                Text(title,
                    style: TextStyle(fontSize: 22, height: 1.15, color: dark)),
                const SizedBox(height: 14),
                Text(desc, style: TextStyle(height: 1.7, color: bodyColor)),
                const SizedBox(height: 18),
                Text(footer,
                    style: TextStyle(
                        color: footerPurple
                            ? const Color(0xFF5B21B6)
                            : bodyColor,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Text-only card ───────────────────────────────────────────────────
class _TextOnlyCard extends StatelessWidget {
  final Color cardBg;
  final Color dark;
  const _TextOnlyCard({required this.cardBg, required this.dark});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bodyColor = isDark
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.65)
        : const Color(0xFF6D6678);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: cardBg, borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const _MiniTag(label: 'EVENTS'),
            const Spacer(),
            const Text('5 hours ago',
                style: TextStyle(color: Color(0xFF9B94A5))),
          ]),
          const SizedBox(height: 18),
          Text('Upcoming Town Hall Meeting',
              style: TextStyle(fontSize: 20, color: dark)),
          const SizedBox(height: 12),
          Text(
              'Join us this Saturday at the Civic Plaza to discuss the new urban gardening initiative and heritage preservation projects.',
              style: TextStyle(height: 1.7, color: bodyColor)),
        ],
      ),
    );
  }
}

// ── Recycling card ───────────────────────────────────────────────────
class _RecyclingCard extends StatelessWidget {
  final Color cardBg;
  final Color dark;
  const _RecyclingCard({required this.cardBg, required this.dark});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bodyColor = isDark
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.65)
        : const Color(0xFF6D6678);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: cardBg, borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const _MiniTag(label: 'PUBLIC NOTICES'),
            const Spacer(),
            const Text('Yesterday',
                style: TextStyle(color: Color(0xFF9B94A5))),
          ]),
          const SizedBox(height: 18),
          Text('New Recycling Schedule',
              style: TextStyle(fontSize: 20, color: dark)),
          const SizedBox(height: 12),
          Text(
              'Starting next Monday, plastic and paper collection will move to bi-weekly intervals.',
              style: TextStyle(height: 1.7, color: bodyColor)),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
                'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?q=80&w=1200&auto=format&fit=crop',
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}

// ── Spotlight card ───────────────────────────────────────────────────
class _SpotlightCard extends StatelessWidget {
  final bool isDark;
  const _SpotlightCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final spotBg = isDark ? const Color(0xFF2A1A4E) : const Color(0xFFE9DDFC);
    final spotBodyColor =
        isDark ? Colors.white.withOpacity(0.65) : const Color(0xFF6D6678);
    final spotTitleColor =
        isDark ? Colors.white : const Color(0xFF2D145F);
    final iconBg = isDark ? const Color(0xFF1E1240) : const Color(0xFFF2EAFB);
    final iconColor = isDark ? Colors.white54 : const Color(0xFF2D145F);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: spotBg, borderRadius: BorderRadius.circular(34)),
      child: Column(children: [
        const Text('CIVIC SPOTLIGHT',
            style: TextStyle(
                letterSpacing: 2,
                color: Color(0xFF9B7FE8),
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        Text('Milaor Heritage Festival: Vendor Applications Open',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: spotTitleColor)),
        const SizedBox(height: 14),
        Text(
            "Celebrate our roots! We're inviting local artisans and food vendors to showcase their craft.",
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.7, color: spotBodyColor)),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B21B6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28))),
            child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                child:
                    Text('Apply Now', style: TextStyle(color: Colors.white)))),
        const SizedBox(height: 22),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
              color: iconBg, borderRadius: BorderRadius.circular(28)),
          child: Icon(Icons.storefront_outlined, size: 56, color: iconColor),
        ),
      ]),
    );
  }
}

// ── Shared small widgets ─────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  const _FilterChip({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveBg =
        isDark ? Theme.of(context).colorScheme.surface : const Color(0xFFEFE8F4);
    final inactiveFg =
        isDark ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7) : const Color(0xFF625B6D);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF5B21B6) : inactiveBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              color: active ? Colors.white : inactiveFg,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;
  const _MiniTag({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark
        ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
        : const Color(0xFFE9DDFC);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Text(label,
          style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF9B7FE8),
              fontWeight: FontWeight.w700)),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _BottomNavItem(
      {required this.icon, required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark
        ? Theme.of(context).colorScheme.onSurface
        : const Color(0xFF2D145F);
    final labelColor = isDark
        ? Theme.of(context).colorScheme.onSurface
        : const Color(0xFF2D145F);
    final activeBg = isDark
        ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
        : const Color(0xFFE9DDFC);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: active ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: labelColor)),
      ],
    );
  }
}
