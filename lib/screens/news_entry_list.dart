// lib/screens/news_entry_list.dart
import 'package:flutter/material.dart';
import 'package:football_news/models/news_entry.dart';
import 'package:football_news/widgets/left_drawer.dart';
import 'package:football_news/screens/news_detail.dart';
import 'package:football_news/widgets/news_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class NewsEntryListPage extends StatefulWidget {
  const NewsEntryListPage({super.key});

  @override
  State<NewsEntryListPage> createState() => _NewsEntryListPageState();
}

class _NewsEntryListPageState extends State<NewsEntryListPage> {
  Future<List<NewsEntry>> fetchNews(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/json/');
    var data = response;
    List<NewsEntry> listNews = [];
    for (var d in data) {
      if (d != null) {
        listNews.add(NewsEntry.fromJson(d));
      }
    }
    return listNews;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(title: const Text('News Entry List')),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<NewsEntry>>(
        future: fetchNews(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'There are no news in football news yet.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          } else {
            final list = snapshot.data!;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) => NewsEntryCard(
                news: list[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailPage(news: list[index]),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
