(function() {
  var Cookies, Keygrip, Startapp, StartappCore, eco, express;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; }, __slice = Array.prototype.slice;

  express = require("express");

  Cookies = require("cookies");

  Keygrip = require("keygrip");

  eco = require("eco");

  StartappCore = require("./core");

  Startapp = (function() {
    var get_dirname;

    __extends(Startapp, StartappCore);

    Startapp.prototype.dirname = function() {
      return process.cwd();
    };

    function Startapp() {
      var keygrip;
      Startapp.__super__.constructor.apply(this, arguments);
      keygrip = new Keygrip(this.cookie_secret != null ? [this.cookie_secret] : void 0);
      this.cookies = new Cookies(this.req, this.res, keygrip);
      this.session = this.req.session;
      this.params = this.req.params;
      this.body = this.req.body;
    }

    Startapp.prototype.send = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return (_ref = this.res).send.apply(_ref, args);
    };

    get_dirname = function() {
      return (typeof this.dirname === "function" ? this.dirname() : void 0) || this.dirname;
    };

    Startapp.environment = function(app) {
      app.use(express.static(get_dirname() + '/public'));
      app.use(express.bodyParser());
      app.use(express.cookieParser());
      app.use(express.session({
        secret: "startapp"
      }));
      app.use(require("connect-assets")());
      app.set('views', get_dirname() + '/views');
      app.set('view options', {
        layout: false
      });
      app.register(".eco", eco);
      return app.set('view engine', "eco");
    };

    Startapp.resource = function(path, controller) {
      if (path == null) path = "";
      if (controller == null) controller = this;
      this.get("" + path, controller, "index");
      this.get("" + path + "/:id", controller, "get");
      this.post("" + path, controller, "create");
      this.put("" + path + "/:id", controller, "update");
      return this.del("" + path + "/:id", controller, "delete");
    };

    return Startapp;

  })();

  module.exports = Startapp;

}).call(this);
