import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/features/shop_dashboard/presentation/bloc/shop_cubit.dart';
import 'package:xfood/features/shop_dashboard/models/revenue_model.dart';
import 'package:xfood/core/utils/currency_formatter.dart';

enum RevenueFilter { week, month, year }

class ShopRevenueTab extends StatefulWidget {
  const ShopRevenueTab({super.key});

  @override
  State<ShopRevenueTab> createState() => _ShopRevenueTabState();
}

class _ShopRevenueTabState extends State<ShopRevenueTab> {
  RevenueFilter _selectedFilter = RevenueFilter.year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê Doanh thu'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<ShopCubit, ShopState>(
          builder: (context, state) {
            if (state.status == ShopStatus.loading || state.revenueSummary == null) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            final summary = state.revenueSummary!;
            final monthlyData = state.monthlyRevenue;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainRevenueCard(summary),
                  const SizedBox(height: 16),
                  _buildStatCard('Đơn hoàn thành', '${summary.completedOrders}', AppColors.warning, Icons.check_circle),
                  const SizedBox(height: 32),
                  const Text('Tăng trưởng Doanh thu & Đơn hàng', style: AppTypography.h3),
                  const SizedBox(height: 16),
                  _buildComboChart(monthlyData),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('Doanh thu (Line)', AppColors.primary),
                      const SizedBox(width: 24),
                      _buildLegendItem('Số đơn (Bar)', AppColors.surfaceContainerHighest),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainRevenueCard(RevenueSummaryModel summary) {
    int displayValue;
    String filterLabel;
    
    switch (_selectedFilter) {
      case RevenueFilter.week:
        displayValue = summary.totalWeekly;
        filterLabel = 'Tuần này';
        break;
      case RevenueFilter.month:
        displayValue = summary.totalMonthly;
        filterLabel = 'Tháng này';
        break;
      case RevenueFilter.year:
        displayValue = summary.totalYearly;
        filterLabel = 'Năm nay';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet, color: AppColors.success, size: 24),
                  const SizedBox(width: 8),
                  Text('Tổng doanh thu', style: AppTypography.caption),
                ],
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<RevenueFilter>(
                  value: _selectedFilter,
                  isDense: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16),
                  style: AppTypography.caption.copyWith(color: AppColors.primary),
                  dropdownColor: AppColors.surfaceContainerHigh,
                  items: const [
                    DropdownMenuItem(value: RevenueFilter.week, child: Text('Tuần này')),
                    DropdownMenuItem(value: RevenueFilter.month, child: Text('Tháng này')),
                    DropdownMenuItem(value: RevenueFilter.year, child: Text('Năm nay')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedFilter = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(CurrencyFormatter.format(displayValue), style: AppTypography.h2.copyWith(color: AppColors.success)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 8),
        Text(label, style: AppTypography.caption),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: AppTypography.caption)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: AppTypography.h3.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildComboChart(List<MonthlyRevenueData> monthlyData) {
    if (monthlyData.isEmpty) return const SizedBox();

    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        padding: const EdgeInsets.only(right: 16, left: 0, top: 24, bottom: 0),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Bar Chart (Orders)
            BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 300,
                minY: 0,
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('T${value.toInt() + 1}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50, // MUST match LineChart left padding
                      getTitlesWidget: (value, meta) => const SizedBox(),
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35, // MUST match LineChart right padding
                      getTitlesWidget: (value, meta) {
                        if (value % 100 != 0 || value == 0) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('${value.toInt()}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.surfaceContainerHighest.withOpacity(0.5),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: monthlyData.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.orderCount.toDouble(),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.tertiary.withOpacity(0.8),
                            AppColors.tertiary.withOpacity(0.2),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        width: 14,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 300,
                          color: AppColors.surfaceContainerHighest.withOpacity(0.3),
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
            // Line Chart (Revenue)
            LineChart(
              LineChartData(
                minX: -0.5,
                maxX: 11.5,
                minY: 0,
                maxY: 150000000,
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30, // MUST match BarChart bottom padding
                      getTitlesWidget: (value, meta) => const SizedBox(),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50, // MUST match BarChart left padding
                      getTitlesWidget: (value, meta) {
                        if (value == 0 || value % 50000000 != 0) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text('${(value / 1000000).toInt()}M', style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35, // MUST match BarChart right padding
                      getTitlesWidget: (value, meta) => const SizedBox(),
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: monthlyData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.revenue.toDouble())).toList(),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.primary,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.surfaceContainerHigh,
                          strokeWidth: 2,
                          strokeColor: AppColors.primary,
                        );
                      },
                    ),
                    shadow: const Shadow(color: AppColors.primary, blurRadius: 8),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.3),
                          AppColors.primary.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
