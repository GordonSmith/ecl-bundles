"use strict";
function requireApp(require, callback) {
    require(["src/composite/Dermatology", "src/other/Comms", "src/layout/Grid", "src/other/Persist", "src/common/Utility"], function (Dermatology, Comms, Grid, Persist, Utility) {
        function WUWidget(espConnection, id) {
            this._espConnection = espConnection;
            this._id = id;
            this._columns = [];
            this._data = [];
            this._filteredBy = [];
        }

        WUWidget.prototype.classID = function (_) {
            if (!arguments.length) return this._classID;
            this._classID = _;
            return this;
        };

        WUWidget.prototype.widgetClass = function (_) {
            if (!arguments.length) return this._widgetClass;
            this._widgetClass = _;
            return this;
        };

        WUWidget.prototype.widget = function (_) {
            if (!arguments.length) return this._widget;
            this._widget = _;
            return this;
        };

        WUWidget.prototype.id = function (_) {
            if (!arguments.length) return this._id;
            this._id = _;
            return this;
        };

        WUWidget.prototype.properties = function (_) {
            if (!arguments.length) return this._properties;
            this._properties = _;
            return this;
        };

        WUWidget.prototype.filteredBy = function (_) {
            if (!arguments.length) return this._filteredBy;
            this._filteredBy = _ || [];
            return this;
        };

        WUWidget.prototype.resultName = function (_) {
            if (!arguments.length) return this._resultName;
            this._resultName = _;
            return this;
        };

        WUWidget.prototype.columns = function (_) {
            if (!arguments.length) return this._columns;
            this._columns = _;
            return this;
        };

        WUWidget.prototype.data = function (_) {
            if (!arguments.length) return this._data;
            this._data = _;
            return this;
        };

        WUWidget.prototype.createWidget = function () {
            var widget = new this._widgetClass()
                .id(this.id())
            ;
            this.properties().forEach(function (property) {
                if (typeof (widget[property.key]) === "function") {
                    widget[property.key](property.value);
                }
            });
            return widget;
        };

        WUWidget.prototype.resolveWidget = function () {
            var context = this;
            return Utility.requireWidget(context.classID()).then(function (Widget) {
                context.widgetClass(Widget);
            });
        };
        WUWidget.prototype.resolveData = function () {
            var context = this;
            return context._espConnection.result(context.resultName()).then(function (response) {
                var columns = [];
                var data = [];
                if (response && response.length) {
                    var colIdx = {};
                    response.forEach(function (row, rowIdx) {
                        var rowArr = [];
                        for (var key in row) {
                            if (rowIdx === 0) {
                                colIdx[key] = columns.length;
                                columns.push(key);
                            }
                            rowArr[colIdx[key]] = row[key];
                        }
                        data.push(rowArr);
                    });
                }
                context
                    .columns(columns)
                    .data(data)
                ;
                return context;
            });
        };

        WUWidget.prototype.resolve = function () {
            var context = this;
            return this._espConnection.result(this._id).then(function (response) {
                if (response && response.length) {
                    context
                        .classID(response[0].classid)
                        .properties(response[0].properties)
                        .filteredBy(response[0].filteredby)
                        .resultName(response[0].resultname)
                    ;
                }
                var widgetPromise = context.resolveWidget();
                var dataPromise = context.resolveData();
                return Promise.all([widgetPromise, dataPromise]).then(function (promises) {
                    return context;
                });
            });
        };

        WUWidget.prototype.refreshData = function (selections) {
            var filterValues = [];
            this.filteredBy().forEach(function (filter) {
                var selection = selections[filter.source + "__hpcc_visualization"];
                if (selection) {
                    var columns = this.columns();
                    filter.mappings.Row.forEach(function (mapping) {
                        filterValues.push({
                            idx: columns.indexOf(mapping.value.toLowerCase()),
                            value: selection[mapping.key.toLowerCase()]
                        });
                    });
                }
            }, this);
            this.widget()
                .data(this.data().filter(function (row) {
                    var exclude = filterValues.some(function (filter) {
                        if (row[filter.idx] !== filter.value) {
                            return true;
                        }
                        return false;
                    });
                    return !exclude;
                }))
                .lazyRender()
            ;
        }

        //  ===================================================================
        function WUDashboard(espUrl) {
            this._espUrl = espUrl;
            this._espConnection = Comms.createESPConnection(this._espUrl);
            this._wuWidgets = [];
            this._wuWidgetMap = {};
            this._wuDashSel = {};
        }

        WUDashboard.prototype.submitPersist = function () {
            if (this.grid) {
                var persistStr = Persist.serialize(this.grid);
                this._espConnection.appData("HPCC-VizBundle", "persist", persistStr);
            }
        };

        WUDashboard.prototype.fetchPersist = function () {
            return this._espConnection.appData("HPCC-VizBundle", "persist").then(function (persistStr) {
                if (persistStr) {
                    return Persist.create(persistStr);
                }
                return Promise.resolve(null);
            });
        };

        WUDashboard.prototype.fetchWUWidgets = function () {
            var context = this;
            return this._espConnection.fetchResultNames().then(function (response) {
                var promises = []
                for (var key in response) {
                    if (Utility.endsWith(key, "__hpcc_visualization")) {
                        var wuWidget = new WUWidget(context._espConnection, key);
                        promises.push(wuWidget.resolve());
                    }
                }
                return Promise.all(promises);
            });
        };

        WUDashboard.prototype.createGrid = function () {
            var context = this;
            return Promise.all([this.fetchPersist(), this.fetchWUWidgets()]).then(function (promises) {
                context.grid = promises[0];
                if (!context.grid) {
                    context.grid = new Grid();
                }

                //  Create Widgets  ---
                context._wuWidgets = [];
                context._wuWidgetMap = {};
                var metas = promises[1];
                metas.forEach(function (wuWidget, i) {
                    var widget = context.grid.getContent(wuWidget.id);
                    var colPos = context.grid.content().length;
                    if (!widget) {
                        widget = wuWidget.createWidget();
                        while (context.grid.getContent(0, colPos)) {
                            ++colPos
                        }
                        context.grid.setContent(0, colPos, widget);
                    }
                    widget
                        .columns(wuWidget.columns())
                        .data(wuWidget.data())
                        .on("click", function (row, col, sel) {
                            context.refreshFilters(this.id(), row, col, sel);
                        });
                    ;
                    if (wuWidget.filteredBy().length === 0) {
                    }
                    widget._wuMeta = wuWidget;
                    wuWidget.widget(widget);
                    context._wuWidgets.push(wuWidget);
                    context._wuWidgetMap[wuWidget.id] = wuWidget;
                });

                return context.grid;
            });
        };

        WUDashboard.prototype.refreshFilters = function (id, row, col, sel) {
            if (sel) {
                this._wuDashSel[id] = row;
            } else {
                delete this._wuDashSel[id];
            }
            this._wuWidgets.forEach(function (wuWidget) {
                wuWidget.filteredBy().forEach(function (filter) {
                    if (id === filter.source + "__hpcc_visualization") {
                        wuWidget.refreshData(this._wuDashSel);
                    }
                }, this);
            }, this);
        };

        //  ===================================================================
        function App() {
            Dermatology.call(this);
        }
        App.prototype = Object.create(Dermatology.prototype);
        App.prototype.constructor = App;
        App.prototype._class += " App";

        App.prototype.espUrl = function (_) {
            if (!arguments.length) return this._espUrl;
            this._espUrl = _;
            return this;
        };

        App.prototype.toggleProperties = function () {
            Dermatology.prototype.toggleProperties.apply(this, arguments);
            if (!this._showProperties) {
                this.wuDashboard.submitPersist();
            }
        };

        App.prototype.update = function () {
            Dermatology.prototype.update.apply(this, arguments);
            if (this._prevEspUrl !== this.espUrl()) {
                this._prevEspUrl = this.espUrl();
                this.wuDashboard = new WUDashboard(this.espUrl());
                var context = this;
                this.wuDashboard.createGrid().then(function (grid) {
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