(function() {
  var BlankApp, Cookies, Keygrip, eco, express, _;
  var __slice = Array.prototype.slice, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  express = require("express");

  _ = require("underscore");

  Cookies = require("cookies");

  Keygrip = require("keygrip");

  eco = require("eco");

  BlankApp = (function() {
    var method;

    function BlankApp(app) {
      this.app = app;
      this.environment();
      this.routes();
    }

    BlankApp.prototype.use = function(middleware) {
      return this.app.use(middleware);
    };

    BlankApp.prototype.environment = function() {};

    BlankApp.prototype.routes = function() {};

    BlankApp.prototype.separator = ".";

    BlankApp.prototype.action = function(handler) {
      var action_name, controller_class, controller_name, _ref;
      if (_(handler).isString()) {
        _ref = handler.split(this.separator), controller_name = _ref[0], action_name = _ref[1];
        if ((controller_name != null) && (action_name != null)) {
          if (controller_class = this.get_controller(controller_name)) {
            return controller_class.action(action_name);
          } else {
            return console.warn("Can't find controller " + controller_name + " in " + (process.cwd()) + "/controllers/" + controller_name + ".(js|coffee)");
          }
        } else {
          return console.warn("Action should be in format: controller" + this.separator + "action");
        }
      } else {
        return handler;
      }
    };

    BlankApp.prototype.create_handler = function(controller_class, action_name) {
      return function(req, res, next) {
        var action, controller;
        controller = new controller_class(req, res, next);
        if (action = controller[action_name]) {
          return action.call(controller);
        } else {
          return next();
        }
      };
    };

    BlankApp.prototype.get_controller = function(controller_name) {
      return require("" + (process.cwd()) + "/controllers/" + controller_name);
    };

    method = function(method_name) {
      return function() {
        var args, handler, pattern, route, _ref, _results;
        route = arguments[0], handler = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
        if ((handler != null) && _(handler).isString()) {
          return this.app[method_name](route, this.action(handler));
        } else if (handler != null) {
          return (_ref = this.app)[method_name].apply(_ref, [route, handler].concat(__slice.call(args)));
        } else {
          _results = [];
          for (pattern in route) {
            handler = route[pattern];
            _results.push(this.app[method_name](pattern, this.action(handler)));
          }
          return _results;
        }
      };
    };

    BlankApp.prototype.get = method("get");

    BlankApp.prototype.post = method("post");

    BlankApp.prototype.put = method("put");

    BlankApp.prototype["delete"] = method("delete");

    BlankApp.prototype.del = method("del");

    BlankApp.prototype.head = method("head");

    BlankApp.prototype.use = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = this.app).use.apply(_ref, args);
    };

    BlankApp.listen = function(port) {
      var app, self;
      app = express.createServer();
      self = new this(app);
      return app.listen(port || 3000);
    };

    return BlankApp;

  })();

  exports.App = (function() {
    var sample_secret;

    __extends(App, BlankApp);

    function App() {
      App.__super__.constructor.apply(this, arguments);
    }

    sample_secret = "adjk23sdj1201c93671jx6jk18h7ajqkh438baoqhb39h";

    App.prototype.cookie_secret = sample_secret;

    App.prototype.session_secret = sample_secret;

    App.prototype.environment = function() {
      this.use(express.static(process.cwd() + '/public'));
      this.use(express.bodyParser());
      this.use(express.cookieParser());
      this.use(express.session({
        secret: this.session_secret
      }));
      this.use(require("connect-assets")());
      this.app.register(".eco", eco);
      this.app.set('views', process.cwd() + '/views');
      this.app.set('view options', {
        layout: false
      });
      return this.app.set('view engine', "eco");
    };

    return App;

  })();

  exports.Controller = (function() {

    function Controller(req, res, next) {
      var keygrip;
      this.req = req;
      this.res = res;
      this.next = next;
      keygrip = new Keygrip([this.cookie_secret]);
      this.cookies = new Cookies(this.req, this.res, keygrip);
      this.session = this.req.session;
    }

    Controller.prototype.send = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = this.res).send.apply(_ref, args);
    };

    Controller.prototype.render = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = this.res).render.apply(_ref, args);
    };

    Controller.action = function(name) {
      var _this = this;
      return function(req, res, next) {
        var controller;
        if (_this.prototype[name] != null) {
          controller = new _this(req, res, next);
          return controller[name]();
        } else {
          console.warn("Controller " + controller_name + " has no action " + action_name);
          return next();
        }
      };
    };

    return Controller;

  })();

}).call(this);
