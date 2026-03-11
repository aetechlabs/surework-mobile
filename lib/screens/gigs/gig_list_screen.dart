import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/gig_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/gig.dart';

class GigListScreen extends StatefulWidget {
  const GigListScreen({super.key});

  @override
  State<GigListScreen> createState() => _GigListScreenState();
}

class _GigListScreenState extends State<GigListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GigProvider>().fetchGigs();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final isClient = user?.role == 'CLIENT';

    return Scaffold(
      appBar: AppBar(
        title: Text(isClient ? 'My Gigs' : 'Browse Gigs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGigList(null),
          _buildGigList(GigStatus.funded),
          _buildGigList(GigStatus.completed),
        ],
      ),
      floatingActionButton: isClient
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/gigs/create'),
              icon: const Icon(Icons.add),
              label: const Text('Create Gig'),
            )
          : null,
    );
  }

  Widget _buildGigList(GigStatus? filterStatus) {
    final gigProvider = context.watch<GigProvider>();

    if (gigProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final gigs = filterStatus == null
        ? gigProvider.gigs
        : gigProvider.gigs.where((g) => g.status == filterStatus).toList();

    if (gigs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_off_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No gigs found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => gigProvider.fetchGigs(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: gigs.length,
        itemBuilder: (context, index) {
          return _buildGigCard(gigs[index]);
        },
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${gig.amount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => context.push('/gigs/${gig.id}'),
                    child: const Text('View'),
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
}
