class RevenueSummaryModel {
  final int totalWeekly;
  final int totalMonthly;
  final int totalYearly;
  final int completedOrders;

  const RevenueSummaryModel({
    required this.totalWeekly,
    required this.totalMonthly,
    required this.totalYearly,
    required this.completedOrders,
  });
}

class MonthlyRevenueData {
  final int month;
  final int revenue;
  final int orderCount;

  const MonthlyRevenueData({
    required this.month,
    required this.revenue,
    required this.orderCount,
  });
}
