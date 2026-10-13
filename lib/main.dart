import 'package:flutter/material.dart';

void main() => runApp(const GridBreakApp());

class GridBreakApp extends StatelessWidget {
  const GridBreakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bento Lookbook',
      home: LookbookScreen(),
    );
  }
}

class LookbookScreen extends StatefulWidget {
  const LookbookScreen({super.key});

  @override
  State<LookbookScreen> createState() => _LookbookScreenState();
}

class _LookbookScreenState extends State<LookbookScreen> {
  // State untuk mode tema gelap/terang
  bool isDarkMode = false;

  // Daftar data default moodboard
  final List<String> defaultMoodboardItems = const [
    "Altera: Digital Wardrobe Mix & Match",
    "Zero-Waste Pattern Blueprint",
    "Organic Cotton Campaign #01",
  ];
  late List<String> moodboardItems;

  // Controller transformasi untuk gesture pinch to zoom
  final TransformationController _transformController = TransformationController();
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    moodboardItems = List.from(defaultMoodboardItems);
    _transformController.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    _transformController.removeListener(_onTransformChanged);
    _transformController.dispose();
    super.dispose();
  }

  // Mendeteksi perubahan skala zoom pada gambar
  void _onTransformChanged() {
    final scale = _transformController.value.getMaxScaleOnAxis();
    final zoomed = scale > 1.05;
    if (zoomed != _isZoomed) {
      setState(() => _isZoomed = zoomed);
    }
  }

  // Mengembalikan skala zoom gambar ke posisi awal
  void _resetZoom() {
    setState(() {
      _transformController.value = Matrix4.identity();
      _isZoomed = false;
    });
  }

  // Mengubah tema global saat dipicu gesture double tap
  void _toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
  }

  // Memulihkan seluruh item moodboard default
  void _restoreDefaultItems() {
    setState(() => moodboardItems = List.from(defaultMoodboardItems));
  }

  // Menghapus item moodboard saat di-swipe dan menampilkan SnackBar Undo
  void _deleteItem(int index, String item, _ThemeColors colors) {
    setState(() => moodboardItems.removeAt(index));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: colors.isDark ? const Color(0xFF1E2128) : const Color(0xFF111827),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: colors.border),
        ),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Item dihapus',
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: colors.accent,
          onPressed: () => setState(() => moodboardItems.insert(index, item)),
        ),
      ),
    );
  }

  // Dekorasi kartu bergaya bento yang konsisten
  BoxDecoration _cardDecor(_ThemeColors colors) => BoxDecoration(
    color: colors.card,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: colors.border, width: 1.5),
    boxShadow: [
      BoxShadow(
        color: colors.isDark ? Colors.black38 : const Color(0x0A000000),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final colors = _ThemeColors(isDarkMode);

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(colors),
              const SizedBox(height: 14),
              _buildImageCard(colors),
              const SizedBox(height: 14),
              _buildMoodboardCard(colors),
            ],
          ),
        ),
      ),
    );
  }

  // Gesture 1: Double Tap pada kartu header untuk beralih tema visual
  Widget _buildHeader(_ThemeColors colors) {
    return GestureDetector(
      onDoubleTap: _toggleTheme,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: _cardDecor(colors),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.accent.withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("✦", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: colors.isDark ? colors.accent : colors.text)),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "SDG 12 // SUSTAINABLE FASHION",
                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 1.1, color: colors.isDark ? colors.accent : colors.text),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _toggleTheme,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.isDark ? const Color(0xFF262A34) : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(colors.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, size: 13, color: colors.isDark ? colors.accent : const Color(0xFFF59E0B)),
                        const SizedBox(width: 4),
                        Text(colors.isDark ? "DARK" : "LIGHT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: colors.text)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text("DESIGN\nTHAT*", style: TextStyle(fontSize: 38, height: 0.92, fontWeight: FontWeight.w900, letterSpacing: -1.2, color: colors.text)),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.accent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: colors.accent.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 3)),
                ],
              ),
              child: Text("BREAKS THE GRID.", style: TextStyle(fontSize: 28, height: 1.05, fontWeight: FontWeight.w900, letterSpacing: -0.5, color: colors.accentText)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.touch_app_outlined, size: 13, color: colors.subtext),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Double tap kartu ini untuk ubah tema visual",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: colors.subtext),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Gesture 2: Scale/Pinch untuk memperbesar, memperkecil, dan menggeser gambar
  Widget _buildImageCard(_ThemeColors colors) {
    return Expanded(
      flex: 11,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: _cardDecor(colors),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.5),
          child: Stack(
            children: [
              InteractiveViewer(
                transformationController: _transformController,
                minScale: 1.0,
                maxScale: 5.0,
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(24),
                child: SizedBox.expand(
                  child: Image.asset('assets/images/skate.jpg', fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: _badge(Icons.crop_original_rounded, "LOOKBOOK // 01", Colors.black.withValues(alpha: 0.7), Colors.white),
              ),
              if (_isZoomed)
                Positioned(
                  top: 14,
                  right: 14,
                  child: GestureDetector(
                    onTap: _resetZoom,
                    child: _badge(Icons.refresh_rounded, "RESET", colors.accent, colors.accentText),
                  ),
                ),
              Positioned(
                bottom: 14,
                right: 14,
                child: _badge(Icons.pinch_outlined, "PINCH TO ZOOM", colors.text, colors.bg),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Gesture 3: Swipe horizontal untuk menghapus item moodboard dengan opsi undo
  Widget _buildMoodboardCard(_ThemeColors colors) {
    return Expanded(
      flex: 9,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        decoration: _cardDecor(colors),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.collections_bookmark_outlined, size: 16, color: colors.accent),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          "SAVED MOODBOARD",
                          style: TextStyle(color: colors.text, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.1),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: colors.accent.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${moodboardItems.length}",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: colors.isDark ? colors.accent : colors.text),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.swipe_left_rounded, size: 14, color: colors.subtext),
                    const SizedBox(width: 4),
                    Text("Swipe to delete", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.subtext)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: moodboardItems.isEmpty ? _buildEmptyMoodboard(colors) : _buildMoodboardList(colors),
            ),
          ],
        ),
      ),
    );
  }

  // Tampilan placeholder estetik saat daftar moodboard kosong
  Widget _buildEmptyMoodboard(_ThemeColors colors) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark_remove_outlined, size: 36, color: colors.subtext),
          const SizedBox(height: 6),
          Text("Semua moodboard telah dihapus", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.subtext)),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _restoreDefaultItems,
            icon: const Icon(Icons.restore_rounded, size: 16),
            label: const Text("PULIHKAN DAFTAR"),
            style: TextButton.styleFrom(
              foregroundColor: colors.accent,
              textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // Daftar item moodboard yang dapat digeser untuk dihapus
  Widget _buildMoodboardList(_ThemeColors colors) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: moodboardItems.length,
      itemBuilder: (context, index) {
        final item = moodboardItems[index];
        return Dismissible(
          key: ValueKey(item),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_outline_rounded, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text("HAPUS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11)),
              ],
            ),
          ),
          onDismissed: (_) => _deleteItem(index, item, colors),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: colors.itemCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    "${index + 1}".padLeft(2, '0'),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: colors.isDark ? colors.accent : colors.text),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(item, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: colors.text), maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios_rounded, size: 11, color: colors.subtext),
              ],
            ),
          ),
        );
      },
    );
  }

  // Komponen reusable untuk badge label overlay
  Widget _badge(IconData icon, String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.8)),
        ],
      ),
    );
  }
}

// Helper palet warna dinamis sesuai state mode tema
class _ThemeColors {
  final bool isDark;
  _ThemeColors(this.isDark);

  Color get bg => isDark ? const Color(0xFF0D0E11) : const Color(0xFFF6F6F8);
  Color get card => isDark ? const Color(0xFF16181D) : Colors.white;
  Color get itemCard => isDark ? const Color(0xFF1E2128) : const Color(0xFFF9FAFB);
  Color get text => isDark ? Colors.white : const Color(0xFF0F1115);
  Color get subtext => isDark ? const Color(0xFF8B92A0) : const Color(0xFF6B7280);
  Color get accent => isDark ? const Color(0xFFD4FF00) : const Color(0xFF0038FF);
  Color get accentText => isDark ? const Color(0xFF0D0E11) : Colors.white;
  Color get border => isDark ? const Color(0xFF2A2E38) : const Color(0xFFE5E7EB);
}