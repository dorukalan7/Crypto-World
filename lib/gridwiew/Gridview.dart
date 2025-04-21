import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(Gridview());
}

class App {
  final String name;
  final String category;
  final String releaseDate;
  final String appIconUrl;
  final String storeUrl;

  App({
    required this.name,
    required this.category,
    required this.releaseDate,
    required this.appIconUrl,
    required this.storeUrl,
  });
}

class Gridview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neon Apps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: AppGridScreen(),
    );
  }
}

class AppGridScreen extends StatefulWidget {
  @override
  _AppGridScreenState createState() => _AppGridScreenState();
}

class _AppGridScreenState extends State<AppGridScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<App> appList = List.generate(14, (index) {
    int number = index + 1;
    return App(
      name: 'App $number',
      category: ['Games', 'Education', 'Social', 'Productivity'][index % 4],
      releaseDate: '2021-${(index % 12 + 1).toString().padLeft(2, '0')}-01',
      appIconUrl: 'https://picsum.photos/id/${number + 10}/200/200',
      storeUrl: 'https://example.com/app$number',
    );
  });

  void _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Neon Apps')),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: GridView.builder(
          padding: EdgeInsets.all(10),
          itemCount: appList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final app = appList[index];
            return CupertinoContextMenu(
              actions: [
                CupertinoContextMenuAction(
                  child: Text("Open"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppDetailScreen(app: app),
                      ),
                    );
                  },
                ),
                CupertinoContextMenuAction(
                  child: Text("Share"),
                  onPressed: () {
                    print("Sharing ${app.name}");
                    Navigator.pop(context);
                  },
                ),
              ],
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(app.appIconUrl, height: 120),
                      SizedBox(height: 10),
                      Text(app.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(app.category, style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AppDetailScreen extends StatelessWidget {
  final App app;

  AppDetailScreen({required this.app});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(app.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(app.appIconUrl, height: 100)),
            SizedBox(height: 20),
            Text('Name: ${app.name}', style: TextStyle(fontSize: 20)),
            Text('Category: ${app.category}', style: TextStyle(fontSize: 18)),
            Text('Release Date: ${app.releaseDate}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final url = Uri.parse(app.storeUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Text('Open in App Store'),
            )
          ],
        ),
      ),
    );
  }
}
