"use strict";
(function (root, factory) {
    if (typeof define === "function" && define.amd) {
        define(["d3", "src/common/SVGWidget", "src/layout/Grid", "src/common/Icon", "src/other/Comms", "src/other/PropertyEditor", "css!./Page"], factory);
    }
}(this, function (d3, SVGWidget, Grid, Icon, Comms, PropertyEditor) {
    function Page() {
        Grid.call(this);

        this._grid = new Grid()
        ;

        this._propEditor = new PropertyEditor()
            .show_settings(true)
            .widget(this._grid)
        ;

        this._espUrl = window.location.href;
        switch (window.location.hostname) {
            //  Used for debugging JS
            case "localhost":
                this._espUrl = "http://192.168.3.22:8010/WsWorkunits/res/W20160724-080751/res_Chart2D/index.html";
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
            new Promise(function (resolve, reject) {
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
                xhr.open("POST", context._wuUpdate.url(), true);
                //xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
                xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                /*
                var data = new FormData();
                data.append("Wuid", context._espConnection.wuid())
                data.append("ApplicationValues.ApplicationValue.0.Application", "aababa")
                data.append("ApplicationValues.ApplicationValue.0.Name", "test")
                data.append("ApplicationValues.ApplicationValue.0.value", "008")
                data.append("ApplicationValues.ApplicationValue.itemcount", 1)
                xhr.send(data);
                */
                xhr.send("Wuid=" + context._espConnection.wuid() + "&" +
                    "ApplicationValues.ApplicationValue.0.Application=aababa" + "&" +
                    "ApplicationValues.ApplicationValue.0.Name=test" + "&" +
                    "ApplicationValues.ApplicationValue.0.value=008" + "&" +
                    "ApplicationValues.ApplicationValue.itemcount=1");
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

    return Page;
}));
