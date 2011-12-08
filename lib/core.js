(function() {
  var StartappCore, express, _;
  var __slice = Array.prototype.slice;

  express = require("express");

  _ = require("underscore");

  StartappCore = (function() {
    var method, _fn, _i, _len, _ref;
    var _this = this;

    function StartappCore(req, res, next) {
      this.req = req;
      this.res = res;
      this.next = next;
    }

    StartappCore.environment = function(app) {};

    StartappCore.set_routes = function(prefix, app) {
      var action, controller, method, path, _i, _len, _ref, _ref2, _ref3, _results;
      _ref = this._routes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        _ref2 = _ref[_i], method = _ref2[0], path = _ref2[1], controller = _ref2[2], action = _ref2[3];
        if (method === "mount") {
          _results.push(controller.set_routes(prefix + path, app));
        } else {
          if (action == null) {
            _ref3 = [this, controller], controller = _ref3[0], action = _ref3[1];
          }
          if (path === "/" && prefix !== "") path = "";
          _results.push(app[method](prefix + path, controller.action(action)));
        }
      }
      return _results;
    };

    StartappCore.action = function(name) {
      var _this = this;
      return function(req, res, next) {
        var controller;
        controller = new _this(req, res, next);
        if (typeof name === "function") {
          return name.call(controller);
        } else if (controller[name] != null) {
          return controller[name]();
        } else {
          return next();
        }
      };
    };

    StartappCore.mixin = function(obj) {
      var key, val, _results;
      _results = [];
      for (key in obj) {
        val = obj[key];
        _results.push(this.prototype[key] = val);
      }
      return _results;
    };

    _ref = ["get", "post", "put", "del", "mount"];
    _fn = function(method) {
      return StartappCore[method] = function() {
        var args, route;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        this._routes = (function() {
          var _j, _len2, _ref2, _results;
          _ref2 = this._routes || [];
          _results = [];
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            route = _ref2[_j];
            _results.push(route);
          }
          return _results;
        }).call(this);
        return this._routes.push([method].concat(__slice.call(args)));
      };
    };
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      method = _ref[_i];
      _fn(method);
    }

    StartappCore.listen = function(port) {
      var app;
      if (port == null) port = 3000;
      app = express.createServer();
      this.environment(app);
      this.set_routes("", app);
      return app.listen(port);
    };

    return StartappCore;

  }).call(this);

  module.exports = StartappCore;

}).call(this);
