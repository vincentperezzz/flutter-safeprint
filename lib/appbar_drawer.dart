import 'package:flutter/material.dart';

PreferredSizeWidget buildNanoPrintAppBar(VoidCallback onLogoTap) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    elevation: 0,
    toolbarHeight: 70,
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onLogoTap,
          child: Row(
            children: [
              Image.asset(
                'assets/nanoprint-logo.png',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBB41D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "NanoPrint",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7E7E7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Powered by SafePrint",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
    actions: [
      Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        ),
      ),
    ],
  );
}

Widget buildNanoPrintDrawer(BuildContext context, void Function(int) onNav) {
  return Theme(
    data: Theme.of(context).copyWith(
      canvasColor: Colors.white, // Forces Drawer background to white
    ),
    child: Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFBB41D),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help'),
              onTap: () {
                onNav(2);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('FAQ'),
              onTap: () {
                onNav(3);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Us'),
              onTap: () {
                onNav(4);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    ),
  );
}