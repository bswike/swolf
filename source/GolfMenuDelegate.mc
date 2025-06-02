using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class GolfMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        var app = App.getApp();
        
        switch (item) {
            case :add_stroke:
                app.addStroke();
                break;
            case :complete_hole:
                app.completeHole();
                break;
            case :fairway_hit:
                // Track fairway hit
                break;
            case :fairway_missed:
                // Track fairway miss
                break;
            case :add_putt:
                // Track putt
                break;
        }
        
        Ui.popView(Ui.SLIDE_DOWN);
        Ui.requestUpdate();
    }
}