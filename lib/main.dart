import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bernadeth Soriano',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2B7FFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Georgia',
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _landingKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  late AnimationController _heroController;
  late AnimationController _orbitController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  int _activeSection = 0;

  // Strict blue-black palette
  static const Color black = Color(0xFF000000);
  static const Color surface = Color(0xFF0A0A0F);
  static const Color surfaceCard = Color(0xFF0F0F18);
  static const Color border = Color(0xFF1A1A2E);
  static const Color borderBright = Color(0xFF252545);
  static const Color blue = Color(0xFF2B7FFF);
  static const Color blueLight = Color(0xFF6AAEFF);
  static const Color blueDim = Color(0xFF1A4D99);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textMid = Color(0xFF8888AA);
  static const Color textDim = Color(0xFF444466);

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOut),
    );
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _heroController, curve: Curves.easeOut));

    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _orbitController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key, int index) {
    setState(() => _activeSection = index);
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          // Subtle ambient background
          AnimatedBuilder(
            animation: _orbitController,
            builder: (_, __) => CustomPaint(
              painter: AmbientPainter(_orbitController.value),
              size: Size.infinite,
            ),
          ),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildNav(isMobile),
                _buildHero(isMobile),
                _buildAbout(isMobile),
                _buildJourney(isMobile),
                _buildContact(isMobile),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── NAV ──────────────────────────────────────────────────────

  Widget _buildNav(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 64, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xCC000000),
        border: Border(bottom: BorderSide(color: border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Wordmark
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 17, letterSpacing: 0.5),
              children: [
                TextSpan(
                  text: 'Bernadeth ',
                  style: TextStyle(color: white, fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: 'Soriano',
                  style: TextStyle(color: blue, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          if (!isMobile)
            Row(children: [
              _navLink('Home', 0, _landingKey),
              _navLink('About', 1, _aboutKey),
              _navLink('Journey', 2, _experienceKey),
              _navLink('Contact', 3, _contactKey),
            ]),
          GestureDetector(
            onTap: () => _scrollToSection(_contactKey, 3),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: blue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Contact Me',
                style: TextStyle(
                  color: white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navLink(String label, int index, GlobalKey key) {
    final active = _activeSection == index;
    return GestureDetector(
      onTap: () => _scrollToSection(key, index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          label,
          style: TextStyle(
            color: active ? blue : textMid,
            fontSize: 14,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  // ── HERO ──────────────────────────────────────────────────────

  Widget _buildHero(bool isMobile) {
    return Container(
      key: _landingKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 96,
        vertical: isMobile ? 72 : 110,
      ),
      child: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideIn,
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _heroContent(isMobile),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _heroContent(isMobile),
                      ),
                    ),
                    const SizedBox(width: 72),
                    _avatarCard(),
                  ],
                ),
        ),
      ),
    );
  }

  List<Widget> _heroContent(bool isMobile) {
    return [
      // Status badge
      Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: blue.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00E676),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Available for opportunities',
              style: TextStyle(
                  color: blueLight, fontSize: 12, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
      const SizedBox(height: 32),
      Text(
        'Bernadeth\nSoriano',
        style: TextStyle(
          color: white,
          fontSize: isMobile ? 48 : 72,
          fontWeight: FontWeight.w800,
          height: 1.0,
          letterSpacing: -2,
        ),
      ),
      const SizedBox(height: 18),
      Text(
        'IT Student  ·  Capstone Developer  ·  Future Network Engineer',
        style: TextStyle(
          color: blue,
          fontSize: isMobile ? 13 : 15,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 24),
      SizedBox(
        width: 520,
        child: Text(
          'A 3rd-year BS Information Technology student at STI-San Jose Del Monte, Bulacan. Passionate about solving problems, writing clean code, and building toward a career in network engineering.',
          style: TextStyle(
            color: textMid,
            fontSize: isMobile ? 14 : 16,
            height: 1.8,
          ),
        ),
      ),
      const SizedBox(height: 44),
      Wrap(
        spacing: 14,
        runSpacing: 14,
        children: [
          _btn('View Journey', true,
              () => _scrollToSection(_experienceKey, 2)),
          _btn('Get In Touch', false,
              () => _scrollToSection(_contactKey, 3)),
        ],
      ),
      const SizedBox(height: 60),
      // Stat strip
      Wrap(
        spacing: 48,
        runSpacing: 20,
        children: [
          _statItem('BSIT', 'Degree'),
          _statItem('3rd Year', 'Level'),
          _statItem('Aug 2024', 'Enrolled'),
          _statItem('7+', 'Technologies'),
        ],
      ),
    ];
  }

  Widget _btn(String label, bool primary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: primary ? blue : Colors.transparent,
          border: Border.all(
              color: primary ? blue : borderBright, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: primary ? white : textMid,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  Widget _statItem(String val, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val,
            style: const TextStyle(
                color: white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5)),
        const SizedBox(height: 3),
        Text(label,
            style: const TextStyle(
                color: textDim, fontSize: 12, letterSpacing: 0.8)),
      ],
    );
  }

  Widget _avatarCard() {
    return Container(
      width: 300,
      height: 360,
      decoration: BoxDecoration(
        color: surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1),
      ),
      child: Stack(
        children: [
          // Blue glow top-right
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    blue.withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar circle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: blue.withOpacity(0.12),
                    border: Border.all(color: blue, width: 1.5),
                  ),
                  child: const Center(
                    child: Text(
                      'BS',
                      style: TextStyle(
                        color: blue,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Bernadeth Soriano',
                  style: TextStyle(
                    color: white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'STI-SJDM · BSIT',
                  style: TextStyle(color: textMid, fontSize: 13),
                ),
                const SizedBox(height: 24),
                // Divider
                Container(height: 1, color: border),
                const SizedBox(height: 20),
                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Java', 'Python', 'Flutter', 'C#', 'MySQL']
                      .map((s) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: blue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: blue.withOpacity(0.25)),
                            ),
                            child: Text(s,
                                style: const TextStyle(
                                    color: blueLight,
                                    fontSize: 11,
                                    letterSpacing: 0.3)),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── ABOUT ──────────────────────────────────────────────────────

  Widget _buildAbout(bool isMobile) {
    return Container(
      key: _aboutKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 96, vertical: 88),
      decoration: const BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTag('ABOUT'),
          const SizedBox(height: 14),
          Text(
            'About Me',
            style: TextStyle(
              color: white,
              fontSize: isMobile ? 34 : 48,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 52),
          isMobile
              ? Column(children: [
                  _aboutBody(),
                  const SizedBox(height: 40),
                  _skillsPanel(),
                ])
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _aboutBody()),
                    const SizedBox(width: 64),
                    Expanded(flex: 2, child: _skillsPanel()),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _aboutBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "I'm Bernadeth Soriano, an Information Technology student and the programmer of our capstone project. I enjoy learning new technologies and solving real-world problems through code.",
          style: TextStyle(color: textMid, fontSize: 16, height: 1.85),
        ),
        const SizedBox(height: 18),
        const Text(
          "Working on our capstone has built my confidence and sharpened my development skills. I'm motivated every day to improve and work toward my dream of becoming a network engineer.",
          style: TextStyle(color: textMid, fontSize: 16, height: 1.85),
        ),
        const SizedBox(height: 36),
        _infoLine(Icons.school_outlined, 'STI - San Jose Del Monte, Bulacan'),
        _infoLine(Icons.badge_outlined, '3rd Year BSIT · Enrolled Aug 2024'),
        _infoLine(Icons.terminal_outlined, 'Java · Python · C# · Flutter · MySQL · MongoDB'),
        _infoLine(Icons.wifi_outlined, 'Aspiring Network Engineer'),
      ],
    );
  }

  Widget _infoLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: blue, size: 17),
          const SizedBox(width: 13),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: white, fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _skillsPanel() {
    final skills = [
      {'n': 'Java', 'v': 0.65},
      {'n': 'Python', 'v': 0.60},
      {'n': 'HTML & CSS', 'v': 0.60},
      {'n': 'C#', 'v': 0.55},
      {'n': 'MySQL / MongoDB', 'v': 0.55},
      {'n': 'Flutter / Dart', 'v': 0.40},
    ];

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skills',
            style: TextStyle(
                color: white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5),
          ),
          const SizedBox(height: 26),
          ...skills.map((s) => _bar(s['n'] as String, s['v'] as double)),
        ],
      ),
    );
  }

  Widget _bar(String name, double level) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: const TextStyle(
                      color: textMid, fontSize: 13)),
              Text('${(level * 100).toInt()}%',
                  style: const TextStyle(
                      color: blue, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Stack(
              children: [
                Container(height: 3, color: border),
                FractionallySizedBox(
                  widthFactor: level,
                  child: Container(
                    height: 3,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [blueDim, blue],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── JOURNEY ──────────────────────────────────────────────────────

  Widget _buildJourney(bool isMobile) {
    return Container(
      key: _experienceKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 96, vertical: 88),
      decoration: const BoxDecoration(
        color: black,
        border: Border(top: BorderSide(color: border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTag('JOURNEY'),
          const SizedBox(height: 14),
          Text(
            'Academic & Project Milestones',
            style: TextStyle(
              color: white,
              fontSize: isMobile ? 34 : 48,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 52),
          _timelineCard(
            title: 'BS Information Technology',
            org: 'STI - San Jose Del Monte, Bulacan',
            period: 'Aug 2024 – Present',
            body:
                'Currently a 3rd-year BSIT student. Core subjects include Java programming, data structures, database systems, networking fundamentals, and software engineering.',
            isLast: false,
          ),
          _timelineCard(
            title: 'Capstone Project Lead Developer',
            org: 'STI-SJDM · Academic Project',
            period: '2025 – Present',
            body:
                'Serving as the main programmer for our capstone project. Responsible for full system design, development, and implementation using modern development tools and methodologies.',
            isLast: false,
          ),
          _timelineCard(
            title: 'Flutter & Dart Self-Study',
            org: 'Independent Learning',
            period: 'Present',
            body:
                'Self-studying Flutter for cross-platform mobile development. Actively building projects to practice skills and deepen understanding of the Dart language and widget tree.',
            isLast: true,
          ),
          const SizedBox(height: 60),
          _sectionTag('TECH STACK'),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              'Java', 'Python', 'C#', 'Flutter', 'Dart',
              'HTML', 'CSS', 'MySQL', 'MongoDB', 'VS Code',
            ].map((t) => _chip(t)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _timelineCard({
    required String title,
    required String org,
    required String period,
    required String body,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline spine
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: blue,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      color: border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: surfaceCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(title,
                            style: const TextStyle(
                              color: white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: blue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: blue.withOpacity(0.2)),
                        ),
                        child: Text(period,
                            style: const TextStyle(
                                color: blueLight,
                                fontSize: 11,
                                letterSpacing: 0.3)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(org,
                      style: const TextStyle(
                          color: blue, fontSize: 13)),
                  const SizedBox(height: 12),
                  Text(body,
                      style: const TextStyle(
                          color: textMid,
                          fontSize: 14,
                          height: 1.75)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceCard,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderBright),
      ),
      child: Text(label,
          style: const TextStyle(
              color: textMid, fontSize: 13, letterSpacing: 0.3)),
    );
  }

  // ── CONTACT ──────────────────────────────────────────────────────

  Widget _buildContact(bool isMobile) {
    return Container(
      key: _contactKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 96, vertical: 88),
      decoration: const BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTag('CONTACT'),
          const SizedBox(height: 14),
          Text(
            "Contact Me",
            style: TextStyle(
              color: white,
              fontSize: isMobile ? 34 : 48,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "Open to opportunities, collaborations, and new connections.",
            style: TextStyle(
                color: textMid, fontSize: 16, height: 1.7),
          ),
          const SizedBox(height: 52),
          isMobile
              ? Column(children: _contactItems())
              : Row(
                  children: _contactItems()
                      .map((w) => Expanded(child: w))
                      .toList(),
                ),
        ],
      ),
    );
  }

  List<Widget> _contactItems() {
    final items = [
      {
        'icon': Icons.email_outlined,
        'label': 'Email',
        'value': 'SorianoBernadeth08@gmail.com',
        'sub': 'Send me a message anytime',
      },
      {
        'icon': Icons.code_outlined,
        'label': 'GitHub',
        'value': 'github.com/brndth-8',
        'sub': 'Browse my projects',
      },
      {
        'icon': Icons.phone_outlined,
        'label': 'Mobile',
        'value': '09503732426',
        'sub': 'Call or text anytime',
      },
    ];

    return items.asMap().entries.map((e) {
      final i = e.key;
      final m = e.value;
      return Container(
        margin: EdgeInsets.only(
          right: i < items.length - 1 ? 16 : 0,
          bottom: 16,
        ),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: surfaceCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: blue.withOpacity(0.2)),
              ),
              child: Icon(m['icon'] as IconData,
                  color: blue, size: 18),
            ),
            const SizedBox(height: 16),
            Text(m['label'] as String,
                style: const TextStyle(
                    color: textDim,
                    fontSize: 11,
                    letterSpacing: 1.2)),
            const SizedBox(height: 5),
            Text(m['value'] as String,
                style: const TextStyle(
                    color: white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(m['sub'] as String,
                style: const TextStyle(
                    color: textMid, fontSize: 12)),
          ],
        ),
      );
    }).toList();
  }

  // ── FOOTER ──────────────────────────────────────────────────────

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 26),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            '© 2025 Bernadeth Soriano',
            style: TextStyle(
                color: textDim, fontSize: 12, letterSpacing: 0.3),
          ),
          Text(
            'Personal Portfolio 💙',
            style: TextStyle(color: textDim, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ── HELPERS ──────────────────────────────────────────────────────

  Widget _sectionTag(String label) {
    return Row(
      children: [
        Container(width: 18, height: 1.5, color: blue),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: blue,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}

// ── BACKGROUND PAINTER ──────────────────────────────────────────────

class AmbientPainter extends CustomPainter {
  final double t;
  AmbientPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Large slow-moving blue radial glow – top right
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF2B7FFF).withOpacity(0.06),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(
          size.width * 0.85 +
              math.cos(t * 2 * math.pi) * 40,
          size.height * 0.15 +
              math.sin(t * 2 * math.pi) * 30,
        ),
        radius: size.width * 0.4,
      ));
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.15),
      size.width * 0.4,
      glowPaint,
    );

    // Second subtle glow – bottom left
    final glow2 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF1A4D99).withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.1, size.height * 0.85),
        radius: size.width * 0.35,
      ));
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.85),
      size.width * 0.35,
      glow2,
    );

    // Very faint dot grid
    final dot = Paint()
      ..color = const Color(0xFF2B7FFF).withOpacity(0.07)
      ..style = PaintingStyle.fill;
    for (double x = 0; x < size.width; x += 48) {
      for (double y = 0; y < size.height; y += 48) {
        canvas.drawCircle(Offset(x, y), 1, dot);
      }
    }
  }

  @override
  bool shouldRepaint(AmbientPainter old) => old.t != t;
}
