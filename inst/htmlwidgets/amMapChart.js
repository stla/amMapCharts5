HTMLWidgets.widget({
  name: "amMapChart",

  type: "output",

  factory: function (el, width, height) {
    let addSeries = function (root, chart, xseries) {
      let options = xseries.options;
      if (xseries.type === "lineWithPlane") {
        let lineSeries = chart.series.push(
          am5map["MapLineSeries"].new(root, options)
        );
        lineSeries["mapLines"].template.setAll(xseries.style);
        let route = lineSeries.pushDataItem(xseries.dataItem);
        let pointSeries = chart.series.push(
          am5map.MapPointSeries.new(root, {})
        );
        pointSeries.bullets.push(function () {
          let container = am5.Container.new(root, {});
          container.children.push(
            am5.Graphics.new(root, {
              svgPath:
                "m2,106h28l24,30h72l-44,-133h35l80,132h98c21,0 21,34 0,34l-98,0 -80,134h-35l43,-133h-71l-24,30h-28l15,-47",
              scale: 0.06,
              centerY: am5.p50,
              centerX: am5.p50,
              fill: am5.color(0x000000)
            })
          );
          return am5.Bullet.new(root, { sprite: container });
        });
        let plane = pointSeries.pushDataItem({
          lineDataItem: route,
          positionOnLine: xseries.planePosition,
          autoRotate: true
        });
      } else {
        if (xseries.geojson) {
          options.geoJSON = JSON.parse(xseries.geojson);
        }
        let series = chart.series.push(am5map[xseries.type].new(root, options));
        if (xseries.data) {
          series.data.setAll(xseries.data);
        }
        if (
          xseries.type === "MapPolygonSeries" ||
          xseries.type === "MapLineSeries"
        ) {
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
          series[tmplt].template.setAll(xseries.style);
        } else if (xseries.type === "MapPointSeries") {
          series.bullets.push(function () {
            return am5.Bullet.new(root, {
              sprite: am5[xseries.bullet.shape].new(root, {
                ...xseries.bullet.options
              })
            });
          });
        }
      }
    };

    return {
      renderValue: function (x) {
        let root = am5.Root.new(el.id);

        let chart = root.container.children.push(
          am5map.MapChart.new(root, {
            projection: am5map[x.projection]()
          })
        );

        chart.set("zoomControl", am5map.ZoomControl.new(root, {}));

        for (let xseries of x.series) {
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
