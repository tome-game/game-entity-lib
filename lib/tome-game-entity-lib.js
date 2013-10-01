(function() {
  (function(root) {
    (root.tome != null ? root.tome : root.tome = {}).version = '0.0.1';
    module.exports = root.tome;
  })(typeof global !== "undefined" && global !== null ? global : window);

}).call(this);

(function() {
  tome.Event = (function() {
    function Event(options) {
      var _ref, _ref1, _ref2;
      if (options == null) {
        options = {};
      }
      this.type = (_ref = options.type) != null ? _ref : 'UNKNOWN';
      this.data = (_ref1 = options.data) != null ? _ref1 : {};
      this.source = (_ref2 = options.source) != null ? _ref2 : {};
      this.stopped = false;
    }

    Event.prototype.stopPropagation = function() {
      this.stopped = true;
      return this;
    };

    return Event;

  })();

}).call(this);

(function() {
  var callEventHandlers,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  tome.EventSource = (function() {
    function EventSource() {
      this.trigger = __bind(this.trigger, this);
      this.off = __bind(this.off, this);
      this.on = __bind(this.on, this);
      this.handlers = {};
    }

    EventSource.prototype.on = function(event_type, handler) {
      var _base;
      (_base = this.handlers)[event_type] || (_base[event_type] = collection([]));
      this.handlers[event_type].add(handler);
      return this;
    };

    EventSource.prototype.off = function(event_type, handler) {
      var _ref;
      if (handler == null) {
        handler = false;
      }
      if (handler) {
        this.handlers[event_type] = this.handlers[event_type].without(handler);
      }
      if (!handler || ((_ref = this.handlers[event_type]) != null ? _ref.isEmpty() : void 0)) {
        delete this.handlers[event_type];
      }
      return this;
    };

    EventSource.prototype.trigger = function(event_type, data) {
      var event;
      if (data == null) {
        data = {};
      }
      event = new tome.Event({
        type: event_type,
        data: data,
        source: this
      });
      if (this.handlers[event_type]) {
        callEventHandlers(event, this.handlers[event_type]);
      }
      return event;
    };

    return EventSource;

  })();

  callEventHandlers = function(event, handlers) {
    var handler, _i, _len, _ref;
    _ref = handlers.array();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      handler = _ref[_i];
      if (event.stopped) {
        return;
      }
      handler.call(event.source, event);
    }
  };

}).call(this);

(function() {
  var _, _s,
    __slice = [].slice;

  _ = require('lodash');

  _s = require('underscore.string');

  tome.Collection = (function() {
    var _this = this;

    function Collection(items) {
      var item, _i, _len;
      if (items == null) {
        items = [];
      }
      this.items = [];
      for (_i = 0, _len = items.length; _i < _len; _i++) {
        item = items[_i];
        if (item) {
          this.add(item);
        }
      }
    }

    Collection.prototype.add = function() {
      var item, items, _i, _len;
      items = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      for (_i = 0, _len = items.length; _i < _len; _i++) {
        item = items[_i];
        if (item) {
          this.items.push(item);
        }
      }
      this.length = this.items.length;
      return this;
    };

    Collection.prototype.array = function() {
      var item, _i, _len, _ref, _results;
      _ref = this.items;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        _results.push(item);
      }
      return _results;
    };

    Collection.LODASH_METHODS = _s.words("all any at each first last rest compact                           map reduce reduceRight find isEmpty pluck                           filter select reject size sample difference                           uniq intersection where without remove");

    Collection.LODASH_METHODS.forEach(function(method) {
      return Collection.prototype[method] = function() {
        var args, results;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        args.unshift(this.items);
        results = _[method].apply(_, args);
        if (_.isArray(results)) {
          return new Collection(results);
        } else {
          return results;
        }
      };
    });

    return Collection;

  }).call(this);

}).call(this);

(function() {
  var uuid,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  uuid = require('node-uuid');

  tome.Entity = (function(_super) {
    __extends(Entity, _super);

    function Entity(options) {
      var _ref, _ref1;
      if (options == null) {
        options = {};
      }
      this.has = __bind(this.has, this);
      this.get = __bind(this.get, this);
      this.add = __bind(this.add, this);
      this.id = (_ref = options.id) != null ? _ref : uuid.v4();
      this.current_components = {};
      if ((_ref1 = options.components) != null) {
        _ref1.forEach(this.add);
      }
    }

    Entity.prototype.add = function(component) {
      return this.current_components[component.name] = component;
    };

    Entity.prototype.components = function() {
      return this.current_components;
    };

    Entity.prototype.get = function(component_name) {
      return this.current_components[component_name];
    };

    Entity.prototype.has = function(component_name) {
      var _ref;
      return (_ref = this.get(component_name)) !== null && _ref !== (void 0);
    };

    Entity.prototype.is = Entity.prototype.has;

    return Entity;

  })(tome.EventSource);

}).call(this);

(function() {
  var getName, setAttribute, _, _s,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ = require('lodash');

  _s = require('underscore.string');

  tome.EntityComponent = (function(_super) {
    __extends(EntityComponent, _super);

    function EntityComponent(options) {
      var attr, v, _ref, _ref1, _ref2, _ref3;
      if (options == null) {
        options = {};
      }
      this.attrs = {};
      _ref2 = (_ref = (_ref1 = options.attributes) != null ? _ref1 : options.attrs) != null ? _ref : {};
      for (attr in _ref2) {
        v = _ref2[attr];
        this.set(attr, v);
      }
      this.name = (_ref3 = options.name) != null ? _ref3 : getName(this);
      if (this.accessible_attrs != null) {
        this.make_accessible(this.accessible_attrs);
      }
    }

    EntityComponent.prototype.attributes = function() {
      return this.attrs;
    };

    EntityComponent.prototype.entity = function(entity) {
      if (entity) {
        return this.entity = entity;
      } else {
        return entity;
      }
    };

    EntityComponent.prototype.get = function(attr_name) {
      return this.attrs[attr_name];
    };

    EntityComponent.prototype.has = function(attr_name) {
      var _ref;
      return (_ref = this.get(attr_name)) !== null && _ref !== (void 0);
    };

    EntityComponent.prototype.is = EntityComponent.prototype.has;

    EntityComponent.prototype.json = function() {
      return {
        name: this.name,
        attributes: this.attrs
      };
    };

    EntityComponent.prototype.jsonString = function() {
      return JSON.stringify(this.json());
    };

    EntityComponent.prototype.make_accessible = function(attr_names) {
      var _ref,
        _this = this;
      attr_names = (_ref = typeof attr_names.split === "function" ? attr_names.split(' ') : void 0) != null ? _ref : attr_names;
      return attr_names.forEach(function(attr_name) {
        return _this.constructor.prototype[attr_name] = function(value) {
          if (value) {
            _this.set(attr_name, value);
            return _this;
          } else {
            return _this.get(attr_name);
          }
        };
      });
    };

    EntityComponent.prototype.readOnly = function() {
      return new EntityComponent({
        attributes: _.cloneDeep(this.attrs)
      }).set({
        readonly: true
      });
    };

    EntityComponent.prototype.set = function(attr, val) {
      var attr_name;
      if (val == null) {
        val = null;
      }
      if (_.isObject(attr)) {
        for (attr_name in attr) {
          val = attr[attr_name];
          setAttribute(this.attrs, attr_name, val);
        }
      } else {
        setAttribute(this.attrs, attr, val);
      }
      return this;
    };

    return EntityComponent;

  })(tome.EventSource);

  getName = function(component) {
    return _s.underscored(component.constructor.name.replace(/component/i, ''));
  };

  setAttribute = function(attrs, attr, val) {
    if (attrs.readonly === true) {
      throw exception("Attempting to set " + attr + " for read-only component");
    }
    if (_.isFunction(val)) {
      val = typeof val === "function" ? val() : void 0;
    }
    if (val === (void 0) || val === null) {
      return delete attrs[attr];
    } else {
      return attrs[attr] = val;
    }
  };

}).call(this);

(function() {
  tome.EntityController = (function() {
    function EntityController() {}

    EntityController.prototype.update = function(entities, update_stats, game_state) {};

    EntityController.prototype.render = function(entities, update_stats, game_state) {};

    return EntityController;

  })();

}).call(this);

(function() {
  var _, _s,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _ = require('lodash');

  _s = require('underscore.string');

  tome.Game = (function() {
    var addState, setCurrentState;

    Game.prototype.states = {};

    Game.prototype.current_state = null;

    Game.prototype.stopped = true;

    function Game(states) {
      var name, options;
      if (states == null) {
        states = {};
      }
      this.update = __bind(this.update, this);
      this.render = __bind(this.render, this);
      for (name in states) {
        options = states[name];
        addState(this, name, options);
        if (!this.current_state) {
          setCurrentState(this, name);
        }
      }
    }

    Game.prototype.currentState = function() {
      return this.current_state;
    };

    Game.prototype.start = function() {
      if (_.isEmpty(this.states)) {
        throw Error("No game states defined");
      }
      this.stopped = false;
      this.update();
      this.render();
      return this;
    };

    Game.prototype.stop = function() {
      this.stopped = true;
      return this;
    };

    Game.prototype.render = function(timestamp) {
      if ((typeof requestAnimationFrame !== "undefined" && requestAnimationFrame !== null) && !this.stopped) {
        this.current_state.render(timestamp);
        requestAnimationFrame(this.render);
      }
    };

    Game.prototype.update = function() {
      if (!this.stopped) {
        this.current_state.update();
        schedule(tome.GameFrameStats.DEFAULT_STEP_DELTA, this.update);
      }
    };

    addState = function(game, state_name, state_options) {
      if (state_options == null) {
        state_options = {};
      }
      state_options.name = state_name;
      return game.states[state_name] = new tome.GameState(state_options);
    };

    setCurrentState = function(game, name) {
      game.current_state = game.states[name];
      return this;
    };

    return Game;

  })();

}).call(this);

(function() {
  tome.GameFrameStats = (function() {
    GameFrameStats.DEFAULT_STEP_DELTA = 1000 / 60;

    GameFrameStats.prototype.current_frame_time = null;

    GameFrameStats.prototype.last_frame_time = null;

    GameFrameStats.prototype.last_frame_duration = null;

    GameFrameStats.prototype.frames_per_second = 0;

    GameFrameStats.prototype.frame_count = 0;

    function GameFrameStats() {
      this.current_frame_time = +new Date();
    }

    GameFrameStats.prototype.step = function(timestamp) {
      if (timestamp == null) {
        timestamp = +new Date();
      }
      this.last_frame_time = this.current_frame_time;
      this.current_frame_time = timestamp;
      this.last_frame_duration = this.current_frame_time - this.last_frame_time;
      this.frames_per_second = Math.floor(this.last_frame_duration / 1000.0);
      this.frame_count++;
    };

    GameFrameStats.prototype.fps = function() {
      return this.frames_per_second;
    };

    GameFrameStats.prototype.stepDelta = function() {
      return this.last_frame_duration || GameFrameStats.DEFAULT_STEP_DELTA;
    };

    return GameFrameStats;

  })();

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  tome.GameState = (function() {
    function GameState(options) {
      var _ref, _ref1;
      if (options == null) {
        options = {};
      }
      this.render = __bind(this.render, this);
      this.update = __bind(this.update, this);
      if (options.name != null) {
        this.name = options.name;
      } else {
        throw new Error("game states require a name");
      }
      this.frame_update_stats = new tome.GameFrameStats;
      this.frame_render_stats = new tome.GameFrameStats;
      this.controllers = (_ref = options.controllers) != null ? _ref : [];
      this.entities = (_ref1 = options.entities) != null ? _ref1 : [];
    }

    GameState.prototype.update = function(timestamp) {
      var _this = this;
      this.frame_update_stats.step(timestamp);
      this.controllers.forEach(function(controller) {
        return typeof controller.update === "function" ? controller.update(_this.entities, _this.frame_update_stats, _this) : void 0;
      });
    };

    GameState.prototype.render = function(timestamp) {
      var _this = this;
      this.frame_render_stats.step(timestamp);
      this.controllers.forEach(function(controller) {
        return typeof controller.render === "function" ? controller.render(_this.entities, _this.frame_render_stats, _this) : void 0;
      });
    };

    return GameState;

  })();

}).call(this);

(function() {
  (function(root) {
    root.findClass = function(name, suffix, strict) {
      var class_name, clazz, suffixed_name, _ref, _ref1, _ref2;
      if (suffix == null) {
        suffix = '';
      }
      if (strict == null) {
        strict = false;
      }
      if (!/([A-Z0-9][a-z0-9]+)+/.test(class_name)) {
        class_name = _.str.classify("" + class_name);
      }
      suffixed_name = "" + class_name + suffix;
      clazz = (_ref = (_ref1 = (_ref2 = tome[class_name]) != null ? _ref2 : tome[suffixed_name]) != null ? _ref1 : root[class_name]) != null ? _ref : root[suffixed_name];
      if (strict && !_.isFunction(clazz)) {
        throw exception("Can't find class " + class_name);
      }
      return clazz;
    };
    root.collection = function(items) {
      if (items == null) {
        items = [];
      }
      if (items instanceof tome.Collection) {
        return items;
      }
      if (items.constructor.name !== 'Array') {
        items = arguments;
      }
      return new tome.Collection(items);
    };
    root.entity = function(components) {
      if (components == null) {
        components = [];
      }
      if (arguments.length > 1) {
        components = arguments;
      }
      return new tome.Entity({
        components: components
      });
    };
    root.component = function(name, attrs) {
      var _ref;
      if (attrs == null) {
        attrs = {};
      }
      return new ((_ref = findClass(name)) != null ? _ref : tome.EntityComponent)({
        attributes: attrs
      });
    };
    root.controller = function(name) {
      var _ref;
      return new ((_ref = findClass(name)) != null ? _ref : tome.EntityController)({
        attributes: attrs
      });
    };
    return root.components = function(components) {
      var attrs, name;
      if (components == null) {
        components = {};
      }
      return collection((function() {
        var _results;
        _results = [];
        for (name in components) {
          attrs = components[name];
          _results.push(component(name, attrs));
        }
        return _results;
      })());
    };
  })(typeof global !== "undefined" && global !== null ? global : window);

}).call(this);

(function() {
  (function(root) {
    root.schedule = function(ms, fn) {
      return setTimeout(fn, ms);
    };
    root.unschedule = function(timeout_id) {
      return clearTimeout(timeout_id);
    };
    return root.async = function(fn) {
      return schedule(0, fn);
    };
  })(typeof global !== "undefined" && global !== null ? global : window);

}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  tome.AccountComponent = (function(_super) {
    __extends(AccountComponent, _super);

    function AccountComponent() {
      _ref = AccountComponent.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    AccountComponent.prototype.accessible_attrs = 'token connectedAt';

    return AccountComponent;

  })(tome.EntityComponent);

}).call(this);

(function() {


}).call(this);

(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  tome.PositionComponent = (function(_super) {
    __extends(PositionComponent, _super);

    function PositionComponent() {
      _ref = PositionComponent.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    PositionComponent.prototype.accessible_attrs = 'x y z';

    PositionComponent.prototype.distance = function(position) {
      var x, y, z;
      (x = position.x() - this.x()) * x;
      (y = position.y() - this.y()) * y;
      (z = position.z() - this.z()) * z;
      return Math.sqrt(x + y + z);
    };

    return PositionComponent;

  })(tome.EntityComponent);

}).call(this);
