import 'package:flutter/material.dart';

class AudioBackgroundDetail extends StatelessWidget {
  final Map<String, dynamic> background;
  final List<Map<String, dynamic>> ownerDetails;

  const AudioBackgroundDetail({
    super.key,
    required this.background,
    required this.ownerDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Background Detail"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display background image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  background['url'] ?? '',
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
              const SizedBox(height: 16),

              // Display title and price
              Text(
                background['title'] ?? 'Unknown Title',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Price: \$${background['price'].toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                background['description'] ?? 'No description available.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Display owner details
              const Text(
                "Owners:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ownerDetails.isEmpty
                  ? const Text(
                      "No owner information available.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ownerDetails.length,
                      itemBuilder: (context, index) {
                        final owner = ownerDetails[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              owner['profilePictureUrl'] ?? '',
                            ),
                            onBackgroundImageError: (_, __) =>
                                const Icon(Icons.person),
                          ),
                          title: Text(owner['name'] ?? 'Unknown Owner'),
                          subtitle: Text(owner['email'] ?? ''),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
