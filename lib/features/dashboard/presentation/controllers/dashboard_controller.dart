import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/mock_dashboard_repository.dart';
import '../../domain/models/prototype_stat.dart';

final dashboardRepositoryProvider = Provider((ref) => MockDashboardRepository());

final dashboardStatsProvider = FutureProvider<List<PrototypeStat>>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.fetchStats();
});
