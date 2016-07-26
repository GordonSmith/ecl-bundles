"use strict";
(function (root, factory) {
    if (typeof define === "function" && define.amd) {
        define(["d3", "src/common/SVGWidget", "src/layout/Grid", "src/common/Icon", "src/marshaller/HTML", "src/chart/Column", "src/other/Comms", "src/other/Persist", "src/other/PropertyEditor", "css!./Page"], factory);
    }
}(this, function (d3, SVGWidget, Grid, Icon, HTML, Column, Comms, Persist, PropertyEditor) {
    function Page() {
        Grid.call(this);

        this._propEditor = new PropertyEditor()
            .show_settings(true)
        ;

        this._espUrl = window.location.href;
        switch (window.location.hostname) {
            //  Used for debugging JS
            case "localhost":
                this._espUrl = "http://192.168.3.22:8010/WsWorkunits/res/W20160726-140121/res/index.html";
                break;
        }
        this._espConnection = Comms.createESPConnection(this._espUrl);

        var urlParts = this._espUrl.split("/WsWorkunits/");
        urlParts.pop();
        urlParts.push("WUInfo.json");
        this._wuInfo = new Comms.Basic()
            .url(urlParts.join("/WsWorkunits/"))
        ;
        urlParts.pop();
        urlParts.push("WUUpdate.json");
        this._wuUpdate = new Comms.Basic()
            .url(urlParts.join("/WsWorkunits/"))
        ;
    }
    Page.prototype = Object.create(Grid.prototype);
    Page.prototype.constructor = Page;
    Page.prototype._class += " res_Page";

    Page.prototype.publish("showToolbar", true, "boolean", "Show Toolbar");

    Page.prototype.serialize = function (obj) {
        var str = [];
        for (var key in obj) {
            if (obj.hasOwnProperty(key)) {
                str.push(encodeURIComponent(key) + "=" + encodeURIComponent(obj[key]));
            }
        }
        return str.join("&");
    };

    Page.prototype.send = function (url, method, request) {
        var context = this;
        return new Promise(function (resolve, reject) {
            var xhr = new XMLHttpRequest();
            xhr.onload = function (e) {
                if (this.status >= 200 && this.status < 300) {
                    resolve(JSON.parse(this.response));
                }
                else {
                    reject(Error(this.statusText));
                }
            };
            xhr.onerror = function () {
                reject(Error(this.statusText));
            };
            xhr.open(method, url, true);
            xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xhr.setRequestHeader("Access-Control-Allow-Origin", "*");
            //xhr.setRequestHeader("Access-Control-Allow-Headers", "Content-Type");
            //xhr.setRequestHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
            xhr.send(context.serialize(request));
        });
    };

    Page.prototype.post = function (url, request) {
        return this.send(url, "POST", request);
    };

    Page.prototype.get = function (url, request) {
        return this.send(url, "GET", request);
    };

    Page.prototype.wuInfo = function (request) {
        request = request || {};
        request.Wuid = this._espConnection.wuid();
        request.TruncateEclTo64k = true;
        request.IncludeExceptions = false;
        request.IncludeGraphs = false;
        request.IncludeSourceFiles = false;
        request.IncludeResults = true;
        request.IncludeResultsViewNames = false;
        request.IncludeVariables = false;
        request.IncludeTimers = false;
        request.IncludeResourceURLs = false;
        request.IncludeDebugValues = false;
        request.IncludeApplicationValues = true;
        request.IncludeWorkflows = false;
        request.IncludeXmlSchemas = false;
        request.SuppressResultSchemas = true;
        return this.post(this._wuInfo.url(), request);
    };
        
    Page.prototype.toggleProperties = function () {
        this._showProperties = !this._showProperties;
        this._buttonShowProps.element().classed("show", this._showProperties);
        this._grid.designMode(this._showProperties);
        this
            .setContent(0, 2, this._showProperties ? this._propEditor :  null)
            .render()
        ;
        if (!this._showProperties) {
            var context = this;
            this.post(context._wuUpdate.url(), {
                "Wuid": context._espConnection.wuid(),
                "ApplicationValues.ApplicationValue.0.Application": "HPCC-VizBundle",
                "ApplicationValues.ApplicationValue.0.Name": "persist",
                "ApplicationValues.ApplicationValue.0.Value": Persist.serialize(context._grid),
                "ApplicationValues.ApplicationValue.itemcount": 1
            });
        }
        return this;
    };

    Page.prototype.createESPConnection = function () {
        return Comms.createESPConnection(this._espUrl);
    };

    Page.prototype.enter = function (domNode, element) {
        Grid.prototype.enter.apply(this, arguments);
        this.setContent(0, 0, this._grid, null, 1, 2);
    };

    Page.prototype.update = function (domNode, element) {
        Grid.prototype.update.apply(this, arguments);
        var context = this;
        var toolbar = element.selectAll(".toolbar").data(this.showToolbar() ? ["dummy"] : []);
        var iconDiameter = 24;
        var faCharHeight = 14;
        toolbar.enter().append("div")
            .attr("class", "toolbar")
            .style("height", iconDiameter + 8 + "px")
            .each(function (d) {
                context._buttonShowProps = new Icon()
                    .target(this)
                    .faChar("P")
                    .shape("square")
                    .diameter(iconDiameter)
                    .paddingPercent((1 - faCharHeight / iconDiameter) * 100)
                    .on("click", function () {
                        context.toggleProperties();
                    })
                ;
                context._buttonLast = context._buttonShowProps;
            })
        ;
        if (this.showToolbar()) {
            this._buttonShowProps
                .x(this.width() - iconDiameter / 2 - 4)
                .y(iconDiameter / 2 + 4)
                .render()
            ;
        }
        toolbar.exit()
            .each(function () {
                context._buttonShowProps
                    .target(null)
                    .render()
                ;
                delete context._buttonShowProps;
            })
            .remove()
        ;
    };

    Page.prototype.getPersist = function () {
        return this.wuInfo().then(function (response) {
            var persistString;
            if (response.WUInfoResponse && response.WUInfoResponse.Workunit && response.WUInfoResponse.Workunit.ApplicationValues && response.WUInfoResponse.Workunit.ApplicationValues.ApplicationValue) {
                response.WUInfoResponse.Workunit.ApplicationValues.ApplicationValue.filter(function (row) {
                    return row.Application === "HPCC-VizBundle" && row.Name === "persist";
                }).forEach(function (row) {
                    persistString = row.Value;
                });
            }
            return persistString;
        }, function () {
            return "";
        });
    };

    Page.prototype.getResults = function () {
        var connection = this.createESPConnection();
        return new Promise(function (resolve, reject) {
            connection.send({}, function (response) {
                var retVal = {
                };
                for (var key in response) {
                    if (response[key + "_chart2d_props"]) {
                        retVal[key] = {
                            data: response[key].map(function (row) { return [row.label, row.value]; }),
                            props: response[key + "_chart2d_props"]
                        }
                    }
                }
                resolve(retVal);
            });
        });
    };

    Page.prototype.createWidgets = function (results) {
        var context = this;
        return new Promise(function (resolve, reject) {
            var grid = new Grid();
            var widgetCount = 0;
            for (var key in results) {
                var column = new Column();
                column
                    .id(key)
                    .columns(["Location", "Total"])
                    .data(results[key].data)
                ;
                results[key].props.forEach(function (row) {
                    if (column[row.key]) {
                        column[row.key](row.value);
                    }
                });
                grid.setContent(widgetCount, 0, column);
                ++widgetCount;
            }
            resolve(grid);
        });
    };

    Page.prototype.createDDL = function () {
        var connection = this.createESPConnection();
        var context = this;
        return new Promise(function (resolve, reject) {
            connection.send({}, function (response) {
                for (var key in response) {
                    if (response[key + "_DDL"]) {
                        resolve(retVal);
                        break;
                    }
                }
            });
        });
    };


    Page.prototype.deserializeWidgets = function (persist) {
        var context = this;
        return new Promise(function (resolve, reject) {
            Persist.create(persist, function (grid) {
                context.getResults().then(function (results) {
                    for (var key in results) {
                        var widget = grid.getContent(key);
                        if (widget) {
                            widget.data(results[key].data);
                        }
                    }
                    resolve(grid);
                })
            });
        });
    };

    Page.prototype.createMarshaller = function () {
        var context = this;
        return new Promise(function (resolve, reject) {
            resolve(new HTML()
                .ddlUrl(context._espUrl + "?ResultName=Dashboard_DDL")
            );
        });
    };

    Page.prototype.render = function (callback) {
        if (this._grid) {
            return Grid.prototype.render.apply(this, arguments);
        }
        var context = this;
        var args = arguments;

        this.getPersist().then(function (persist) {
            var promise = persist ? context.deserializeWidgets(persist) : context.createMarshaller();
            promise.then(function (grid) {
                context._grid = grid;
                context._propEditor
                    .widget(context._grid)
                ;
                return Grid.prototype.render.apply(context, args);
            });
        });
        return this;
    };
    return Page;
}));
