HTMLWidgets.widget({
  name: "amMapChart",

  type: "output",

  factory: function (el, width, height) {
    let inShiny = HTMLWidgets.shinyMode;

    let am5color = function(style) {
      if(style.fill) {
        style.fill = am5.color(style.fill);
      }
      if(style.stroke) {
        style.stroke = am5.color(style.stroke);
      }
    };

    let addSeries = function (root, chart, xseries) {
      let options = xseries.options;
      if (xseries.type === "lineWithPlane") {
        let lineSeries = chart.series.push(
          am5map["MapLineSeries"].new(root, options)
        );
        let style = xseries.style;
        am5color(style);
        lineSeries["mapLines"].template.setAll(style);
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
          let style = xseries.style;
          am5color(style);
          series[tmplt].template.setAll(style);
        } else if (xseries.type === "MapPointSeries") {
          let bulletOptions = xseries.bullet.options;
          am5color(bulletOptions);
          series.bullets.push(function () {
            return am5.Bullet.new(root, {
              sprite: am5[xseries.bullet.shape].new(root, {
                ...bulletOptions
              })
            });
          });
        } else if (xseries.type === "ClusteredPointSeries") {
          let cluster = xseries.cluster;
          series.set("clusteredBullet", function (root) {
            let container = am5.Container.new(root, {});
            let circle1 = container.children.push(
              am5.Circle.new(root, {
                radius: cluster.radius,
                tooltipY: 0,
                fill: am5.color(cluster.color)
              })
            );
            let circle2 = container.children.push(
              am5.Circle.new(root, {
                radius: cluster.radius + 4,
                fillOpacity: 0.3,
                tooltipY: 0,
                fill: am5.color(cluster.color)
              })
            );
            let circle3 = container.children.push(
              am5.Circle.new(root, {
                radius: cluster.radius + 8,
                fillOpacity: 0.3,
                tooltipY: 0,
                fill: am5.color(cluster.color)
              })
            );
            let label = container.children.push(
              am5.Label.new(root, {
                centerX: am5.p50,
                centerY: am5.p50,
                fill: cluster.labelColor,
                populateText: true,
                fontSize: cluster.fontSize,
                text: "{value}"
              })
            );
            container.events.on("click", function (e) {
              series.zoomToCluster(e.target.dataItem);
            });
            return am5.Bullet.new(root, {
              sprite: container
            });
          });
          let bulletOptions = xseries.bullet.options;
          am5color(bulletOptions);
          series.bullets.push(function () {
            return am5.Bullet.new(root, {
              sprite: am5[xseries.bullet.shape].new(root, {
                ...bulletOptions
              })
            });
          });
        }
      }
    };

    return {
      renderValue: function (x) {
        let root = am5.Root.new(el.id);

        let exporting = am5plugins_exporting.Exporting.new(root, {
          menu: am5plugins_exporting.ExportingMenu.new(root, {}),
          htmlOptions: {
            disabled: true
          },
          pdfOptions: {
            disabled: true
          },
          pdfdataOptions: {
            disabled: true
          },
          csvOptions: {
            disabled: true
          },
          xlsxOptions: {
            disabled: true
          },
          jsonOptions: {
            disabled: true
          }
        });

        let chart = root.container.children.push(
          am5map.MapChart.new(root, {
            projection: am5map[x.projection]()
          })
        );

        chart.set("zoomControl", am5map.ZoomControl.new(root, {}));

        if (x.grid) {
          let graticuleSeries = chart.series.unshift(
            am5map.GraticuleSeries.new(root, {
              step: x.grid.step
            })
          );
          graticuleSeries.mapLines.template.setAll({
            stroke: am5.color(x.grid.color),
            strokeOpacity: x.grid.opacity
          });
        }

        for (let xseries of x.series) {
          addSeries(root, chart, xseries);
        }

        chart.appear(1000, 100);

        if (inShiny) {
          Shiny.addCustomMessageHandler("update_" + el.id, function (a) {
            chart.set("projection", am5map[a.projection]());
          });
        }
      },

      resize: function (width, height) {
        // TODO: code to re-render the widget with a new size
      }
    };
  }
});
