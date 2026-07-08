import 'package:flutter/material.dart';

const _acidGreen = Color(0xFFD7FF00);
const _neonPurple = Color(0xFF8A18FF);
const _hotPink = Color(0xFFFF2F78);
const _surface = Color(0xFF090909);
const _surfaceSoft = Color(0xFF111111);
const _stroke = Color(0xFF242424);
const _muted = Color(0xFF9A9A9A);

enum MapaTab {
  all('TODOS'),
  events('EVENTOS'),
  battles('BATALHAS');

  const MapaTab(this.label);

  final String label;
}

enum MapaEventType {
  event(_neonPurple, Icons.local_activity_outlined),
  battle(_neonPurple, Icons.bolt_rounded),
  cypher(_acidGreen, Icons.graphic_eq_rounded),
  store(_acidGreen, Icons.shopping_bag_outlined),
  session(_hotPink, Icons.local_fire_department_rounded),
  party(_acidGreen, Icons.groups_2_outlined);

  const MapaEventType(this.color, this.icon);

  final Color color;
  final IconData icon;
}

class MapaPage extends StatefulWidget {
  const MapaPage({
    super.key,
    this.city,
    this.region,
    this.userLocation,
    this.events = const [],
    this.liveArea,
    this.selectedEvent,
  });

  final String? city;
  final String? region;
  final MapaUserLocationSlot? userLocation;
  final List<MapaEventSlot> events;
  final MapaLiveAreaSlot? liveArea;
  final MapaSelectedEventSlot? selectedEvent;

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  MapaTab _selectedTab = MapaTab.all;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Stack(
        children: [
          const Positioned.fill(child: _MapBackground()),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _MapaTopBar(),
                      const SizedBox(height: 22),
                      _LocationTitle(city: widget.city, region: widget.region),
                      const SizedBox(height: 36),
                      _MapaTabs(
                        selectedTab: _selectedTab,
                        onSelected: (tab) => setState(() => _selectedTab = tab),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.72,
                  child: _InteractiveMapLayer(
                    events: widget.events,
                    userLocation: widget.userLocation,
                    liveArea: widget.liveArea,
                    selectedEvent: widget.selectedEvent,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
            ],
          ),
        ],
      ),
    );
  }
}

class MapaUserLocationSlot {
  const MapaUserLocationSlot({this.position = const Offset(0.5, 0.56)});

  final Offset position;
}

class MapaEventSlot {
  const MapaEventSlot({
    this.position = const Offset(0.5, 0.5),
    this.type = MapaEventType.event,
    this.title,
    this.timeLabel,
    this.statusLabel,
  });

  final Offset position;
  final MapaEventType type;
  final String? title;
  final String? timeLabel;
  final String? statusLabel;
}

class MapaLiveAreaSlot {
  const MapaLiveAreaSlot({this.avatars = const [], this.liveCount});

  final List<ImageProvider> avatars;
  final int? liveCount;
}

class MapaSelectedEventSlot {
  const MapaSelectedEventSlot({
    this.image,
    this.status,
    this.title,
    this.tags = const [],
    this.distanceLabel,
    this.peopleCount,
  });

  final ImageProvider? image;
  final String? status;
  final String? title;
  final List<String> tags;
  final String? distanceLabel;
  final int? peopleCount;
}

class _MapaTopBar extends StatelessWidget {
  const _MapaTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TRAP\nMACHINE',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            height: 0.82,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const Spacer(),
        const Icon(Icons.search_rounded, color: Colors.white, size: 32),
        const SizedBox(width: 22),
        const _BellIcon(),
        const SizedBox(width: 22),
        const _ProfileIcon(),
      ],
    );
  }
}

class _LocationTitle extends StatelessWidget {
  const _LocationTitle({required this.city, required this.region});

  final String? city;
  final String? region;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _TextSlot(
              text: city,
              width: 116,
              height: 34,
              textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: _acidGreen,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.keyboard_arrow_down_rounded, color: _acidGreen, size: 28),
          ],
        ),
        const SizedBox(height: 10),
        _TextSlot(
          text: region,
          width: 92,
          height: 18,
          color: _muted,
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: _muted,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _MapaTabs extends StatelessWidget {
  const _MapaTabs({required this.selectedTab, required this.onSelected});

  final MapaTab selectedTab;
  final ValueChanged<MapaTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: MapaTab.values.map((tab) {
          final selected = selectedTab == tab;

          return Expanded(
            child: InkWell(
              onTap: () => onSelected(tab),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    tab.label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: selected ? _acidGreen : Colors.white70,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 18),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 3,
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

class _InteractiveMapLayer extends StatelessWidget {
  const _InteractiveMapLayer({
    required this.events,
    required this.userLocation,
    required this.liveArea,
    required this.selectedEvent,
  });

  final List<MapaEventSlot> events;
  final MapaUserLocationSlot? userLocation;
  final MapaLiveAreaSlot? liveArea;
  final MapaSelectedEventSlot? selectedEvent;

  static const _placeholderPositions = [
    Offset(0.18, 0.2),
    Offset(0.67, 0.12),
    Offset(0.22, 0.46),
    Offset(0.7, 0.53),
    Offset(0.16, 0.72),
    Offset(0.46, 0.64),
    Offset(0.64, 0.82),
  ];

  @override
  Widget build(BuildContext context) {
    final markerCount = events.isEmpty ? _placeholderPositions.length : events.length;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(child: CustomPaint(painter: _MapStreetPainter())),
        for (var index = 0; index < markerCount; index++)
          _PositionedFractional(
            position: events.isEmpty ? _placeholderPositions[index] : events[index].position,
            child: _MapMarker(slot: events.isEmpty ? null : events[index], index: index),
          ),
        _PositionedFractional(
          position: userLocation?.position ?? const Offset(0.5, 0.62),
          child: const _UserMarker(),
        ),
        Positioned(right: 16, top: 250, child: const _MapControls()),
        Positioned(left: 16, bottom: 138, child: _LiveAreaCard(slot: liveArea)),
        Positioned(
          left: 16,
          right: 16,
          bottom: 18,
          child: _SelectedEventCard(slot: selectedEvent),
        ),
      ],
    );
  }
}

class _PositionedFractional extends StatelessWidget {
  const _PositionedFractional({required this.position, required this.child});

  final Offset position;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Positioned(
          left: constraints.maxWidth * position.dx,
          top: constraints.maxHeight * position.dy,
          child: Transform.translate(offset: const Offset(-32, -32), child: child),
        );
      },
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.index, this.slot});

  final int index;
  final MapaEventSlot? slot;

  @override
  Widget build(BuildContext context) {
    final type = slot?.type ?? MapaEventType.values[index % MapaEventType.values.length];
    final color = type.color;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 74,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _PulseRing(color: color, size: 74, alpha: 0.12),
              _PulseRing(color: color, size: 58, alpha: 0.18),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.78),
                  border: Border.all(color: color, width: 3),
                  boxShadow: [
                    BoxShadow(color: color.withValues(alpha: 0.45), blurRadius: 18, spreadRadius: -5),
                  ],
                ),
                child: Icon(type.icon, color: color, size: 24),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        _MapCallout(slot: slot, color: color),
      ],
    );
  }
}

class _MapCallout extends StatelessWidget {
  const _MapCallout({required this.color, this.slot});

  final MapaEventSlot? slot;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 126,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.18), blurRadius: 16, spreadRadius: -8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _TextSlot(text: slot?.title, width: 86, height: 12, color: color),
          const SizedBox(height: 8),
          Row(
            children: [
              _TextSlot(text: slot?.timeLabel, width: 42, height: 9, color: _muted),
              const SizedBox(width: 8),
              _TextSlot(text: slot?.statusLabel, width: 34, height: 9, color: _muted),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserMarker extends StatelessWidget {
  const _UserMarker();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 88,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _PulseRing(color: _neonPurple, size: 88, alpha: 0.13),
          _PulseRing(color: _neonPurple, size: 60, alpha: 0.18),
          Transform.rotate(
            angle: -0.78,
            child: const Icon(Icons.navigation_rounded, color: _neonPurple, size: 52),
          ),
        ],
      ),
    );
  }
}

class _PulseRing extends StatelessWidget {
  const _PulseRing({required this.color, required this.size, required this.alpha});

  final Color color;
  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: alpha),
        border: Border.all(color: color.withValues(alpha: alpha + 0.1)),
      ),
    );
  }
}

class _MapControls extends StatelessWidget {
  const _MapControls();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MapControlButton(icon: Icons.my_location_rounded),
          _ControlDivider(),
          _MapControlButton(icon: Icons.add_rounded),
          _ControlDivider(),
          _MapControlButton(icon: Icons.remove_rounded),
          _ControlDivider(),
          _MapControlButton(icon: Icons.near_me_outlined),
        ],
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 58, height: 54, child: Icon(icon, color: Colors.white, size: 27));
  }
}

class _ControlDivider extends StatelessWidget {
  const _ControlDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: Colors.white.withValues(alpha: 0.1));
  }
}

class _LiveAreaCard extends StatelessWidget {
  const _LiveAreaCard({this.slot});

  final MapaLiveAreaSlot? slot;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'AO VIVO NA AREA',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
              const Spacer(),
              const _LiveDot(),
              const SizedBox(width: 8),
              _NumberSlot(value: slot?.liveCount, width: 30),
            ],
          ),
          const SizedBox(height: 12),
          _AvatarStack(avatars: slot?.avatars ?? const []),
        ],
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.avatars});

  final List<ImageProvider> avatars;

  @override
  Widget build(BuildContext context) {
    final count = avatars.isEmpty ? 5 : avatars.length.clamp(0, 5);

    return SizedBox(
      height: 34,
      child: Stack(
        children: [
          for (var index = 0; index < count; index++)
            Positioned(
              left: index * 28,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _surfaceSoft,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: ClipOval(
                  child: avatars.isEmpty
                      ? const Icon(Icons.person_outline_rounded, color: Color(0xFF3A3A3A), size: 20)
                      : Image(image: avatars[index], fit: BoxFit.cover),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SelectedEventCard extends StatelessWidget {
  const _SelectedEventCard({this.slot});

  final MapaSelectedEventSlot? slot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF151515).withValues(alpha: 0.94),
            Colors.black.withValues(alpha: 0.96),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        boxShadow: [BoxShadow(color: _neonPurple.withValues(alpha: 0.16), blurRadius: 18, spreadRadius: -10)],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 118,
            height: 86,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: slot?.image == null
                  ? const _EventImagePlaceholder()
                  : Image(image: slot!.image!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatusPill(text: slot?.status),
                const SizedBox(height: 10),
                _TextSlot(
                  text: slot?.title,
                  width: 190,
                  height: 20,
                  textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 9),
                _TagLine(tags: slot?.tags ?? const []),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: _neonPurple, size: 17),
                    const SizedBox(width: 6),
                    _TextSlot(text: slot?.distanceLabel, width: 88, height: 11, color: _muted),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Icon(Icons.groups_2_outlined, color: Colors.white70, size: 18),
                  const SizedBox(width: 5),
                  _NumberSlot(value: slot?.peopleCount, width: 34),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(color: _acidGreen, shape: BoxShape.circle),
                child: const Icon(Icons.chevron_right_rounded, color: Colors.black, size: 34),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      constraints: const BoxConstraints(minWidth: 84, maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _acidGreen),
        color: Colors.black.withValues(alpha: 0.36),
      ),
      child: _TextSlot(text: text, width: 90, height: 8, color: _acidGreen),
    );
  }
}

class _TagLine extends StatelessWidget {
  const _TagLine({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox(width: 150, height: 10, child: _SlotBlock());
    }

    return Text(
      tags.take(3).join('  •  '),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: _muted,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
    );
  }
}

class _BellIcon extends StatelessWidget {
  const _BellIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 32,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 30),
          Positioned(
            top: -1,
            right: -2,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(color: _neonPurple, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.2),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: const Icon(Icons.person_outline_rounded, color: Color(0xFF777777), size: 24),
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(color: _acidGreen, shape: BoxShape.circle),
    );
  }
}

class _NumberSlot extends StatelessWidget {
  const _NumberSlot({required this.value, required this.width});

  final int? value;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return SizedBox(width: width, height: 10, child: const _SlotBlock());
    }

    return Text(
      '$value',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.white70,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
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
      style: textStyle ??
          Theme.of(context).textTheme.bodyMedium?.copyWith(
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
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _EventImagePlaceholder extends StatelessWidget {
  const _EventImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _EventImagePainter(), child: const SizedBox.expand());
  }
}

class _MapBackground extends StatelessWidget {
  const _MapBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(-0.85, -0.2),
          radius: 1.25,
          colors: [
            _neonPurple.withValues(alpha: 0.12),
            const Color(0xFF050505),
            Colors.black,
          ],
        ),
      ),
      child: CustomPaint(painter: _HeaderLinePainter()),
    );
  }
}

class _HeaderLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;

    for (var i = -8; i < 24; i++) {
      final x = i * 38.0;
      canvas.drawLine(Offset(x, 0), Offset(x + 64, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapStreetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final street = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final minorStreet = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final coast = Paint()
      ..color = const Color(0xFF061015).withValues(alpha: 0.78)
      ..style = PaintingStyle.fill;

    final coastPath = Path()
      ..moveTo(size.width * 0.78, 0)
      ..quadraticBezierTo(size.width * 0.88, size.height * 0.28, size.width * 0.76, size.height * 0.52)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.7, size.width * 0.82, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(coastPath, coast);

    for (var i = 0; i < 22; i++) {
      final y = i * size.height / 21;
      canvas.drawLine(Offset(0, y), Offset(size.width * 0.82, y + ((i % 4) - 2) * 20), i.isEven ? street : minorStreet);
    }

    for (var i = 0; i < 18; i++) {
      final x = i * size.width / 17;
      canvas.drawLine(Offset(x, 0), Offset(x + ((i % 5) - 2) * 24, size.height), i.isEven ? minorStreet : street);
    }

    final greenDot = Paint()..color = _acidGreen.withValues(alpha: 0.85);
    for (final dot in const [Offset(0.06, 0.25), Offset(0.62, 0.26), Offset(0.35, 0.65), Offset(0.75, 0.73)]) {
      canvas.drawCircle(Offset(size.width * dot.dx, size.height * dot.dy), 4, greenDot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EventImagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFF111111);
    canvas.drawRect(Offset.zero & size, background);
    final purple = Paint()..color = _neonPurple.withValues(alpha: 0.36);
    final line = Paint()
      ..color = _neonPurple.withValues(alpha: 0.48)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = _neonPurple.withValues(alpha: 0.08));
    canvas.drawCircle(Offset(size.width * 0.24, size.height * 0.3), size.height * 0.32, purple);
    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.78), size.height * 0.44, purple);
    canvas.drawLine(Offset(size.width * 0.1, size.height * 0.8), Offset(size.width * 0.92, size.height * 0.18), line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
