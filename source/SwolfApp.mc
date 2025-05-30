import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Position;

class SwolfApp extends Application.AppBase {

    private var _currentHole = 1;
    private var _strokes = 0;
    private var _currentPosition;
    private var _courseData;
    private var _parValues as Array<Number> = [4, 4, 3, 5, 4, 3, 4, 4, 5, 4, 3, 4, 5, 4, 3, 4, 4, 5];

    function initialize() {
        AppBase.initialize();
            _currentPosition = null;
            _courseData = null;
            loadSparrowsPoint();
            testSparrowsPointGPS();
            //loadSampleCourse();
    }

    function getCurrentPar() {
    return _parValues[_currentHole - 1]; // -1 because arrays are 0-indexed
}

function testSparrowsPointGPS() {
    // Just set a flag that we have GPS and manually set coordinates
    _currentPosition = true; // Just to trigger hasGPSFix()
    
    // Calculate distances manually for testing
    var teeBoxLat = 39.254606;
    var teeBoxLon = -76.475647;
    
    if (_courseData != null && _courseData.size() > 0) {
        var holeData = _courseData[0];
        holeData.put("distToFront", calculateDistance(teeBoxLat, teeBoxLon, 39.253351, -76.472537));
        holeData.put("distToCenter", calculateDistance(teeBoxLat, teeBoxLon, 39.253238, -76.472436));
        holeData.put("distToBack", calculateDistance(teeBoxLat, teeBoxLon, 39.253131, -76.472373));
    }
    
    WatchUi.requestUpdate();
}

function onPosition(info as Position.Info) as Void {
    if (info.position != null) {
        _currentPosition = info.position;
        // Calculate distances when we get a GPS fix
        calculateDistances();
        WatchUi.requestUpdate();
    }
}

function loadSparrowsPoint() {
    // Real hole #1 at Sparrows Point Country Club
    _courseData = new [1]; // Just hole 1 for now
    _courseData[0] = {
        "frontLat" => 39.253351,   // Green front
        "frontLon" => -76.472537,
        "centerLat" => 39.253238,  // Green center  
        "centerLon" => -76.472436,
        "backLat" => 39.253131,    // Green back
        "backLon" => -76.472373
    };
}

function calculateDistances() as Void {
    if (_currentPosition == null || _courseData == null) {
        return;
    }
    
    var currentHole = getCurrentHole();
    if (currentHole > _courseData.size()) {
        return; // No data for this hole
    }
    
    var holeData = _courseData[currentHole - 1];
    var myPos = _currentPosition.toDegrees();
    var myLat = myPos[0];
    var myLon = myPos[1];
    
    // Calculate distances to front, center, back of green
    var frontDist = calculateDistance(myLat, myLon, holeData.get("frontLat"), holeData.get("frontLon"));
    var centerDist = calculateDistance(myLat, myLon, holeData.get("centerLat"), holeData.get("centerLon"));
    var backDist = calculateDistance(myLat, myLon, holeData.get("backLat"), holeData.get("backLon"));
    
    // Store calculated distances
    holeData.put("distToFront", frontDist);
    holeData.put("distToCenter", centerDist);
    holeData.put("distToBack", backDist);
}

function getCurrentDistances() {
    if (_courseData == null) {
        return null;
    }
    
    var currentHole = getCurrentHole();
    if (currentHole > _courseData.size()) {
        return null;
    }
    
    return _courseData[currentHole - 1];
}

function calculateDistance(lat1, lon1, lat2, lon2) {
    var R = 6371000; // Earth's radius in meters
    var dLat = Math.toRadians(lat2 - lat1);
    var dLon = Math.toRadians(lon2 - lon1);
    var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
            Math.sin(dLon/2) * Math.sin(dLon/2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return (R * c * 1.09361).toNumber(); // Convert meters to yards
}

    // onStart() is called on application start up
    function onStart(state) {
    Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    function hasGPSFix() {
    return _currentPosition != null;
}

function loadSampleCourse() {
    // Sample golf course with 3 holes (you can expand this)
    _courseData = new [3];
    _courseData[0] = {
        "frontLat" => 37.7749,   // Sample coordinates
        "frontLon" => -122.4194,
        "centerLat" => 37.7750,
        "centerLon" => -122.4195,
        "backLat" => 37.7751,
        "backLon" => -122.4196
    };
    _courseData[1] = {
        "frontLat" => 37.7752,
        "frontLon" => -122.4197,
        "centerLat" => 37.7753,
        "centerLon" => -122.4198,
        "backLat" => 37.7754,
        "backLon" => -122.4199
    };
    _courseData[2] = {
        "frontLat" => 37.7755,
        "frontLon" => -122.4200,
        "centerLat" => 37.7756,
        "centerLon" => -122.4201,
        "backLat" => 37.7757,
        "backLon" => -122.4202
    };
}
    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new SwolfView(), new SwolfDelegate() ];
    }
    function getCurrentHole() {
    return _currentHole;
    }

    function getStrokes() {
        return _strokes;
    }

    function addStroke() {
        _strokes++;
    }

    function nextHole() {
        if (_currentHole < 18) {
            _currentHole++;
            _strokes = 0;
        }
    }

    function previousHole() {
        if (_currentHole > 1) {
            _currentHole--;
            _strokes = 0;
        }
    }
}

function getApp() as SwolfApp {
    return Application.getApp() as SwolfApp;
}