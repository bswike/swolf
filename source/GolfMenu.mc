using Toybox.WatchUi;

class GolfMenu extends WatchUi.Menu {

    function initialize() {
        Menu.initialize();
        Menu.setTitle("Golf");
        Menu.addItem("Add Stroke", :add_stroke);
        Menu.addItem("Complete Hole", :complete_hole);
        Menu.addItem("Fairway Hit", :fairway_hit);
        Menu.addItem("Fairway Missed", :fairway_missed);
        Menu.addItem("Add Putt", :add_putt);
    }
}