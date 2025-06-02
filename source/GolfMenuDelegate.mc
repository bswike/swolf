using Toybox.WatchUi;
using Toybox.Application as App;

class GolfMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

function onMenuItem(item) {
    if (item == :add_stroke) {
        var app = App.getApp();
        app.addStroke();
    }
    // Menu closes automatically - don't call popView()
}
}