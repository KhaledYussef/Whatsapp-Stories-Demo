import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testtt/repository.dart';

import 'whatsapp.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => Repository(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Story Demo',
      theme: ThemeData(),
      home: NavigationPage(),
    );
  }
}

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Story Demo",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Column(
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await context.read<Repository>().getWhatsappStories2();
              },
              child: Text("Fetch Stories  ${context.watch<Repository>().reels.length}"),
            ),
            NavigationItem(
              title: "Whatsapp Custom Story",
              description: "Demo on full page stories with customizations",
              icon: Image.asset("assets/images/whatsapp.png"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Whatsapp()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationItem extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final String? description;
  final Image? icon;

  NavigationItem({
    this.title,
    this.description,
    this.icon,
    this.onTap,
  });

  Widget _buildTitles() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            description!,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);
    return Material(
      borderRadius: borderRadius,
      color: Colors.white,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 56,
                height: 56,
                child: icon,
              ),
              SizedBox(
                width: 16,
              ),
              _buildTitles(),
              SizedBox(
                width: 16,
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
