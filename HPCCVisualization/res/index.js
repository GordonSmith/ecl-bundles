"use strict";
function requireApp(require, callback) {
    require(["src/composite/Dermatology", "src/other/Comms", "src/layout/Grid", "src/other/Persist", "src/common/Utility"], function (Dermatology, Comms, Grid, Persist, Utility) {
        function App() {
            Dermatology.call(this);
        }
        App.prototype = Object.create(Dermatology.prototype);
        App.prototype.constructor = App;
        App.prototype._class += " App";

        App.prototype.espUrl = function (_) {
            if (!arguments.length) return this._espUrl;
            this._espUrl = _;
            this._espConnection = Comms.createESPConnection(this._espUrl);
            return this;
        };

        App.prototype.toggleProperties = function () {
            Dermatology.prototype.toggleProperties.apply(this, arguments);
            if (!this._showProperties) {
                var persistStr = Persist.serialize(this.widget());
                this._espConnection.appData("HPCC-VizBundle", "persist", persistStr);
            }
        };

        App.prototype.fetchPersist = function (id) {
            return this._espConnection.appData("HPCC-VizBundle", "persist").then(function (persistStr) {
                if (persistStr) {
                    return Persist.create(persistStr);
                }
                return Promise.resolve(null);
            });
        };

        App.prototype.fetchData = function (id) {
            var context = this;
            return this._espConnection.result(id).then(function (response) {
                var retVal = {};
                if (response && response.length) {
                    var meta = response[0];
                    retVal.classID = meta.classid;
                    retVal.id = id;
                    retVal.properties = meta.properties;
                    retVal.resultName = meta.resultname;
                }
                var widgetPromise = Utility.requireWidget(retVal.classID).then(function (Widget) {
                    retVal.widgetClass = Widget;
                });
                var dataPromise = context._espConnection.result(retVal.resultName).then(function (response) {
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
                return Promise.all([widgetPromise, dataPromise]).then(function (promises) {
                    return retVal;
                });
            });
        };

        App.prototype.fetchVisualizations = function () {
            var context = this;
            return this._espConnection.fetchResultNames().then(function (response) {
                var promises = []
                for (var key in response) {
                    if (Utility.endsWith(key, "__hpcc_visualization")) {
                        promises.push(context.fetchData(key));
                    }
                }
                return Promise.all(promises);
            });
        };

        App.prototype.update = function () {
            Dermatology.prototype.update.apply(this, arguments);
            if (this._prevEspUrl !== this.espUrl()) {
                this._prevEspUrl = this.espUrl();

                var context = this;
                Promise.all([this.fetchPersist(), this.fetchVisualizations()]).then(function (promises) {
                    var grid = promises[0];
                    if (!grid) {
                        grid = new Grid();
                    }

                    var metas = promises[1];
                    metas.forEach(function (meta, i) {
                        var widget = grid.getContent(meta.id);
                        var colPos = grid.content().length;
                        if (!widget) {
                            widget = new meta.widgetClass()
                                .id(meta.id)
                            ;
                            meta.properties.forEach(function (property) {
                                if (typeof (widget[property.key]) === "function") {
                                    widget[property.key](property.value);
                                }
                            });
                            while (grid.getContent(0, colPos)) {
                                ++colPos
                            }
                            grid.setContent(0, colPos, widget);
                        }
                        widget
                            .columns(meta.columns)
                            .data(meta.data)
                        ;
                    });

                    context
                        .widget(grid)
                        .lazyRender()
                    ;
                });
            }
        };

        callback(App);
    });
};