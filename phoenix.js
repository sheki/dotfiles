/**
 * Phoenix
 * doc: https://github.com/jasonm23/phoenix/wiki/JavaScript-API-documentation
 *
 * Global Settings
 */

var keys = [];

var mash = ["alt"];
var mashShift = ["alt", "shift"];
var mashCtrl = ["alt", "ctrl"];
var CMD_BTN = ["cmd"];
var mousePositions = {};
var HIDE_INACTIVE_WINDOW_TIME = 10;  // minitus
var ACTIVE_WINDOWS_TIMES = {};
var DEFAULT_WIDTH = 1280;


/**
 * Utils Functions
 */

function alert(message) {
  var modal = new Modal();
  modal.message = message;
  modal.duration = 2;
  modal.show();
}

function assert(condition, message) {
  if (!condition) {
    throw message || "Assertion failed";
  }
}

var alert_title = function(window) { Modal.show(window.title()); };

function sortByMostRecent(windows) {
  var visibleAppMostRecentFirst = _.map(Window.visibleWindowsInOrder(),
                                        function(w) { return w.app().name(); });
  var visibleAppMostRecentFirstWithWeight = _.object(visibleAppMostRecentFirst,
                                                     _.range(visibleAppMostRecentFirst.length));
  return _.sortBy(windows, function(window) { return visibleAppMostRecentFirstWithWeight[window.app().name()]; });
};

function getNewFrame(frame, oldScreenRect, newScreenRect) {
}

function getResizeFrame(frame, ratio) {
  var mid_pos_x = frame.x + 0.5 * frame.width;
  var mid_pos_y = frame.y + 0.5 * frame.height;
  return {
    x: Math.round(frame.x + frame.width / 2 * (1 - ratio)),
    y: Math.round(frame.y + frame.height / 2 * (1 - ratio)),
    width: Math.round(frame.width * ratio),
    height: Math.round(frame.height * ratio)
  }
}

function getSmallerFrame(frame) {
  return getResizeFrame(frame, 0.9);
}

function getLargerFrame(frame) {
  return getResizeFrame(frame, 1.1);
}

/**
 * Screen Functions
 */

function moveToScreen(window, screen) {
  if (!window) return;
  if (!screen) return;

  var frame = window.frame();
  var oldScreenRect = window.screen().visibleFrameInRectangle();
  var newScreenRect = screen.visibleFrameInRectangle();
  var xRatio = newScreenRect.width / oldScreenRect.width;
  var yRatio = newScreenRect.height / oldScreenRect.height;

  var mid_pos_x = frame.x + Math.round(0.5 * frame.width);
  var mid_pos_y = frame.y + Math.round(0.5 * frame.height);

  window.setFrame({
    x: (mid_pos_x - oldScreenRect.x) * xRatio + newScreenRect.x - 0.5 * frame.width,
    y: (mid_pos_y - oldScreenRect.y) * yRatio + newScreenRect.y - 0.5 * frame.height,
    width: frame.width,
    height: frame.height
  });
};

function windowsOnOtherScreen() {
  var start = new Date().getTime();
  var otherWindowsOnSameScreen = Window.focusedWindow().otherWindowsOnSameScreen();  // slow
  Phoenix.log('windowsOnOtherScreen 0.1: ' + (new Date().getTime() - start));
  var otherWindowTitlesOnSameScreen = _.map(otherWindowsOnSameScreen , function(w) { return w.title(); });
  var return_value = _.chain(Window.focusedWindow().otherWindowsOnAllScreens())
    .filter(function(window) { return ! _.contains(otherWindowTitlesOnSameScreen, window.title()); })
    .value();
  return return_value;
};


/**
 * Window Functions
 */

function hide_inactiveWindow(windows) {
  var now = new Date().getTime() / 1000;
  _.chain(windows).filter(function(window) {
    if (!ACTIVE_WINDOWS_TIMES[window.app().pid]) {
      ACTIVE_WINDOWS_TIMES[window.app().pid] = now;
      return false;
    } return true;
  }).filter(function(window) {
    return now - ACTIVE_WINDOWS_TIMES[window.app().pid]> HIDE_INACTIVE_WINDOW_TIME * 60;
    //return now - ACTIVE_WINDOWS_TIMES[window.app().pid]> 5;
  }).map(function(window) {window.app().hide()});
}

function heartbeat_window(window) {
  ACTIVE_WINDOWS_TIMES[window.app().pid] = new Date().getTime() / 1000;
  //hide_inactiveWindow(window.otherWindowsOnSameScreen());
}

function getAnotherWindowsOnSameScreen(window, offset) {
  var start = new Date().getTime();
  var windows = window.otherWindowsOnSameScreen(); // slow, makes `Saved spin report for Phoenix version 1.2 (1.2) to /Library/Logs/DiagnosticReports/Phoenix_2015-05-30-170354_majin.spin`
  Phoenix.log('getAnotherWindowsOnSameScreen 1: ' + (new Date().getTime() - start));
  windows.push(window);
  windows = _.chain(windows).sortBy(function(window) {
    return [window.frame().x, window.frame().y, window.app().pid, window.title()].join('_');
  }).value().reverse();
  return windows[(_.indexOf(windows, window) + offset + windows.length) % windows.length];
}

function getNextWindowsOnSameScreen(window) {
  return getAnotherWindowsOnSameScreen(window, -1)
};

function getPreviousWindowsOnSameScreen(window) {
  return getAnotherWindowsOnSameScreen(window, 1)
};

function setWindowCentral(window) {
  window.setTopLeft({
    x: (window.screen().frameInRectangle().width - window.size().width) / 2 + window.screen().frameInRectangle().x,
    y: (window.screen().frameInRectangle().height - window.size().height) / 2 + window.screen().frameInRectangle().y
  });
  heartbeat_window(window);
};

function setWindowLeft(window) {
  window.setTopLeft({
     x: 0,
     y: 0,
  })
  window.setSize({
    width:  window.screen().frameInRectangle().width / 2,
    height:  window.screen().frameInRectangle().height,
  })
  heartbeat_window(window);
}

function setWindowRight(window) {
   var sWidth = window.screen().frameInRectangle().width;
   var sHeight =window.screen().frameInRectangle().height;
   window.setTopLeft({
     x: sWidth/2,
     y: 0,
  })
  window.setSize({
    width:  sWidth/2,
    height:  sHeight,
  })
  heartbeat_window(window);
}

function callAndLeft(appName) {
  var newWindow = _.first(launchOrFocus(appName).windows());
  setWindowLeft(newWindow);
}

function callAndRight(appName) {
  var newWindow = _.first(launchOrFocus(appName).windows());
  setWindowRight(newWindow);
}

//switch app, and remember mouse position
function callApp(appName) {
  var window = Window.focusedWindow();
  if (window) {
    save_mouse_position_for_window(window);
  }
  //App.launch(appName);
  var newWindow = _.first(launchOrFocus(appName).windows());
  if (newWindow && window !== newWindow) {
    restore_mouse_position_for_window(newWindow);
  }
}

function callAndMaximize(appName) {
  var window = Window.focusedWindow();
  if (window) {
    save_mouse_position_for_window(window);
  }
  //App.launch(appName);
  var newWindow = _.first(launchOrFocus(appName).windows());
  if (newWindow && window !== newWindow) {
    restore_mouse_position_for_window(newWindow);
  }

  newWindow.maximize();
  setWindowCentral(window);
}

function leftRight(app1, app2) {
  callAndRight(app2);
  callAndLeft(app1);
}


/**
 * Mouse Functions
 */

function save_mouse_position_for_window(window) {
  if (!window) return;
  heartbeat_window(window);
  mousePositions[window.title()] = Mouse.location();
}

function set_mouse_position_for_window_center(window) {
  Mouse.moveTo({
    x: window.topLeft().x + window.frame().width / 2,
    y: window.topLeft().y + window.frame().height / 2
  });
  heartbeat_window(window);
}

function restore_mouse_position_for_window(window) {
  if (!mousePositions[window.title()]) {
    set_mouse_position_for_window_center(window);
    return;
  }
  var pos = mousePositions[window.title()];
  var rect = window.frame();
  if (pos.x < rect.x || pos.x > (rect.x + rect.width) || pos.y < rect.y || pos. y > (rect.y + rect.height)) {
    set_mouse_position_for_window_center(window);
    return;
  }
  Mouse.moveTo(pos);
  heartbeat_window(window);
}

function restore_mouse_position_for_now() {
  if (Window.focusedWindow() === undefined) {
    return;
  }
  restore_mouse_position_for_window(Window.focusedWindow());
}


/**
 * App Functions
 */

function launchOrFocus(appName) {
  var app = App.launch(appName);
  assert(app !== undefined);
  app.focus();
  return app;
}




/**
 * My Configuartion App
 */

// Launch App
keys.push(Phoenix.bind('`', mash, function() { leftRight('iTerm', 'Google Chrome'); }));
keys.push(Phoenix.bind('1', mash, function() { leftRight('Notational Velocity', 'Google Chrome'); }));
keys.push(Phoenix.bind('2', mash, function() { leftRight('Notational Velocity', 'iTerm'); }));
keys.push(Phoenix.bind('3', mash, function() { callAndMaximize('Google Chrome'); }));
keys.push(Phoenix.bind('4', mash, function() { callAndMaximize('iTerm'); }));


/**
 * My Configuartion Screen
 */

// Next screen, now only support 2 display // TODO
keys.push(Phoenix.bind('l', mash, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  if (window.screen() === window.screen().next()) return;
  if (window.screen().next().frameInRectangle().x < window.screen().frameInRectangle().x) {
    return;
  }
  save_mouse_position_for_window(window);
  var nextScreenWindows = sortByMostRecent(windowsOnOtherScreen());
  if (nextScreenWindows.length > 0) {
    nextScreenWindows[0].focus();
    restore_mouse_position_for_window(nextScreenWindows[0]);
  }
}));

// Previous Screen, now only support 2 display // TODO
keys.push(Phoenix.bind('h', mash, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  if (window.screen() === window.screen().next()) return;
  if (window.screen().next().frameInRectangle().x > window.screen().frameInRectangle().x) {
    return;
  }
  save_mouse_position_for_window(window);
  var nextScreenWindows = sortByMostRecent(windowsOnOtherScreen());  // find it!!! cost !!!
  if (nextScreenWindows.length > 0) {
    nextScreenWindows[0].focus();
    restore_mouse_position_for_window(nextScreenWindows[0]);
  }
}));

// Move Current Window to Next Screen
keys.push(Phoenix.bind('l', mashShift, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  if (window.screen() === window.screen().next()) return;
  if (window.screen().next().frameInRectangle().x < 0) {
    return;
  }
  moveToScreen(window, window.screen().next());
}));

// Move Current Window to Previous Screen
keys.push(Phoenix.bind('h', mashShift, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  if (window.screen() === window.screen().next()) return;
  if (window.screen().next().frameInRectangle().x == 0) {
    return;
  }
  moveToScreen(window, window.screen().previous());
}));


/**
 * My Configuartion Window
 */

// Window Hide Inactive
keys.push(Phoenix.bind('delete', mash, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  heartbeat_window(window);
  hide_inactiveWindow(window.otherWindowsOnAllScreens());
}));

// Window Maximize
keys.push(Phoenix.bind('m', mashShift, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  window.maximize();
  setWindowCentral(window);
  //heartbeat_window(window);
}));

// Window Smaller
keys.push(Phoenix.bind('-', mash, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  var oldFrame = window.frame();
  var frame = getSmallerFrame(oldFrame);
  window.setFrame(frame);
  if (window.frame().width == oldFrame.width || window.frame().height == oldFrame.height) {
    window.setFrame(oldFrame);
  }
  //heartbeat_window(window);
}));

// Window Larger
keys.push(Phoenix.bind('=', mash, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  var frame = getLargerFrame(window.frame());
  if (frame.width > window.screen().frameInRectangle().width ||
      frame.height > window.screen().frameInRectangle().height) {
    window.maximize();
  } else {
    window.setFrame(frame);
  }
  //heartbeat_window(window);
}));

// Window Central
keys.push(Phoenix.bind('m', mash, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  setWindowCentral(window);
}));

// Window Height
keys.push(Phoenix.bind('\\', mash, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  window.setFrame({
    x: window.frame().x,
    y: window.screen().frameInRectangle().y,
    width: window.frame().width,
    height: window.screen().frameInRectangle().height
  });
  heartbeat_window(window);
}));

// Window Width
keys.push(Phoenix.bind('\\', mashShift, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  window.setFrame({
    x: window.frame().x,
    y: window.screen().frameInRectangle().y,
    width: DEFAULT_WIDTH,  // Mac width
    height: window.frame().height
  });
  heartbeat_window(window);
}));

// Window >
keys.push(Phoenix.bind('l', mashCtrl, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  window.setFrame({
    x: window.frame().x + 100,
    y: window.frame().y,
    width: window.frame().width,
    height: window.frame().height
  });
  heartbeat_window(window);
}));

// Window <
keys.push(Phoenix.bind('h', mashCtrl, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  window.setFrame({
    x: window.frame().x - 100,
    y: window.frame().y,
    width: window.frame().width,
    height: window.frame().height
  });
  heartbeat_window(window);
}));

// Window ^
keys.push(Phoenix.bind('k', mashCtrl, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  window.setFrame({
    x: window.frame().x,
    y: window.frame().y - 100,
    width: window.frame().width,
    height: window.frame().height
  });
  heartbeat_window(window);
}));

// Window v
keys.push(Phoenix.bind('j', mashCtrl, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  window.setFrame({
    x: window.frame().x,
    y: window.frame().y + 100,
    width: window.frame().width,
    height: window.frame().height
  });
  heartbeat_window(window);
}));

// Next Window in One Screen
keys.push(Phoenix.bind('k', mash, function() {
  var window = Window.focusedWindow();
  if (!window) {
    if (Window.visibleWindowsInOrder().length == 0) return;
    Window.visibleWindowsInOrder()[0].focus();
    return;
  }
  save_mouse_position_for_window(window);
  var targetWindow = getNextWindowsOnSameScreen(window);
  targetWindow.focus();
  restore_mouse_position_for_window(targetWindow);
}));

// Previous Window in One Screen
keys.push(Phoenix.bind('j', mash, function() {
  var window = Window.focusedWindow();
  if (!window) {
    if (Window.visibleWindowsInOrder().length == 0) return;
    Window.visibleWindowsInOrder()[0].focus();
    return;
  }
  save_mouse_position_for_window(window);
  var targetWindow = getPreviousWindowsOnSameScreen(window);  // <- most time cost
  targetWindow.focus();
  restore_mouse_position_for_window(targetWindow);
}));


/**
 * My Configuartion Mouse
 */

// Central Mouse
keys.push(Phoenix.bind('space', mash, function() {
  var window = Window.focusedWindow();
  if (!window) return;
  set_mouse_position_for_window_center(window);
}));


/**
 * Mission Control
 */

// use Mac Keyboard setting
// mash + i
// mash + o




// Test
keys.push(Phoenix.bind('0', mash, function() {
  //var cw = Window.focusedWindow();
  //_.map(App.runningApps(), function(app) { Modal.show(app.title(), 5)});
  //_.map([Window.focusedWindow()], function(window) { Modal.show(window.title())});  // current one
  //_.map(Window.windows(), function(window) { Modal.show(window.title(), 5)});  // all, include hide
  //_.map(Window.visibleWindows(), function(window) { Modal.show(window.title())});  // all, no hide
  //_.map(Window.visibleWindowsInOrder(), function(window) { Modal.show(window.title())});
  //_.map(Window.focusedWindow().otherWindowsOnAllScreens(), function(window) { Modal.show(window.title())});  // no space
  //_.map(Window.focusedWindow().windowsOnOtherScreen(), alert_title);
  //_.map(cw.sortByMostRecent(cw.windowsOnOtherScreen()), alert_title);
  //_.map(cw.windowsOnOtherScreen(), alert_title);
  //Modal.show(Window.focusedWindow().screen());


  //_.chain(Window.windows()).difference(Window.visibleWindows()).map(function(window) { Modal.show(window.title())});  // all, include hide
  //Modal.show(_.chain(Window.windows()).difference(Window.visibleWindows()).value().length);
  //Modal.show(_.chain(Window.windows()).value().length);
  //hide_inactiveWindow(Window.focusedWindow().otherWindowsOnAllScreens());
  var modal = new Modal();
  modal.message = 'F!';
  modal.duration = 2;
  modal.show();
}));
