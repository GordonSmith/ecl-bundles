"use strict";
function requireApp(require, callback) {
    require(["src/composite/Dermatology", "src/other/ESP", "src/layout/Grid", "src/other/Persist", "src/common/Utility"], function (Dermatology, ESP, Grid, Persist, Utility) {
        function WUWidget(espWorkunit, wuResult) {
            this._espWorkunit = espWorkunit;
            this._metaResult = wuResult;
            this._id = this._metaResult.name();
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

        WUWidget.prototype.dataSource = function (_) {
            if (!arguments.length) return this._dataSource;
            this._dataSource = _;
            //            this._dataResult = this._espWorkunit.result(_);
            return this;
        };

        WUWidget.prototype.resultName = function (_) {
            if (!arguments.length) return this._resultName;
            this._resultName = _;
//            this._dataResult = this._espWorkunit.result(_);
            return this;
        };

        WUWidget.prototype.columns = function (_) {
            if (!arguments.length) return this._columns;
            this._columns = _;
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

        WUWidget.prototype.resolve = function () {
            var context = this;
            return this._metaResult.query().then(function (result) {
                if (result && result.length) {
                    context
                        .classID(result[0].classid)
                        .properties(result[0].properties)
                        .filteredBy(result[0].filteredby)
                        .dataSource(result[0].datasource)
                        .resultName(result[0].resultname)
                    ;
                }
                return context.resolveWidget().then(function () {
                    return context;
                });
            });
        };

        WUWidget.prototype.refreshData = function (selections) {
            var filterRequest = {};
            var isFiltered = false;
            var filterCount = false;
            this.filteredBy().forEach(function (filter) {
                var selection = selections[filter.source + "__hpcc_visualization"];
                if (selection) {
                    ++filterCount;
                    filter.mappings.forEach(function (mapping) {
                        filterRequest[mapping.value.toLowerCase()] = selection[mapping.key.toLowerCase()];
                    });
                }
                isFiltered = true;
            }, this);
            if (!isFiltered || filterCount > 0) {
                var context = this;
                var dataResult = this._espWorkunit.result(this.dataSource(), this.resultName());
                dataResult.query(null, filterRequest).then(function (result) {
                    result = ESP.flattenResult(result);
                    context.widget()
                        .columns(result.columns)
                        .data(result.data)
                        .lazyRender()
                    ;
                });
            } else {
                this.widget()
                    .columns([])
                    .data([])
                    .lazyRender()
                ;
            }
        }

        //  ===================================================================
        function WUDashboard(espUrl) {
            this._espUrl = espUrl;
            this._espWorkunit = ESP.createESPConnection(this._espUrl);
            this._wuWidgets = [];
            this._wuWidgetMap = {};
            this._wuDashSel = {};
        }

        WUDashboard.prototype.submitPersist = function () {
            if (this.grid) {
                var persistStr = Persist.serialize(this.grid);
                this._espWorkunit.appData("HPCC-VizBundle", "persist", persistStr);
            }
        };

        WUDashboard.prototype.fetchPersist = function () {
            return this._espWorkunit.appData("HPCC-VizBundle", "persist").then(function (persistStr) {
                if (persistStr) {
                    return Persist.create(persistStr);
                }
                return Promise.resolve(null);
            });
        };

        WUDashboard.prototype.fetchWUWidgets = function () {
            var context = this;
            return this._espWorkunit.results().then(function (results) {
                var promises = []
                results.filter(function (result) {
                    return Utility.endsWith(result.name(), "__hpcc_visualization");
                }).map(function (result) {
                    var wuWidget = new WUWidget(context._espWorkunit, result);
                    promises.push(wuWidget.resolve());
                });
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
                var maxColPos = Math.ceil(Math.sqrt(metas.length));
                metas.forEach(function (wuWidget, i) {
                    var widget = context.grid.getContent(wuWidget.id());
                    if (!widget) {
                        var rowPos = 0;
                        var colPos = 0;
                        var cellDensity = context.grid.cellDensity();
                        widget = wuWidget.createWidget();
                        while (context.grid.getCell(rowPos * cellDensity, colPos * cellDensity)) {
                            ++colPos
                            if (colPos >= maxColPos) {
                                colPos = 0;
                                ++rowPos;
                            }
                        }
                        context.grid.setContent(rowPos, colPos, widget);
                    }
                    widget
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

        WUDashboard.prototype.refresh = function () {
            this._wuWidgets.forEach(function (wuWidget) {
                wuWidget.refreshData(this._wuDashSel);
            }, this);
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
                        .render(function (w) {
                            context.wuDashboard.refresh();
                        })
                    ;
                });
            }
        };

        callback(App);
    });
};