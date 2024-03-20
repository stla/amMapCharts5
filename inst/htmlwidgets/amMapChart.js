HTMLWidgets.widget({
  name: "amMapChart",

  type: "output",

  factory: function (el, width, height) {
    let addSeries = function (root, chart, xseries) {
      console.log(xseries)
      let series = chart.series.push(am5map[xseries.type].new(root, {}));
      series.data.setAll(xseries.data);
      series["mapPolygons"].template.setAll(xseries.options);
    };

    return {
      renderValue: function (x) {
        var root = am5.Root.new(el.id);
        let chart = root.container.children.push(
          am5map.MapChart.new(root, {
            projection: am5map["geoMercator"]()
          })
        );
        for (xseries of x.series) {
          addSeries(root, chart, xseries);
        }

        chart.appear(1000, 100);
      },

      resize: function (width, height) {
        // TODO: code to re-render the widget with a new size
      }
    };
  }
});
