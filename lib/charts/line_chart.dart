import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:teslamate/charts_series/series_data.dart';

import 'dart:math';

class LineChart extends StatelessWidget {
  final List<SeriesData> data;
  final String id;

  const LineChart({Key? key, required this.data, required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<charts.Series<SeriesData, DateTime>> series = [
      charts.Series(
        id: id,
        data: data,
        domainFn: (dynamic series, _) => series.x,
        measureFn: (dynamic series, _) => series.y,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      )..setAttribute(charts.rendererIdKey, 'customArea')
    ];

    final size = MediaQuery.of(context).size;

    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.only(
          right: 10,
          left: 10,
        ),
        child: charts.TimeSeriesChart(
          series,
          animate: true,
          customSeriesRenderers: [
            charts.LineRendererConfig(
              customRendererId: 'customArea',
              includeArea: true,
            )
          ],
          domainAxis: charts.EndPointsTimeAxisSpec(
            showAxisLine: false,
            tickFormatterSpec: charts.BasicDateTimeTickFormatterSpec.fromDateFormat(
              DateFormat("HH:mm"),
            ),
          ),
          behaviors: [
            charts.LinePointHighlighter(
              symbolRenderer: CustomCircleSymbolRenderer(size: size),
              showHorizontalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
              showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
            ),
            charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag),
          ],
          selectionModels: [
            SelectionModelConfig(changedListener: (SelectionModel model) {
              if (model.hasDatumSelection) {
                CustomCircleSymbolRenderer.value = model.selectedSeries[0].measureFn(model.selectedDatum[0].index).toString();
              }
            })
          ],
        ),
      ),
    );
  }
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  final dynamic size;
  static String value = "0";

  CustomCircleSymbolRenderer({this.size});

  @override
  void paint(
    charts.ChartCanvas canvas,
    Rectangle<num> bounds, {
    List<int>? dashPattern,
    Color? fillColor,
    FillPatternType? fillPattern,
    Color? strokeColor,
    double? strokeWidthPx,
  }) {
    super.paint(
      canvas,
      bounds,
      dashPattern: dashPattern,
      fillColor: fillColor,
      fillPattern: fillPattern,
      strokeColor: strokeColor,
      strokeWidthPx: strokeWidthPx,
    );
    if (size != null) {
      num rectWidth = bounds.width + value.length * 8.3;
      num rectHeight = bounds.height + 20;
      num left =
          bounds.left > size.width / 2 ? (bounds.left > size.width / 4 ? bounds.left - rectWidth : bounds.left - rectWidth / 2) : bounds.left - 40;
      canvas.drawRect(
        Rectangle(left, 0, rectWidth, rectHeight),
        fill: charts.Color.fromHex(code: '#333333'),
      );
      canvas.graphicsFactory.createTextPaint()
        ..color = Color.white
        ..fontSize = 13;
      canvas.drawText(canvas.graphicsFactory.createTextElement(value), (left).round() + 5, 8);
    }
  }
}
