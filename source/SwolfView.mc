import Toybox.Graphics;
import Toybox.WatchUi;

class SwolfView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
    // Get our app data
    var app = getApp();
    var currentHole = app.getCurrentHole();
    var strokes = app.getStrokes();
    
    // Clear the screen
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();
    
    // Set text color to white
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    
    // Get screen dimensions
    var width = dc.getWidth();
    var height = dc.getHeight();
    var centerX = width / 2;
    var centerY = height / 2;
    
    // Display hole number
// Get par for current hole
var currentPar = app.getCurrentPar();

// Display par at the top
dc.drawText(centerX, centerY - 185, Graphics.FONT_LARGE, 
           "Par " + currentPar, Graphics.TEXT_JUSTIFY_CENTER);

// Display hole number below par
dc.drawText(centerX, centerY - 130, Graphics.FONT_MEDIUM, 
           "Hole " + currentHole, Graphics.TEXT_JUSTIFY_CENTER);

// Display stroke count in the middle
dc.drawText(centerX, centerY -75, Graphics.FONT_MEDIUM, 
           "Strokes: " + strokes, Graphics.TEXT_JUSTIFY_CENTER);

// Display GPS status (move it up)
var hasGPS = app.hasGPSFix() ? "GPS: ON" : "GPS: OFF";
dc.drawText(centerX, centerY + 25, Graphics.FONT_TINY, hasGPS, Graphics.TEXT_JUSTIFY_CENTER);

// Display distances (move them down more)
var distances = app.getCurrentDistances();
if (distances != null && app.hasGPSFix()) {
    var front = distances.get("distToFront");
    var center = distances.get("distToCenter");
    var back = distances.get("distToBack");
    
    if (front != null && center != null && back != null) {
        // Draw each number centered under its label - spread them out more
        dc.drawText(centerX - 120, centerY + 65, Graphics.FONT_SMALL, front.toNumber().toString(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX, centerY + 65, Graphics.FONT_SMALL, center.toNumber().toString(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(centerX + 130, centerY + 65, Graphics.FONT_SMALL, back.toNumber().toString(), Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.drawText(centerX, centerY + 105, Graphics.FONT_TINY, "Front | Center | Back", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
}

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
