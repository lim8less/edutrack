import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class ActivitySuggestionsScreen extends StatefulWidget {
  const ActivitySuggestionsScreen({super.key});

  @override
  State<ActivitySuggestionsScreen> createState() => _ActivitySuggestionsScreenState();
}

class _ActivitySuggestionsScreenState extends State<ActivitySuggestionsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;
  String _selectedSubject = 'Mathematics';
  String _selectedDifficulty = 'Medium';

  final List<String> subjects = [
    'Mathematics',
    'Science',
    'English',
    'History',
    'Geography',
    'Physics',
    'Chemistry',
    'Biology'
  ];

  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];

  // Mock activity data
  final List<Map<String, dynamic>> mockActivities = [
    {
      'title': 'Quadratic Equations Practice',
      'subject': 'Mathematics',
      'difficulty': 'Medium',
      'duration': '30 minutes',
      'description': 'Practice solving quadratic equations using different methods including factoring and the quadratic formula.',
      'type': 'Problem Set',
      'icon': Icons.calculate,
      'color': Colors.blue,
    },
    {
      'title': 'Periodic Table Explorer',
      'subject': 'Science',
      'difficulty': 'Easy',
      'duration': '20 minutes',
      'description': 'Interactive exploration of the periodic table and element properties.',
      'type': 'Interactive',
      'icon': Icons.science,
      'color': Colors.green,
    },
    {
      'title': 'Essay Writing Techniques',
      'subject': 'English',
      'difficulty': 'Medium',
      'duration': '45 minutes',
      'description': 'Learn and practice advanced essay writing techniques with guided examples.',
      'type': 'Writing',
      'icon': Icons.edit,
      'color': Colors.orange,
    },
    {
      'title': 'World War II Timeline',
      'subject': 'History',
      'difficulty': 'Easy',
      'duration': '25 minutes',
      'description': 'Create an interactive timeline of major World War II events.',
      'type': 'Research',
      'icon': Icons.timeline,
      'color': Colors.purple,
    },
    {
      'title': 'Photosynthesis Lab Simulation',
      'subject': 'Biology',
      'difficulty': 'Hard',
      'duration': '40 minutes',
      'description': 'Virtual lab experiment to understand the process of photosynthesis.',
      'type': 'Lab',
      'icon': Icons.local_florist,
      'color': Colors.green,
    },
    {
      'title': 'Geometry Proof Workshop',
      'subject': 'Mathematics',
      'difficulty': 'Hard',
      'duration': '50 minutes',
      'description': 'Step-by-step guide to constructing geometric proofs.',
      'type': 'Workshop',
      'icon': Icons.architecture,
      'color': Colors.blue,
    },
  ];

  List<Map<String, dynamic>> get filteredActivities {
    return mockActivities.where((activity) {
      return activity['subject'] == _selectedSubject &&
          activity['difficulty'] == _selectedDifficulty;
    }).toList();
  }

  Future<void> _generateNewSuggestions() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate AI processing time
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New AI-generated suggestions loaded!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Suggestions'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateNewSuggestions,
            tooltip: 'Generate New Suggestions',
          ),
        ],
      ),
      body: Column(
        children: [
          // AI Suggestion Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange.shade50,
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.orange, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI-Powered Learning Suggestions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        'Personalized activities based on your learning progress',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Subject Filter
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Subject',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedSubject,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: subjects.map((subject) {
                          return DropdownMenuItem(
                            value: subject,
                            child: Text(subject),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedSubject = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Difficulty Filter
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Difficulty',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedDifficulty,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: difficulties.map((difficulty) {
                          return DropdownMenuItem(
                            value: difficulty,
                            child: Text(difficulty),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedDifficulty = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Activities List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'AI is generating personalized suggestions...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : filteredActivities.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredActivities.length,
                        itemBuilder: (context, index) {
                          final activity = filteredActivities[index];
                          return _buildActivityCard(activity);
                        },
                      ),
          ),

          // Generate More Button
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateNewSuggestions,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate More Suggestions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No activities found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing the subject or difficulty level',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _generateNewSuggestions,
            icon: const Icon(Icons.refresh),
            label: const Text('Generate New Suggestions'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showActivityDetails(activity),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: activity['color'].withOpacity(0.1),
                    child: Icon(
                      activity['icon'],
                      color: activity['color'],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildChip(activity['type'], Colors.blue),
                            const SizedBox(width: 8),
                            _buildChip(activity['difficulty'], _getDifficultyColor(activity['difficulty'])),
                            const SizedBox(width: 8),
                            Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              activity['duration'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                activity['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showActivityDetails(Map<String, dynamic> activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: activity['color'].withOpacity(0.1),
                      child: Icon(
                        activity['icon'],
                        color: activity['color'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        activity['title'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Details
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  activity['description'],
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Activity bookmarked!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.bookmark_border),
                        label: const Text('Bookmark'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Starting activity...'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Activity'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: activity['color'],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}