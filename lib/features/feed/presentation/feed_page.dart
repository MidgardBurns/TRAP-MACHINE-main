import 'package:flutter/material.dart';

const _acidGreen = Color(0xFFD7FF00);
const _neonPurple = Color(0xFF8A18FF);
const _surface = Color(0xFF090909);
const _surfaceSoft = Color(0xFF111111);
const _stroke = Color(0xFF272727);
const _muted = Color(0xFF9A9A9A);

enum FeedTab {
  all('TODOS'),
  tracks('TRACKS'),
  events('EVENTOS');

  const FeedTab(this.label);

  final String label;
}

enum FeedPostType {
  event('EVENTO', Icons.confirmation_num_outlined),
  track('TRACK', Icons.graphic_eq_rounded);

  const FeedPostType(this.label, this.icon);

  final String label;
  final IconData icon;
}

class FeedPage extends StatefulWidget {
  const FeedPage({super.key, this.composer, this.posts = const []});

  final FeedComposerSlot? composer;
  final List<FeedPostSlot> posts;

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  FeedTab _selectedTab = FeedTab.all;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                const _FeedHeaderTexture(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FeedTopBar(),
                      const SizedBox(height: 42),
                      Text(
                        'FEED',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: _acidGreen,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0,
                            ),
                      ),
                      const SizedBox(height: 38),
                      _FeedTabs(
                        selectedTab: _selectedTab,
                        onSelected: (tab) => setState(() => _selectedTab = tab),
                      ),
                      const SizedBox(height: 24),
                      _ComposerCard(slot: widget.composer),
                      const SizedBox(height: 22),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            sliver: _PostList(posts: widget.posts),
          ),
        ],
      ),
    );
  }
}

class FeedComposerSlot {
  const FeedComposerSlot({this.avatar, this.placeholder});

  final ImageProvider? avatar;
  final String? placeholder;
}

class FeedPostSlot {
  const FeedPostSlot({
    this.type = FeedPostType.event,
    this.authorAvatar,
    this.authorHandle,
    this.authorRole,
    this.createdAt,
    this.verified = false,
    this.cover,
    this.title,
    this.subtitle,
    this.dateLabel,
    this.location,
    this.description,
    this.partnerIcon,
    this.likes,
    this.comments,
    this.shares,
    this.duration,
  });

  final FeedPostType type;
  final ImageProvider? authorAvatar;
  final String? authorHandle;
  final String? authorRole;
  final String? createdAt;
  final bool verified;
  final ImageProvider? cover;
  final String? title;
  final String? subtitle;
  final String? dateLabel;
  final String? location;
  final String? description;
  final IconData? partnerIcon;
  final int? likes;
  final int? comments;
  final int? shares;
  final String? duration;
}

class _FeedHeaderTexture extends StatelessWidget {
  const _FeedHeaderTexture();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      bottom: null,
      child: SizedBox(
        height: 360,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF121212),
                Colors.black.withValues(alpha: 0.92),
                Colors.black,
              ],
            ),
          ),
          child: CustomPaint(painter: _FeedTexturePainter()),
        ),
      ),
    );
  }
}

class _FeedTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..strokeWidth = 1;
    final softLinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.022)
      ..strokeWidth = 1;
    final purpleHaze = Paint()
      ..shader =
          RadialGradient(
            colors: [_neonPurple.withValues(alpha: 0.14), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.06, size.height * 0.72),
              radius: size.width * 0.66,
            ),
          );

    canvas.drawRect(Offset.zero & size, purpleHaze);

    for (var i = -8; i < 22; i++) {
      final x = i * 38.0;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + 56, size.height),
        i.isEven ? linePaint : softLinePaint,
      );
    }

    final fadePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, fadePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FeedTopBar extends StatelessWidget {
  const _FeedTopBar();

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
          const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 30,
          ),
          Positioned(
            top: -1,
            right: -2,
            child: Container(
              width: 12,
              height: 12,
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: const Icon(
        Icons.person_outline_rounded,
        color: Color(0xFF6D6D6D),
        size: 24,
      ),
    );
  }
}

class _FeedTabs extends StatelessWidget {
  const _FeedTabs({required this.selectedTab, required this.onSelected});

  final FeedTab selectedTab;
  final ValueChanged<FeedTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: FeedTab.values.map((tab) {
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
                      color: selected ? _acidGreen : _muted,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 18),
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

class _ComposerCard extends StatelessWidget {
  const _ComposerCard({this.slot});

  final FeedComposerSlot? slot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF171717).withValues(alpha: 0.92),
            _surface.withValues(alpha: 0.98),
            const Color(0xFF101010).withValues(alpha: 0.94),
          ],
        ),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: _neonPurple.withValues(alpha: 0.22),
            blurRadius: 18,
            spreadRadius: -11,
            offset: const Offset(-7, 0),
          ),
          BoxShadow(
            color: _acidGreen.withValues(alpha: 0.1),
            blurRadius: 14,
            spreadRadius: -13,
            offset: const Offset(9, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _CircleAvatarSlot(
            image: slot?.avatar,
            size: 58,
            borderColor: _acidGreen,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: _TextSlot(
              text: slot?.placeholder,
              width: 210,
              height: 16,
              color: _muted,
              textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: _muted,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostList extends StatelessWidget {
  const _PostList({required this.posts});

  final List<FeedPostSlot> posts;

  @override
  Widget build(BuildContext context) {
    final count = posts.isEmpty ? 3 : posts.length;

    return SliverList.separated(
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        return _PostCard(
          post: posts.isEmpty ? null : posts[index],
          index: index,
        );
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.index, this.post});

  final int index;
  final FeedPostSlot? post;

  @override
  Widget build(BuildContext context) {
    final type =
        post?.type ?? (index == 1 ? FeedPostType.track : FeedPostType.event);
    final isTrack = type == FeedPostType.track;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF151515).withValues(alpha: 0.96),
            _surface.withValues(alpha: 0.99),
            const Color(0xFF0D0D0D).withValues(alpha: 0.98),
          ],
        ),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: Colors.white.withValues(alpha: index.isEven ? 0.14 : 0.11),
        ),
        boxShadow: [
          BoxShadow(
            color: _neonPurple.withValues(alpha: index.isEven ? 0.22 : 0.16),
            blurRadius: 18,
            spreadRadius: -12,
            offset: const Offset(-8, -2),
          ),
          BoxShadow(
            color: (isTrack ? Colors.black : _acidGreen).withValues(
              alpha: isTrack ? 0.08 : 0.12,
            ),
            blurRadius: 16,
            spreadRadius: -13,
            offset: const Offset(9, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostHeader(post: post, type: type),
          const SizedBox(height: 22),
          if (isTrack) _TrackBody(post: post) else _EventBody(post: post),
          const SizedBox(height: 22),
          _PostActions(post: post),
        ],
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({required this.type, this.post});

  final FeedPostType type;
  final FeedPostSlot? post;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TypePill(type: type),
        const SizedBox(width: 16),
        _CircleAvatarSlot(image: post?.authorAvatar, size: 48),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: _TextSlot(
                      text: post?.authorHandle,
                      width: 132,
                      height: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (post?.verified == true)
                    const Icon(
                      Icons.verified_rounded,
                      color: _neonPurple,
                      size: 18,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: _TextSlot(
                      text: post?.authorRole,
                      width: 82,
                      height: 10,
                      color: _muted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _TextSlot(
                    text: post?.createdAt,
                    width: 24,
                    height: 10,
                    color: _muted,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 26),
      ],
    );
  }
}

class _EventBody extends StatelessWidget {
  const _EventBody({this.post});

  final FeedPostSlot? post;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 520;
        final cover = _CoverSlot(image: post?.cover, compact: !wide);
        final details = _PostDetails(post: post, showPartner: true);

        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [cover, const SizedBox(height: 16), details],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: constraints.maxWidth * 0.42, child: cover),
            const SizedBox(width: 20),
            Expanded(child: details),
          ],
        );
      },
    );
  }
}

class _TrackBody extends StatelessWidget {
  const _TrackBody({this.post});

  final FeedPostSlot? post;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 520;
        final cover = _CoverSlot(image: post?.cover, compact: !wide);
        final player = _TrackPlayer(post: post);

        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [cover, const SizedBox(height: 16), player],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: constraints.maxWidth * 0.32, child: cover),
            const SizedBox(width: 20),
            Expanded(child: player),
          ],
        );
      },
    );
  }
}

class _PostDetails extends StatelessWidget {
  const _PostDetails({required this.showPartner, this.post});

  final FeedPostSlot? post;
  final bool showPartner;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TextSlot(
                text: post?.title,
                width: 210,
                height: 18,
                textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 14),
              _IconTextSlot(
                icon: Icons.calendar_today_outlined,
                text: post?.dateLabel,
                width: 88,
              ),
              const SizedBox(height: 10),
              _IconTextSlot(
                icon: Icons.location_on_outlined,
                text: post?.location,
                width: 152,
              ),
              const SizedBox(height: 18),
              _TextSlot(
                text: post?.description,
                width: 230,
                height: 44,
                color: _muted,
                maxLines: 3,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _PartnerBadge(icon: post?.partnerIcon),
      ],
    );
  }
}

class _TrackPlayer extends StatelessWidget {
  const _TrackPlayer({this.post});

  final FeedPostSlot? post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TextSlot(
          text: post?.title,
          width: 150,
          height: 20,
          textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 12),
        _IconTextSlot(
          icon: Icons.music_note_rounded,
          text: post?.subtitle,
          width: 160,
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: _acidGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.black,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(child: SizedBox(height: 34, child: _WaveformSlot())),
            const SizedBox(width: 12),
            _TextSlot(
              text: post?.duration,
              width: 34,
              height: 12,
              color: _muted,
            ),
          ],
        ),
      ],
    );
  }
}

class _PostActions extends StatelessWidget {
  const _PostActions({this.post});

  final FeedPostSlot? post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionSlot(icon: Icons.favorite_border_rounded, value: post?.likes),
        const SizedBox(width: 42),
        _ActionSlot(
          icon: Icons.chat_bubble_outline_rounded,
          value: post?.comments,
        ),
        const SizedBox(width: 42),
        _ActionSlot(icon: Icons.reply_rounded, value: post?.shares),
        const Spacer(),
        const Icon(
          Icons.bookmark_border_rounded,
          color: Colors.white,
          size: 28,
        ),
      ],
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.type});

  final FeedPostType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      constraints: const BoxConstraints(minWidth: 64),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _neonPurple,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type.label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _CircleAvatarSlot extends StatelessWidget {
  const _CircleAvatarSlot({this.image, required this.size, this.borderColor});

  final ImageProvider? image;
  final double size;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? _stroke,
          width: borderColor == null ? 1 : 2,
        ),
      ),
      child: ClipOval(
        child: image == null
            ? const _AvatarPlaceholder()
            : Image(image: image!, fit: BoxFit.cover),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: _surfaceSoft,
      child: Icon(
        Icons.person_outline_rounded,
        color: Color(0xFF343434),
        size: 28,
      ),
    );
  }
}

class _CoverSlot extends StatelessWidget {
  const _CoverSlot({this.image, required this.compact});

  final ImageProvider? image;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: compact ? 1.85 : 1.72,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: image == null
            ? const _CoverPlaceholder()
            : Image(image: image!, fit: BoxFit.cover),
      ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CoverPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _PartnerBadge extends StatelessWidget {
  const _PartnerBadge({this.icon});

  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.36),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: _acidGreen),
      ),
      child: Icon(icon ?? Icons.groups_2_outlined, color: _acidGreen, size: 38),
    );
  }
}

class _IconTextSlot extends StatelessWidget {
  const _IconTextSlot({
    required this.icon,
    required this.text,
    required this.width,
  });

  final IconData icon;
  final String? text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _acidGreen, size: 17),
        const SizedBox(width: 8),
        Expanded(
          child: _TextSlot(text: text, width: width, height: 13, color: _muted),
        ),
      ],
    );
  }
}

class _ActionSlot extends StatelessWidget {
  const _ActionSlot({required this.icon, this.value});

  final IconData icon;
  final int? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 27),
        const SizedBox(width: 10),
        if (value == null)
          const SizedBox(width: 28, height: 11, child: _SlotBlock())
        else
          Text(
            '$value',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: _muted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
      ],
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
    this.maxLines = 1,
  });

  final String? text;
  final double width;
  final double height;
  final Color color;
  final TextStyle? textStyle;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final value = text;

    if (value == null || value.isEmpty) {
      return SizedBox(width: width, height: height, child: const _SlotBlock());
    }

    return Text(
      value,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style:
          textStyle ??
          Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
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

class _WaveformSlot extends StatelessWidget {
  const _WaveformSlot();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _WaveformPainter());
  }
}

class _WaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.82)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 58; i++) {
      final x = i * (size.width / 58);
      final barHeight = 6 + ((i * 11) % 24);
      final y = size.height / 2;
      canvas.drawLine(
        Offset(x, y - barHeight / 2),
        Offset(x, y + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CoverPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFF111111);
    canvas.drawRect(Offset.zero & size, background);

    final purpleFill = Paint()..color = _neonPurple.withValues(alpha: 0.17);
    final purpleLine = Paint()
      ..color = _neonPurple.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final greenLine = Paint()
      ..color = _acidGreen.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 22), purpleFill);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.12, 8, size.width * 0.28, 6),
        const Radius.circular(2),
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.35),
    );
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.36),
      Offset(size.width * 0.7, size.height * 0.84),
      purpleLine,
    );
    canvas.drawLine(
      Offset(size.width * 0.86, size.height * 0.24),
      Offset(size.width * 0.52, size.height * 0.88),
      greenLine,
    );
    canvas.drawCircle(
      Offset(size.width * 0.46, size.height * 0.7),
      size.height * 0.28,
      purpleLine,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
