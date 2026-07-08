import 'package:flutter/material.dart';

const _acidGreen = Color(0xFFD7FF00);
const _neonPurple = Color(0xFF9B35FF);
const _surface = Color(0xFF090909);
const _surfaceSoft = Color(0xFF111111);
const _stroke = Color(0xFF242424);
const _muted = Color(0xFF8A8A8A);

enum InboxTab {
  all('TODAS'),
  messages('MENSAGENS');

  const InboxTab(this.label);

  final String label;
}

class InboxPage extends StatefulWidget {
  const InboxPage({
    super.key,
    this.spotlightSlots = const [],
    this.messageSlots = const [],
    this.notificationSlots = const [],
  });

  final List<InboxSpotlightSlot> spotlightSlots;
  final List<InboxMessageSlot> messageSlots;
  final List<InboxNotificationSlot> notificationSlots;

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  InboxTab _selectedTab = InboxTab.all;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                const _InboxHeaderTexture(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _InboxTopBar(),
                      const SizedBox(height: 12),
                      Text(
                        'INBOX',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: _acidGreen,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _InboxTabs(
                        selectedTab: _selectedTab,
                        onSelected: (tab) => setState(() => _selectedTab = tab),
                      ),
                      const SizedBox(height: 18),
                      _SpotlightRail(slots: widget.spotlightSlots),
                      const SizedBox(height: 16),
                      const _SectionHeader(title: 'MENSAGENS'),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: _MessageList(slots: widget.messageSlots),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  const _SectionHeader(title: 'NOTIFICACOES'),
                  const SizedBox(height: 8),
                  _NotificationList(slots: widget.notificationSlots),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 18)),
        ],
      ),
    );
  }
}

class InboxSpotlightSlot {
  const InboxSpotlightSlot({
    this.image,
    this.title,
    this.subtitle,
    this.badgeCount,
  });

  final ImageProvider? image;
  final String? title;
  final String? subtitle;
  final int? badgeCount;
}

class InboxMessageSlot {
  const InboxMessageSlot({
    this.image,
    this.name,
    this.preview,
    this.unreadCount,
    this.trailing,
  });

  final ImageProvider? image;
  final String? name;
  final String? preview;
  final int? unreadCount;
  final String? trailing;
}

class InboxNotificationSlot {
  const InboxNotificationSlot({
    this.icon,
    this.title,
    this.subtitle,
    this.trailing,
    this.isAlert = false,
  });

  final IconData? icon;
  final String? title;
  final String? subtitle;
  final String? trailing;
  final bool isAlert;
}

class _InboxHeaderTexture extends StatelessWidget {
  const _InboxHeaderTexture();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      bottom: null,
      child: SizedBox(
        height: 250,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.black.withValues(alpha: 0.28),
                Colors.black,
              ],
            ),
          ),
          child: CustomPaint(painter: _InboxTexturePainter()),
        ),
      ),
    );
  }
}

class _InboxTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..strokeWidth = 1;
    final softLinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.025)
      ..strokeWidth = 1;
    final hazePaint = Paint()
      ..shader =
          RadialGradient(
            colors: [_neonPurple.withValues(alpha: 0.12), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.16, size.height * 0.28),
              radius: size.width * 0.62,
            ),
          );

    canvas.drawRect(Offset.zero & size, hazePaint);

    for (var i = -7; i < 18; i++) {
      final x = i * 34.0;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + 48, size.height),
        i.isEven ? linePaint : softLinePaint,
      );
    }

    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.72)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InboxTopBar extends StatelessWidget {
  const _InboxTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'TRAP\nMACHINE',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            height: 0.82,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const Spacer(),
        const Icon(Icons.search_rounded, color: Colors.white, size: 23),
        const SizedBox(width: 17),
        const _BellIcon(),
        const SizedBox(width: 17),
        const _MiniAvatar(),
      ],
    );
  }
}

class _BellIcon extends StatelessWidget {
  const _BellIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 23,
          ),
          Positioned(
            top: 3,
            right: 3,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: _neonPurple,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  const _MiniAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _surfaceSoft,
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        color: Color(0xFF555555),
        size: 18,
      ),
    );
  }
}

class _InboxTabs extends StatelessWidget {
  const _InboxTabs({required this.selectedTab, required this.onSelected});

  final InboxTab selectedTab;
  final ValueChanged<InboxTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        children: InboxTab.values.map((tab) {
          final selected = selectedTab == tab;

          return Expanded(
            child: InkWell(
              onTap: () => onSelected(tab),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    tab.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected ? _acidGreen : _muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 2,
                    color: selected ? _acidGreen : _stroke,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SpotlightRail extends StatelessWidget {
  const _SpotlightRail({required this.slots});

  final List<InboxSpotlightSlot> slots;

  @override
  Widget build(BuildContext context) {
    final count = slots.isEmpty ? 4 : slots.length;

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          return _SpotlightCard(slot: slots.isEmpty ? null : slots[index]);
        },
      ),
    );
  }
}

class _SpotlightCard extends StatelessWidget {
  const _SpotlightCard({this.slot});

  final InboxSpotlightSlot? slot;

  @override
  Widget build(BuildContext context) {
    final image = slot?.image;

    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 58,
                height: 58,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _acidGreen, width: 2),
                ),
                child: ClipOval(
                  child: image == null
                      ? const _AvatarPlaceholder(icon: Icons.graphic_eq_rounded)
                      : Image(image: image, fit: BoxFit.cover),
                ),
              ),
              if (slot?.badgeCount != null)
                Positioned(
                  right: -1,
                  top: 0,
                  child: _CountBadge(count: slot!.badgeCount!),
                ),
            ],
          ),
          const SizedBox(height: 7),
          _TextSlot(text: slot?.title, width: 58, height: 9, color: _acidGreen),
          const SizedBox(height: 4),
          _TextSlot(text: slot?.subtitle, width: 46, height: 7, color: _muted),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const Spacer(),
        Text(
          'VER TODAS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: _acidGreen,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({required this.slots});

  final List<InboxMessageSlot> slots;

  @override
  Widget build(BuildContext context) {
    final count = slots.isEmpty ? 5 : slots.length;

    return SliverList.separated(
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 7),
      itemBuilder: (context, index) {
        return _MessageCard(slot: slots.isEmpty ? null : slots[index]);
      },
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({this.slot});

  final InboxMessageSlot? slot;

  @override
  Widget build(BuildContext context) {
    final image = slot?.image;

    return Container(
      height: 58,
      padding: const EdgeInsets.fromLTRB(10, 7, 6, 7),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: _stroke),
      ),
      child: Row(
        children: [
          ClipOval(
            child: SizedBox.square(
              dimension: 40,
              child: image == null
                  ? const _AvatarPlaceholder(icon: Icons.person_outline_rounded)
                  : Image(image: image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: _TextSlot(
                        text: slot?.name,
                        width: 102,
                        height: 10,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (slot?.unreadCount != null)
                      const _Dot(color: _neonPurple),
                  ],
                ),
                const SizedBox(height: 7),
                _TextSlot(
                  text: slot?.preview,
                  width: 168,
                  height: 8,
                  color: _muted,
                ),
              ],
            ),
          ),
          if (slot?.unreadCount != null) ...[
            _CountBadge(count: slot!.unreadCount!),
            const SizedBox(width: 9),
          ],
          _TextSlot(text: slot?.trailing, width: 18, height: 7, color: _muted),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF4E4E4E),
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({required this.slots});

  final List<InboxNotificationSlot> slots;

  @override
  Widget build(BuildContext context) {
    final count = slots.isEmpty ? 4 : slots.length;

    return Column(
      children: List.generate(count, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index == count - 1 ? 0 : 10),
          child: _NotificationRow(slot: slots.isEmpty ? null : slots[index]),
        );
      }),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({this.slot});

  final InboxNotificationSlot? slot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: slot?.isAlert == true ? _neonPurple : Colors.black,
              border: Border.all(
                color: slot?.isAlert == true ? _neonPurple : _stroke,
              ),
            ),
            child: Icon(
              slot?.icon ?? Icons.person_outline_rounded,
              color: slot?.isAlert == true ? Colors.black : _muted,
              size: 15,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TextSlot(text: slot?.title, width: 174, height: 9),
                const SizedBox(height: 7),
                _TextSlot(
                  text: slot?.subtitle,
                  width: 210,
                  height: 7,
                  color: _muted,
                ),
              ],
            ),
          ),
          _TextSlot(text: slot?.trailing, width: 24, height: 7, color: _muted),
        ],
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _surfaceSoft,
      child: Center(
        child: Icon(icon, color: const Color(0xFF323232), size: 24),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 17),
      height: 17,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: _acidGreen,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.black,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _TextSlot extends StatelessWidget {
  const _TextSlot({
    required this.text,
    required this.width,
    required this.height,
    this.color = Colors.white,
  });

  final String? text;
  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final value = text;

    if (value == null || value.isEmpty) {
      return SizedBox(width: width, height: height, child: const _SlotBlock());
    }

    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
    );
  }
}

class _SlotBlock extends StatelessWidget {
  const _SlotBlock();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
