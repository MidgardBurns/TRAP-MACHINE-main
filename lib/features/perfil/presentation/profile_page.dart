import 'package:flutter/material.dart';

const _acidGreen = Color(0xFFD7FF00);
const _neonPurple = Color(0xFF9B35FF);
const _surface = Color(0xFF090909);
const _stroke = Color(0xFF2A2A2A);
const _muted = Color(0xFF8A8A8A);

enum ProfileContentTab {
  all('ALL'),
  tracks('TRACKS'),
  events('EVENTOS'),
  visuals('VISUAIS'),
  tokens('TOKENS');

  const ProfileContentTab(this.label);

  final String label;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    this.artistName,
    this.handle,
    this.location,
    this.role,
    this.tags = const [],
    this.metrics = const [],
    this.tokens = const [],
    this.contentSlots = const [],
  });

  final String? artistName;
  final String? handle;
  final String? location;
  final String? role;
  final List<String> tags;
  final List<ProfileMetric> metrics;
  final List<ProfileToken> tokens;
  final List<ProfileContentSlot> contentSlots;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileContentTab _selectedTab = ProfileContentTab.all;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                const _HeaderTexture(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ProfileTopBar(),
                      const SizedBox(height: 10),
                      _ProfileHero(
                        artistName: widget.artistName,
                        handle: widget.handle,
                        location: widget.location,
                        role: widget.role,
                        tags: widget.tags,
                      ),
                      const SizedBox(height: 18),
                      _SectionTitle(
                        title: 'TOKENS',
                        action: widget.tokens.isEmpty ? null : 'VER TODOS',
                      ),
                      const SizedBox(height: 8),
                      _TokenRail(tokens: widget.tokens),
                      const SizedBox(height: 14),
                      _MetricStrip(metrics: widget.metrics),
                      const SizedBox(height: 16),
                      _ProfileTabs(
                        selectedTab: _selectedTab,
                        onSelected: (tab) => setState(() {
                          _selectedTab = tab;
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(6, 12, 6, 18),
            sliver: _ContentGrid(slots: widget.contentSlots),
          ),
        ],
      ),
    );
  }
}

class ProfileMetric {
  const ProfileMetric({required this.label, required this.icon, this.value});

  final String label;
  final IconData icon;
  final int? value;
}

class ProfileToken {
  const ProfileToken({this.image, this.title, this.subtitle});

  final ImageProvider? image;
  final String? title;
  final String? subtitle;
}

class ProfileContentSlot {
  const ProfileContentSlot({
    this.cover,
    this.type,
    this.title,
    this.subtitle,
    this.metricA,
    this.metricB,
  });

  final ImageProvider? cover;
  final String? type;
  final String? title;
  final String? subtitle;
  final String? metricA;
  final String? metricB;
}

class _HeaderTexture extends StatelessWidget {
  const _HeaderTexture();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      bottom: null,
      child: SizedBox(
        height: 230,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.black.withValues(alpha: 0.18),
                Colors.black,
              ],
            ),
          ),
          child: CustomPaint(painter: _NoiseLinesPainter()),
        ),
      ),
    );
  }
}

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar();

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
        const _TopIcon(Icons.notifications_none_rounded, hasBadge: true),
        const SizedBox(width: 18),
        const _TopIcon(Icons.person_add_alt_1_rounded),
        const SizedBox(width: 18),
        const _TopIcon(Icons.menu_rounded),
      ],
    );
  }
}

class _TopIcon extends StatelessWidget {
  const _TopIcon(this.icon, {this.hasBadge = false});

  final IconData icon;
  final bool hasBadge;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          if (hasBadge)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 6,
                height: 6,
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

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.artistName,
    required this.handle,
    required this.location,
    required this.role,
    required this.tags,
  });

  final String? artistName;
  final String? handle;
  final String? location;
  final String? role;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const _AvatarSlot(),
        const SizedBox(width: 18),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TextSlot(
                  text: role,
                  width: 56,
                  height: 18,
                  color: _neonPurple,
                  textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 6),
                _TextSlot(
                  text: artistName,
                  width: 176,
                  height: 30,
                  textStyle: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      ),
                ),
                const SizedBox(height: 5),
                _TextSlot(
                  text: handle,
                  width: 94,
                  height: 17,
                  color: _neonPurple,
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _neonPurple,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: _acidGreen,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _TextSlot(
                        text: location,
                        width: 132,
                        height: 14,
                        color: _acidGreen,
                        textStyle: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(
                              color: _acidGreen,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _TagRow(tags: tags),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarSlot extends StatelessWidget {
  const _AvatarSlot();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 114,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _RingPainter())),
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF121212),
                border: Border.all(color: const Color(0xFF4C4C4C)),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF343434),
                size: 52,
              ),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 12,
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: _neonPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.black,
                size: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  const _TagRow({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final effectiveTags = tags.take(3).toList();

    return Row(
      children: [
        if (effectiveTags.isEmpty)
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(right: index == 2 ? 0 : 6),
              child: const _ChipSlot(),
            ),
          )
        else
          ...effectiveTags.map(
            (tag) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _ChipSlot(label: tag),
            ),
          ),
        SizedBox(
          width: 24,
          height: 24,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              side: const BorderSide(color: Colors.white54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _ChipSlot extends StatelessWidget {
  const _ChipSlot({this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final text = label;

    return Container(
      height: 24,
      constraints: const BoxConstraints(minWidth: 44, maxWidth: 92),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: text == null ? _stroke : _neonPurple),
        color: Colors.black.withValues(alpha: 0.45),
      ),
      child: text == null
          ? const SizedBox(width: 28, height: 7, child: _SlotBlock())
          : Text(
              text.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.action});

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title >',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
          ),
        ),
        const Spacer(),
        if (action != null)
          Text(
            action!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _muted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
      ],
    );
  }
}

class _TokenRail extends StatelessWidget {
  const _TokenRail({required this.tokens});

  final List<ProfileToken> tokens;

  @override
  Widget build(BuildContext context) {
    final count = tokens.isEmpty ? 4 : tokens.length;

    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          return _TokenCard(token: tokens.isEmpty ? null : tokens[index]);
        },
      ),
    );
  }
}

class _TokenCard extends StatelessWidget {
  const _TokenCard({this.token});

  final ProfileToken? token;

  @override
  Widget build(BuildContext context) {
    final image = token?.image;
    final title = token?.title;
    final subtitle = token?.subtitle;

    return Container(
      width: 82,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: _stroke),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: image == null
                  ? const ColoredBox(
                      color: Color(0xFF151515),
                      child: Center(
                        child: Icon(
                          Icons.token_rounded,
                          color: Color(0xFF242424),
                          size: 28,
                        ),
                      ),
                    )
                  : Image(image: image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 5),
          _TextSlot(text: title, width: 56, height: 8, color: _acidGreen),
          const SizedBox(height: 3),
          _TextSlot(text: subtitle, width: 38, height: 7, color: _neonPurple),
        ],
      ),
    );
  }
}

class _MetricStrip extends StatelessWidget {
  const _MetricStrip({required this.metrics});

  final List<ProfileMetric> metrics;

  @override
  Widget build(BuildContext context) {
    final items = metrics.isEmpty
        ? const [
            ProfileMetric(
              label: 'EVENTOS',
              icon: Icons.confirmation_num_outlined,
            ),
            ProfileMetric(label: 'TRACKS', icon: Icons.graphic_eq_rounded),
            ProfileMetric(label: 'COLLABS', icon: Icons.groups_2_outlined),
            ProfileMetric(label: 'COLETIVOS', icon: Icons.flag_outlined),
          ]
        : metrics.take(4).toList();

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFF171717)),
      ),
      child: Row(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            Expanded(child: _MetricItem(metric: items[index])),
            if (index != items.length - 1)
              Container(width: 1, height: 28, color: _stroke),
          ],
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({required this.metric});

  final ProfileMetric metric;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(metric.icon, color: _acidGreen, size: 19),
        const SizedBox(width: 7),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (metric.value == null)
              const SizedBox(width: 18, height: 10, child: _SlotBlock())
            else
              Text(
                '${metric.value}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
            Text(
              metric.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white70,
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileTabs extends StatelessWidget {
  const _ProfileTabs({required this.selectedTab, required this.onSelected});

  final ProfileContentTab selectedTab;
  final ValueChanged<ProfileContentTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Row(
        children: [
          for (final tab in ProfileContentTab.values)
            Expanded(
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
                        color: selectedTab == tab ? _acidGreen : Colors.white70,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 9),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      height: 2,
                      color: selectedTab == tab
                          ? _acidGreen
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ContentGrid extends StatelessWidget {
  const _ContentGrid({required this.slots});

  final List<ProfileContentSlot> slots;

  @override
  Widget build(BuildContext context) {
    final count = slots.isEmpty ? 9 : slots.length;

    return SliverGrid.builder(
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.66,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        return _ContentCard(slot: slots.isEmpty ? null : slots[index]);
      },
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({this.slot});

  final ProfileContentSlot? slot;

  @override
  Widget build(BuildContext context) {
    final cover = slot?.cover;

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFF404040)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: cover == null
                ? const _CardSlotBackground()
                : Image(image: cover, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.28),
                    Colors.black.withValues(alpha: 0.86),
                  ],
                ),
              ),
            ),
          ),
          Positioned(left: 7, top: 7, child: _TypeBadge(label: slot?.type)),
          Positioned(
            left: 7,
            right: 7,
            bottom: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TextSlot(
                  text: slot?.title,
                  width: 62,
                  height: 10,
                  textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 4),
                _TextSlot(
                  text: slot?.subtitle,
                  width: 78,
                  height: 7,
                  color: Colors.white54,
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_fill_rounded,
                      color: _acidGreen,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    const Expanded(
                      child: SizedBox(height: 12, child: _WaveSlot()),
                    ),
                    const SizedBox(width: 5),
                    _TextSlot(
                      text: slot?.metricA,
                      width: 20,
                      height: 7,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: Icon(
              Icons.more_vert_rounded,
              color: Colors.white.withValues(alpha: 0.55),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17,
      constraints: const BoxConstraints(minWidth: 28, maxWidth: 66),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: label == null ? _neonPurple.withValues(alpha: 0.7) : _acidGreen,
        borderRadius: BorderRadius.circular(2),
      ),
      child: label == null
          ? const SizedBox(width: 18, height: 5, child: _SlotBlock(dark: true))
          : Text(
              label!.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.black,
                fontSize: 7,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
    );
  }
}

class _TextSlot extends StatelessWidget {
  const _TextSlot({
    required this.text,
    required this.width,
    required this.height,
    this.color = Colors.white,
    this.textStyle,
  });

  final String? text;
  final double width;
  final double height;
  final Color color;
  final TextStyle? textStyle;

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
      style:
          textStyle ??
          Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
    );
  }
}

class _SlotBlock extends StatelessWidget {
  const _SlotBlock({this.dark = false});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: dark
            ? Colors.black.withValues(alpha: 0.35)
            : Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _WaveSlot extends StatelessWidget {
  const _WaveSlot();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _WavePainter());
  }
}

class _CardSlotBackground extends StatelessWidget {
  const _CardSlotBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CardPainter(), child: const SizedBox.expand());
  }
}

class _NoiseLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1;

    for (var i = 0; i < 18; i++) {
      final x = (i * 29) % size.width;
      canvas.drawLine(
        Offset(x.toDouble(), 0),
        Offset((x + 36).toDouble(), size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 6;
    final base = Paint()
      ..color = const Color(0xFF292929)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final accent = Paint()
      ..color = _neonPurple
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius, base);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -2.6,
      4.5,
      false,
      accent,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 5),
      1.2,
      1.7,
      false,
      accent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.62)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 21; i++) {
      final x = i * (size.width / 21);
      final height = 3 + ((i * 7) % 10);
      final centerY = size.height / 2;
      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFF141414);
    canvas.drawRect(Offset.zero & size, background);

    final purple = Paint()
      ..color = _neonPurple.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final green = Paint()
      ..color = _acidGreen.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.22),
      Offset(size.width * 0.88, size.height * 0.62),
      purple,
    );
    canvas.drawLine(
      Offset(size.width * 0.82, size.height * 0.16),
      Offset(size.width * 0.2, size.height * 0.86),
      green,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.38),
      size.width * 0.18,
      purple,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
