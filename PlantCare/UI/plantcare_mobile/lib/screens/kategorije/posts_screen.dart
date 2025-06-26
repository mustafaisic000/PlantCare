import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/kategorija_model.dart';
import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/models/subkategorije_model.dart';
import 'package:plantcare_mobile/providers/post_provider.dart';
import 'package:plantcare_mobile/providers/subkategorije_provider.dart';
import 'package:plantcare_mobile/common/widgets/post_card.dart';
import 'package:plantcare_mobile/screens/kategorije/post_detail_screen.dart';

class PostsScreen extends StatefulWidget {
  final Kategorija kategorija;

  const PostsScreen({super.key, required this.kategorija});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PostProvider _postProvider = PostProvider();
  final SubkategorijaProvider _subProvider = SubkategorijaProvider();
  final TextEditingController _searchController = TextEditingController();

  List<Subkategorija> _subkategorije = [];
  final List<Post> _posts = [];
  final List<int> _selectedSubIds = [];

  int _page = 1;
  final int _pageSize = 6;

  bool _isLoading = true;
  bool _isFetchingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchSubkategorije();
    _fetchPosts(reset: true);
  }

  Future<void> _fetchSubkategorije() async {
    final result = await _subProvider.get(
      filter: {'kategorijaId': widget.kategorija.kategorijaId},
    );
    setState(() {
      _subkategorije = result.result;
    });
  }

  Future<void> _fetchPosts({bool reset = false}) async {
    if (reset) {
      _page = 0;
      _posts.clear();
      _hasMore = true;
      setState(() => _isLoading = true);
    } else {
      setState(() => _isFetchingMore = true);
    }

    final filters = {
      'FTS': _searchController.text,
      'page': _page,
      'pageSize': _pageSize,
      'status': true,
      'KategorijaId': widget.kategorija.kategorijaId,
    };

    if (_selectedSubIds.isNotEmpty) {
      filters['subkategorijaIdList'] = _selectedSubIds;
    }

    final result = await _postProvider.get(filter: filters);

    setState(() {
      _posts.addAll(result.result);
      _isLoading = false;
      _isFetchingMore = false;
      _hasMore = _posts.length < result.count;
    });
  }

  void _onSearchChanged(String value) {
    _fetchPosts(reset: true);
  }

  void _onToggleSub(int id) {
    setState(() {
      if (_selectedSubIds.contains(id)) {
        _selectedSubIds.remove(id);
      } else {
        _selectedSubIds.add(id);
      }
    });
    _fetchPosts(reset: true);
  }

  void _loadMore() {
    if (!_hasMore || _isFetchingMore) return;
    _page++;
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.kategorija.naziv)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _onSearchChanged(value),
              decoration: InputDecoration(
                hintText: 'Pretraži objave...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.green),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _subkategorije.map((sub) {
                    final selected = _selectedSubIds.contains(
                      sub.subkategorijaId,
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(sub.naziv),
                        selected: selected,
                        selectedColor: Colors.green,
                        onSelected: (_) => _onToggleSub(sub.subkategorijaId),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _posts.isEmpty
                ? const Center(child: Text("Nema objava."))
                : NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          notification.metrics.extentAfter < 300) {
                        _loadMore();
                      }
                      return false;
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount:
                          _posts.length +
                          (_hasMore ? 1 : 0), // +1 for loading spinner
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                      itemBuilder: (context, index) {
                        if (index >= _posts.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return PostCard(
                          post: _posts[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PostDetailScreen(post: _posts[index]),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
