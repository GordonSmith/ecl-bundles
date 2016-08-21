function doRender(require) {
    require(["src/composite/Dermatology", "src/other/Comms", "src/other/Persist", "src/common/Utility"], function (Dermatology, Comms, Persist, Utility) {
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
            return new Promise(function (resolve, reject) {
                var metaPromise = espConnection.result(id + "__hpcc_visualization").then(function (response) {
                    retVal = {};
                    if (response && response.length) {
                        var meta = response[0];
                        retVal.classID = meta.classid;
                        retVal.properties = meta.properties;
                    }
                    return retVal;
                });
                var dataPromise = espConnection.result(id).then(function (response) {
                    var retVal = {
                        columns: [],
                        data: []
                    };
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
                        return retVal
                    }
                });
                resolve(Promise.all([metaPromise, dataPromise]).then(function (responses) {
                    var meta = responses[0];
                    meta.columns = responses[1].columns;
                    meta.data = responses[1].data;
                    return meta;
                }));
            });
        }
        vizPromise = espConnection.fetchResultNames().then(function (response) {
            var promises = []
            for (var key in response) {
                if (response[key + "__hpcc_visualization"]) {
                    promises.push(fetchData(key));
                }
            }
            return Promise.all(promises);
        });

        Promise.all([persistPromise, vizPromise]).then(function (promises) {
            var widget = promises[0];
            var viz = promises[1][0];
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
    });
}
