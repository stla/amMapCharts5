HTMLWidgets.widget({
  name: "amMapChart",

  type: "output",

  factory: function (el, width, height) {
    let addSeries = function (root, chart, xseries) {
      let data = {};
      if(xseries.geojson) {
        data = {
          geoJSON: JSON.parse(xseries.geojson)
        };
      }
      let series = chart.series.push(am5map[xseries.type].new(root, data));
      if(xseries.data) {
        series.data.setAll(xseries.data);
      }
      let tmplt;
      switch (xseries.type) {
        case "MapPolygonSeries":
          tmplt = "mapPolygons";
          break;
        case "MapLineSeries":
          tmplt = "mapLines";
          break;
        default:
          tmplt = "xxx";
      }
      series[tmplt].template.setAll(xseries.options);
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
