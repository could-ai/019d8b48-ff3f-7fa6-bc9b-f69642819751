import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Community & Contests'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Contests'),
              Tab(text: 'Leaderboard'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ContestsTab(),
            _LeaderboardTab(),
          ],
        ),
      ),
    );
  }
}

class _ContestsTab extends StatelessWidget {
  const _ContestsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Challenges',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton.icon(
              onPressed: () => _showJoinPrivateDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Join Private'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildContestCard(
          context,
          'Global Ekadashi Marathon',
          'Chant 64 rounds today',
          '1,204 Participants',
          true,
        ),
        _buildContestCard(
          context,
          'Weekly 10k Challenge',
          'Reach 10,000 names this week',
          '542 Participants',
          false,
        ),
        _buildContestCard(
          context,
          'Family Chanting Group',
          'Private Group',
          '12 Participants',
          true,
          isPrivate: true,
        ),
      ],
    );
  }

  Widget _buildContestCard(
    BuildContext context,
    String title,
    String description,
    String participants,
    bool isJoined, {
    bool isPrivate = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isPrivate)
                  const Icon(Icons.lock, size: 16, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  participants,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                ElevatedButton(
                  onPressed: isJoined ? null : () {},
                  child: Text(isJoined ? 'Joined' : 'Join'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinPrivateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Private Contest'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Invite Code',
            hintText: 'Enter 6-digit code',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardTab extends StatelessWidget {
  const _LeaderboardTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: index < 3
                ? Colors.amber[700 - (index * 200)]
                : Colors.grey[300],
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: index < 3 ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text('Devotee ${index + 1}'),
          subtitle: const Text('Level 5'),
          trailing: Text(
            '${10000 - (index * 500)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}
