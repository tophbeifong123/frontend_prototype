import '../../domain/models/prototype_stat.dart';

class MockDashboardRepository {
  Future<List<PrototypeStat>> fetchStats() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return const [
      PrototypeStat(
        id: '1',
        title: 'Active Users',
        value: '24,520',
        changePercentage: '+14.2%',
        isPositive: true,
        description: 'Total active users across platforms',
      ),
      PrototypeStat(
        id: '2',
        title: 'Total Revenue',
        value: '\$128,450',
        changePercentage: '+8.7%',
        isPositive: true,
        description: 'Monthly recurring revenue',
      ),
      PrototypeStat(
        id: '3',
        title: 'API Latency',
        value: '42ms',
        changePercentage: '-5.1%',
        isPositive: true,
        description: 'Average edge latency response',
      ),
      PrototypeStat(
        id: '4',
        title: 'System Errors',
        value: '0.02%',
        changePercentage: '-0.08%',
        isPositive: true,
        description: 'Error rate per 10k requests',
      ),
    ];
  }
}
