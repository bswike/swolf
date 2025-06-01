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

function onNextPage() {
    // Next hole (UP button)
    var app = getApp();
    app.previousHole(); // Your UP/DOWN are swapped
    app.testAllHoles(); // Recalculate for new hole
    WatchUi.requestUpdate();
    return true;
}

function onPreviousPage() {
    // Previous hole (DOWN button)
    var app = getApp();
    app.nextHole(); // Your UP/DOWN are swapped
    app.testAllHoles(); // Recalculate for new hole
    WatchUi.requestUpdate();
    return true;
}
}