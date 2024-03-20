HTMLWidgets.widget({
  name: "amMapChart",

  type: "output",

  factory: function (el, width, height) {
    return {
      renderValue: function (x) {
        var root = am5.Root.new(el.id);
        let chart = root.container.children.push(
          am5map.MapChart.new(root, {
            projection: am5map.geoMercator()
          })
        );

        let polygonSeries = chart.series.push(
          am5map.MapPolygonSeries.new(root, {})
        );
        polygonSeries.data.push(x.data);
        polygonSeries.mapPolygons.template.setAll({
          fill: am5.color(0xdadada)
        });
        chart.appear(1000, 100);
      },

      resize: function (width, height) {
        // TODO: code to re-render the widget with a new size
      }
    };
  }
});
