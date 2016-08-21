"use strict";
function doRender(require) {
    require(["src/composite/Dermatology", "src/other/Comms", "src/layout/Grid", "src/other/Persist", "src/common/Utility"], function (Dermatology, Comms, Grid, Persist, Utility) {
        var dermatology = new Dermatology()
            .target("placeholder")
            .render(function (w) {
                grid = w;
            })
        ;

        var espConnection = Comms.createESPConnection(espUrl);

        var toggleProperties = dermatology.toggleProperties;
        dermatology.toggleProperties = function () {
            toggleProperties.apply(dermatology, arguments);
            if (!dermatology._showProperties) {
                var persistStr = Persist.serialize(dermatology.widget());
                espConnection.appData("HPCC-VizBundle", "persist", persistStr);
            }
        };

        var persistPromise = espConnection.appData("HPCC-VizBundle", "persist").then(function (persistStr) {
            if (persistStr) {
                return Persist.create(persistStr);
            }
            return Promise.resolve(null);
        });

        function fetchData(id) {
            return espConnection.result(id).then(function (response) {
                var retVal = {};
                if (response && response.length) {
                    var meta = response[0];
                    retVal.classID = meta.classid;
                    retVal.id = id;
                    retVal.properties = meta.properties;
                    retVal.resultName = meta.resultname;
                }
                return espConnection.result(retVal.resultName).then(function (response) {
                    retVal.columns = [];
                    retVal.data = [];
                    if (response && response.length) {
                        var colIdx = {};
                        response.forEach(function (row, rowIdx) {
                            var rowArr = [];
                            for (var key in row) {
                                if (rowIdx === 0) {
                                    colIdx[key] = retVal.columns.length;
                                    retVal.columns.push(key);
                                }
                                rowArr[colIdx[key]] = row[key];
                            }
                            retVal.data.push(rowArr);
                        });
                    }
                    return retVal
                });
            });
        }
        var vizPromise = espConnection.fetchResultNames().then(function (response) {
            var promises = []
            for (var key in response) {
                if (Utility.endsWith(key, "__hpcc_visualization")) {
                    promises.push(fetchData(key));
                }
            }
            return Promise.all(promises);
        });

        Promise.all([persistPromise, vizPromise]).then(function (promises) {
            var grid = promises[0];
            if (grid) {
                dermatology
                    .widget(grid)
                    .render()
                ;
            } else {
                var contentPromises = [];
                promises[1].forEach(function (viz) {
                    contentPromises.push(Utility.requireWidget(viz.classID).then(function (Widget) {
                        var retVal = new Widget()
                            .id(viz.id)
                            .columns(viz.columns)
                            .data(viz.data)
                        ;
                        viz.properties.forEach(function(property){
                            if (typeof (retVal[property.key]) === "function") {
                                retVal[property.key](property.value);
                            }
                        });
                        return retVal;
                    }))
                });
                Promise.all(contentPromises).then(function (content) {
                    var grid = new Grid();
                    content.forEach(function (widget, i) {
                        grid.setContent(0, i, widget);
                    });
                    dermatology
                        .widget(grid)
                        .render()
                    ;
                });
            }
        });
            /*

            if (widget) {
                dermatology
                    .widget(widget
                        .columns(viz.columns)
                        .data(viz.data))
                    .render()
                ;
            } else if (viz) {
                Utility.requireWidget(viz.classID).then(function (Widget) {
                    dermatology
                        .widget(new Widget()
                            .columns(viz.columns)
                            .data(viz.data))
                        .render()
                    ;
                });
            } else {
                console.log("no visualization info found");
            }
        });
        */
    });
}
