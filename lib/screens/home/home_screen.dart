import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/gig_provider.dart';
import '../../models/gig.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GigProvider>().fetchGigs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _selectedIndex == 0 ? _buildHome() : _buildProfile(),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/gigs/create'),
              icon: const Icon(Icons.add),
              label: const Text('New Gig'),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final user = context.watch<AuthProvider>().user;
    
    return AppBar(
      title: const Text('SureWork'),
      actions: [
        IconButton(
          icon: const Icon(Icons.account_balance_wallet_outlined),
          onPressed: () => context.push('/wallet'),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // TODO: Navigate to notifications
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              user?.fullName.substring(0, 1).toUpperCase() ?? 'U',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHome() {
    final user = context.watch<AuthProvider>().user;
    final gigProvider = context.watch<GigProvider>();

    return RefreshIndicator(
      onRefresh: () => gigProvider.fetchGigs(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    user?.fullName ?? 'User',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  _buildStatsCards(user?.role),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user?.role == 'FREELANCER'
                            ? 'Available Gigs'
                            : 'Your Gigs',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/gigs'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (gigProvider.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (gigProvider.gigs.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.work_off_outlined,
                      size: 80,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No gigs available yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.role == 'CLIENT'
                          ? 'Create your first gig to get started'
                          : 'Check back later for new opportunities',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final gig = gigProvider.gigs[index];
                    return _buildGigCard(gig);
                  },
                  childCount: gigProvider.gigs.length > 5
                      ? 5
                      : gigProvider.gigs.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(String? role) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.work_outline,
            label: role == 'CLIENT' ? 'Active Gigs' : 'Completed',
            value: '12',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Total Earned',
            value: '\$5,420',
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.star_outline,
            label: 'Rating',
            value: '4.8',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGigCard(Gig gig) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/gigs/${gig.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      gig.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusChip(gig.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                gig.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.account_circle_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    gig.clientId,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    timeago.format(gig.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${gig.amount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (gig.status == GigStatus.created)
                    OutlinedButton(
                      onPressed: () => context.push('/gigs/${gig.id}'),
                      child: const Text('View Details'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(GigStatus status) {
    Color color;
    String label;

    switch (status) {
      case GigStatus.created:
        color = Colors.blue;
        label = 'Open';
        break;
      case GigStatus.funded:
        color = Colors.orange;
        label = 'Funded';
        break;
      case GigStatus.submitted:
        color = Colors.teal;
        label = 'Submitted';
        break;
      case GigStatus.completed:
        color = Colors.green;
        label = 'Completed';
        break;
      case GigStatus.disputed:
        color = Colors.red;
        label = 'Disputed';
        break;
      case GigStatus.cancelled:
        color = Colors.grey;
        label = 'Cancelled';
        break;
      case GigStatus.refunded:
        color = Colors.blueGrey;
        label = 'Refunded';
        break;
    }

    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildProfile() {
    final user = context.watch<AuthProvider>().user;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 20),
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              user?.fullName.substring(0, 1).toUpperCase() ?? 'U',
              style: TextStyle(
                fontSize: 36,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user?.fullName ?? 'User',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          user?.email ?? '',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Center(
          child: Chip(
            label: Text(user?.role ?? 'USER'),
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
        ),
        const SizedBox(height: 32),
        _buildProfileOption(
          icon: Icons.person_outline,
          title: 'Edit Profile',
          onTap: () => context.push('/profile'),
        ),
        _buildProfileOption(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Wallet',
          onTap: () => context.push('/wallet'),
        ),
        _buildProfileOption(
          icon: Icons.history,
          title: 'Transaction History',
          onTap: () {},
        ),
        _buildProfileOption(
          icon: Icons.star_outline,
          title: 'Reviews',
          onTap: () {},
        ),
        _buildProfileOption(
          icon: Icons.settings_outlined,
          title: 'Settings',
          onTap: () {},
        ),
        _buildProfileOption(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            context.read<AuthProvider>().logout();
            context.go('/login');
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
