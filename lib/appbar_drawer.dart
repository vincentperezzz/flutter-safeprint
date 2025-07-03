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
  return Drawer(
    backgroundColor: Colors.white,
    child: Material(
      color: Colors.white,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFFBB41D),
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 24, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.help_outline, color: Colors.black),
                title: const Text(
                  'Help', 
                  style: TextStyle(color: Colors.black, fontSize: 16)
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  onNav(2);
                },
              ),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.question_answer, color: Colors.black),
                title: const Text(
                  'FAQ', 
                  style: TextStyle(color: Colors.black, fontSize: 16)
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  onNav(3);
                },
              ),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.black),
                title: const Text(
                  'About Us', 
                  style: TextStyle(color: Colors.black, fontSize: 16)
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  onNav(4);
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}