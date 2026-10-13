import 'package:flutter/material.dart';

void main() => runApp(const GridBreakApp());

class GridBreakApp extends StatelessWidget {
  const GridBreakApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LookbookScreen(),
    );
  }
}

class LookbookScreen extends StatefulWidget {
  const LookbookScreen({Key? key}) : super(key: key);

  @override
  State<LookbookScreen> createState() => _LookbookScreenState();
}

class _LookbookScreenState extends State<LookbookScreen> {
  // State 1: Global Theme Mode (Double Tap Gesture)
  bool isDarkMode = false;
  
  // State 2: Daftar Moodboard (Swipe Gesture)
  List<String> moodboardItems = [
    "Altera: Digital Wardrobe Mix & Match",
    "Zero-Waste Pattern Blueprint",
    "Organic Cotton Campaign #01"
  ];

  @override
  Widget build(BuildContext context) {
    // Palet warna dinamis yang berubah sesuai state isDarkMode
    final Color bgColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF4F4F2);
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color accentColor = isDarkMode ? const Color(0xFFCCFF00) : const Color(0xFF0033FF);
    final Color gridColor = isDarkMode ? Colors.white24 : Colors.black12;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 1. DOUBLE TAP GESTURE (Global Theme Switcher) ---
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  isDarkMode = !isDarkMode; // Mengubah state tema
                });
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: gridColor, width: 1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("*", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: textColor)),
                        Text(
                          "SDG 12 // SUSTAINABLE FASHION", 
                          style: TextStyle(fontSize: 10, letterSpacing: 2, color: textColor)
                        ),
                      ],
                    ),
                    Text(
                      "DESIGN\nTHAT*",
                      style: TextStyle(fontSize: 60, height: 0.9, fontWeight: FontWeight.w900, color: textColor),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: accentColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "BREAKS\nTHE GRID.",
                        style: TextStyle(
                          fontSize: 60, 
                          height: 1.0, 
                          fontWeight: FontWeight.w900, 
                          color: isDarkMode ? Colors.black : Colors.white
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "(Double tap area ini untuk ubah tema)", 
                      style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey[400] : Colors.grey[600])
                    ),
                  ],
                ),
              ),
            ),

            // --- 2. SCALE/PINCH GESTURE (Interactive Local Image Explorer) ---
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: gridColor, width: 1)),
                ),
                child: Stack(
                  children: [
                    InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 5.0,
                      panEnabled: true,
                      boundaryMargin: const EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          // Pastikan aset gambar ini sudah didaftarkan di pubspec.yaml
                          image: DecorationImage(
                            image: AssetImage('assets/images/skate.jpg'), 
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: textColor,
                        child: Text(
                          "PINCH TO ZOOM", 
                          style: TextStyle(color: bgColor, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 3. SWIPE GESTURE (Moodboard dengan SnackBar Undo) ---
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Container(
                    width: 120,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: textColor,
                      border: Border(right: BorderSide(color: gridColor, width: 1)),
                    ),
                    child: Text(
                      "SAVED\nMOODBOARD\n\n-> Swipe to delete",
                      style: TextStyle(color: bgColor, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: moodboardItems.length,
                      itemBuilder: (context, index) {
                        final item = moodboardItems[index];
                        return Dismissible(
                          key: Key(item),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.redAccent,
                            child: const Icon(Icons.delete_outline, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            // Hapus item dari daftar state
                            setState(() {
                              moodboardItems.removeAt(index);
                            });
                            // Tampilkan SnackBar untuk opsi Undo
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Item dihapus"),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () {
                                    // Kembalikan item ke daftar state
                                    setState(() {
                                      moodboardItems.insert(index, item);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: gridColor, width: 1)),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              title: Text(
                                item,
                                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                              ),
                              trailing: Icon(Icons.arrow_forward, size: 16, color: textColor),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}