import Toybox.Lang;
import Toybox.WatchUi;

class SwolfDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() as Boolean {
        // Add a stroke
        var app = getApp();
        app.addStroke();
        WatchUi.requestUpdate();
        return true;
    }

    function onNextPage() as Boolean {
        // Next hole (UP button)
        var app = getApp();
        app.previousHole();
        WatchUi.requestUpdate();
        return true;
    }

    function onPreviousPage() as Boolean {
        // Previous hole (DOWN button)
        var app = getApp();
        app.nextHole();
        WatchUi.requestUpdate();
        return true;
    }
}