import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:teslamate/charts_series/series.dart';

class LineChart extends StatelessWidget {
  final List<Series> data;
  final String id;

  const LineChart({Key? key, required this.data, required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<charts.Series<Series, num>> series = [
      charts.Series(
        id: id,
        data: data,
        domainFn: (dynamic series, _) => series.x,
        measureFn: (dynamic series, _) => series.y,
      )
    ];

    return charts.LineChart(
      series,
      animate: true,
      domainAxis: const charts.NumericAxisSpec(
        showAxisLine: true,
        renderSpec: charts.NoneRenderSpec(),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false)),
      behaviors: [
        charts.LinePointHighlighter(
          showHorizontalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
          showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
        ),
        charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag),
      ],
    );
  }
}
