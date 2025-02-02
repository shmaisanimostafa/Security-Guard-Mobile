import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package
import 'package:capstone_proj/models/author.dart';
import 'package:capstone_proj/models/article.dart';
import 'package:capstone_proj/functions/article_api_handler.dart';
import 'package:capstone_proj/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:capstone_proj/Screens/registration_screens/log_in.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key, required this.id});

  final int id;

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  ArticleAPIHandler apiHandler = ArticleAPIHandler();
  late Article data = Article(
    id: 1,
    rating: 0,
    readCount: 0,
    likeCount: 0,
    disLikeCount: 0,
    content: 'Loading content...',
    summary: 'Loading summary...',
    isFeatured: false,
    sourceURL: 'https://example.com',
    title: 'Loading title...',
    imageURL: 'images/Logo.png',
    publishDate: DateTime.now(),
    author: Author(
      name: 'Loading name...',
      isVerified: false,
      firstName: 'Loading first name...',
      lastName: 'Loading last name...',
      imageURL: 'images/ProfilePic.png',
    ),
    comments: [],
  );

  final TextEditingController _commentController = TextEditingController();
  bool _isPosting = false; // Track whether a comment is being posted
  bool _isLoading = true; // Track whether the article data is being loaded

  Future<void> getData() async {
    try {
      final fetchedData = await apiHandler.getArticle(widget.id);
      setState(() {
        data = fetchedData;
        _isLoading = false; // Data has been loaded
      });
    } catch (e) {
      // Handle error (e.g., show a message to the user)
      print(e);
      setState(() {
        _isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  void postComment() async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  // Check if the user is authenticated
  if (!authProvider.isAuthenticated) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You must be logged in to post a comment.')),
    );
    return;
  }

  // Get the comment content
  final content = _commentController.text.trim();
  if (content.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment cannot be empty.')),
    );
    return;
  }

  // Get the user's name from the AuthProvider
  final username = authProvider.userData?['userName']; // Use the correct key for username
  if (username == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Username not found. Please log in again.')),
    );
    return;
  }

  setState(() {
    _isPosting = true; // Start loading animation
  });

  try {
    // Post the comment using the simplified serialization
    await apiHandler.addComment(widget.id, content, username);

    // Clear the comment input
    _commentController.clear();

    // Refresh the article data to show the new comment
    await getData();

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment posted successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to post comment: $e')),
    );
  } finally {
    setState(() {
      _isPosting = false; // Stop loading animation
    });
  }
}



  @override
  void initState() {
    super.initState();
    getData(); // Fetch the article data when the screen is first loaded
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // LinearProgressIndicator at the top while loading
          if (_isLoading)
            const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow), // Yellow color
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _isLoading
                  ? _buildShimmerEffect() // Show shimmer effect while loading
                  : ListView(
                      children: [
                        Text(
                          data.title,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 15.0,
                              backgroundImage: NetworkImage(data.author.imageURL.isNotEmpty
                                  ? data.author.imageURL
                                  : 'images/ProfilePic.png'),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      data.author.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    if (data.author.isVerified) ...[
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Icons.verified,
                                        size: 15,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  '${data.publishDate.day}-${data.publishDate.month}-${data.publishDate.year}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'images/Logo.png', // Placeholder image
                            image: data.imageURL.isNotEmpty
                                ? data.imageURL
                                : 'images/Logo.png', // Fallback for missing image
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'images/Logo.png', // Fallback image if the network image fails to load
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          data.content,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 15.0),
                        // Display comments
                        Text(
                          'Comments',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10.0),
                        ...data.comments.map((comment) => ListTile(
                              title: Text(comment.author),
                              subtitle: Text(comment.content),
                              trailing: Text(comment.createdDate.toString()),
                            )),
                        const SizedBox(height: 20.0),
                        // Comment input section (only for signed-in users)
                        if (authProvider.isAuthenticated)
                          Column(
                            children: [
                              TextField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  hintText: 'Write a comment...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  suffixIcon: _isPosting
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(), // Show loading indicator
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.send),
                                          onPressed: _isPosting
                                              ? null // Disable the button while posting
                                              : () {
                                                  setState(() {
                                                    postComment();
                                                  });
                                                },
                                        ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          )
                        else
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the login screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LogInScreen(),
                                  ),
                                );
                              },
                              child: const Text('Sign In to Comment'),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the shimmer effect for the loading state
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: const Duration(milliseconds: 1500), // Adjust the animation speed
      child: ListView(
        children: [
          // Shimmer effect for the title
          ShimmerContainer(
            width: double.infinity,
            height: 30,
            borderRadius: 5,
          ),
          const SizedBox(height: 15.0),
          // Shimmer effect for the author section
          Row(
            children: [
              ShimmerContainer(
                width: 30,
                height: 30,
                borderRadius: 15, // Circular shape
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerContainer(
                    width: 100,
                    height: 15,
                    borderRadius: 5,
                  ),
                  const SizedBox(height: 5),
                  ShimmerContainer(
                    width: 80,
                    height: 10,
                    borderRadius: 5,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15.0),
          // Shimmer effect for the image
          ShimmerContainer(
            width: double.infinity,
            height: 200,
            borderRadius: 10,
          ),
          const SizedBox(height: 15.0),
          // Shimmer effect for the content
          ShimmerContainer(
            width: double.infinity,
            height: 100,
            borderRadius: 5,
          ),
          const SizedBox(height: 15.0),
          // Shimmer effect for the comments section
          ShimmerContainer(
            width: double.infinity,
            height: 20,
            borderRadius: 5,
          ),
          const SizedBox(height: 10.0),
          ...List.generate(3, (index) => ShimmerContainer(
            width: double.infinity,
            height: 50,
            borderRadius: 5,
            margin: const EdgeInsets.only(bottom: 10),
          )),
        ],
      ),
    );
  }
}

// Reusable Shimmer Container Widget
class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerContainer({
    required this.width,
    required this.height,
    required this.borderRadius,
    this.margin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}