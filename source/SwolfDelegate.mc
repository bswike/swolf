import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.Application as App;

class SwolfDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }
function onSelect() {
    // Show golf menu
    var golfMenu = new GolfMenu();
    WatchUi.pushView(golfMenu, new GolfMenuDelegate(), WatchUi.SLIDE_UP);
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