import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Position;
import Toybox.ActivityRecording;
import Toybox.System;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.Time;


class SwolfApp extends Application.AppBase {

    private var _currentHole = 1;
    private var _strokes = 0;
    private var _currentPosition;
    private var _courseData;
    private var _parValues as Array<Number> = [4,4,4,3,3,5,4,4,5,4,4,4,4,5,3,4,4,4];
    private var _session;
    private var _stats;
    private var _shots;

    function initialize() {
        AppBase.initialize();
            _currentPosition = null;
            _courseData = null;
            _session = null;
            _shots = [];
            _stats = {
        "fairwaysHit" => 0,
        "putts" => 0,
        "totalStrokes" => 0,
        "holesCompleted" => 0
    };
            loadSparrowsPoint();
            testAllHoles();
            //loadSampleCourse();
    }

    function getCurrentPar() {
    return _parValues[_currentHole - 1]; // -1 because arrays are 0-indexed
}

function testAllHoles() {
    // Test all 18 holes by simulating being on each tee box
    if (_courseData == null || _courseData.size() < 18) {
        return;
    }
    
    // Get current hole to test
    var currentHole = getCurrentHole();
    var holeIndex = currentHole - 1;
    
    if (holeIndex >= 0 && holeIndex < 18) {
        var holeData = _courseData[holeIndex];
        
        // Simulate standing on the tee box of current hole
        var teeBoxLat = holeData.get("teeBoxLat");
        var teeBoxLon = holeData.get("teeBoxLon");
        
        // Set GPS position to tee box
        _currentPosition = true; // Just to trigger hasGPSFix()
        
        // Calculate distances from tee box to green
        var frontDist = calculateDistance(teeBoxLat, teeBoxLon, 
                                        holeData.get("frontLat"), holeData.get("frontLon"));
        var centerDist = calculateDistance(teeBoxLat, teeBoxLon, 
                                         holeData.get("centerLat"), holeData.get("centerLon"));
        var backDist = calculateDistance(teeBoxLat, teeBoxLon, 
                                       holeData.get("backLat"), holeData.get("backLon"));
        
        // Store calculated distances
        holeData.put("distToFront", frontDist);
        holeData.put("distToCenter", centerDist);
        holeData.put("distToBack", backDist);
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
    // All 18 holes at Sparrows Point Country Club
    _courseData = new [18];
    
    // Hole #1 (Par 4)
    _courseData[0] = {
        "teeBoxLat" => 39.254606, "teeBoxLon" => -76.475647,
        "frontLat" => 39.253351, "frontLon" => -76.472537,
        "centerLat" => 39.253238, "centerLon" => -76.472436,
        "backLat" => 39.253131, "backLon" => -76.472373
    };
    
    // Hole #2 (Par 4)
    _courseData[1] = {
        "teeBoxLat" => 39.252825, "teeBoxLon" => -76.472589,
        "frontLat" => 39.250685, "frontLon" => -76.470124,
        "centerLat" => 39.250582, "centerLon" => -76.470071,
        "backLat" => 39.250495, "backLon" => -76.470017
    };
    
    // Hole #3 (Par 4)
    _courseData[2] = {
        "teeBoxLat" => 39.250836, "teeBoxLon" => -76.469373,
        "frontLat" => 39.253295, "frontLon" => -76.471700,
        "centerLat" => 39.253387, "centerLon" => -76.471784,
        "backLat" => 39.253464, "backLon" => -76.471880
    };
    
    // Hole #4 (Par 3)
    _courseData[3] = {
        "teeBoxLat" => 39.253673, "teeBoxLon" => -76.471461,
        "frontLat" => 39.252700, "frontLon" => -76.470112,
        "centerLat" => 39.252630, "centerLon" => -76.470005,
        "backLat" => 39.252565, "backLon" => -76.469909
    };
    
    // Hole #5 (Par 3)
    _courseData[4] = {
        "teeBoxLat" => 39.251642, "teeBoxLon" => -76.468976,
        "frontLat" => 39.250189, "frontLon" => -76.468818,
        "centerLat" => 39.250057, "centerLon" => -76.468784,
        "backLat" => 39.249947, "backLon" => -76.468779
    };
    
    // Hole #6 (Par 5)
    _courseData[5] = {
        "teeBoxLat" => 39.249353, "teeBoxLon" => -76.469560,
        "frontLat" => 39.248465, "frontLon" => -76.474230,
        "centerLat" => 39.248371, "centerLon" => -76.474225,
        "backLat" => 39.248295, "backLon" => -76.474274
    };
    
    // Hole #7 (Par 4)
    _courseData[6] = {
        "teeBoxLat" => 39.248032, "teeBoxLon" => -76.473226,
        "frontLat" => 39.248768, "frontLon" => -76.470503,
        "centerLat" => 39.248840, "centerLon" => -76.470383,
        "backLat" => 39.248912, "backLon" => -76.470299
    };
    
    // Hole #8 (Par 4)
    _courseData[7] = {
        "teeBoxLat" => 39.248686, "teeBoxLon" => -76.469727,
        "frontLat" => 39.245786, "frontLon" => -76.468934,
        "centerLat" => 39.245701, "centerLon" => -76.468853,
        "backLat" => 39.245595, "backLon" => -76.468815
    };
    
    // Hole #9 (Par 5)
    _courseData[8] = {
        "teeBoxLat" => 39.245997, "teeBoxLon" => -76.469590,
        "frontLat" => 39.247382, "frontLon" => -76.473664,
        "centerLat" => 39.247352, "centerLon" => -76.473787,
        "backLat" => 39.247333, "backLon" => -76.473915
    };
    
    // Hole #10 (Par 4)
    _courseData[9] = {
        "teeBoxLat" => 39.246952, "teeBoxLon" => -76.473073,
        "frontLat" => 39.245382, "frontLon" => -76.469628,
        "centerLat" => 39.245296, "centerLon" => -76.469511,
        "backLat" => 39.245215, "backLon" => -76.469393
    };
    
    // Hole #11 (Par 4)
    _courseData[10] = {
        "teeBoxLat" => 39.246208, "teeBoxLon" => -76.468355,
        "frontLat" => 39.249222, "frontLon" => -76.468744,
        "centerLat" => 39.249361, "centerLon" => -76.468756,
        "backLat" => 39.249476, "backLon" => -76.468804
    };
    
    // Hole #12 (Par 4)
    _courseData[11] = {
        "teeBoxLat" => 39.249682, "teeBoxLon" => -76.469498,
        "frontLat" => 39.249698, "frontLon" => -76.473130,
        "centerLat" => 39.249697, "centerLon" => -76.473344,
        "backLat" => 39.249685, "backLon" => -76.473526
    };
    
    // Hole #13 (Par 4)
    _courseData[12] = {
        "teeBoxLat" => 39.249890, "teeBoxLon" => -76.474312,
        "frontLat" => 39.251904, "frontLon" => -76.477597,
        "centerLat" => 39.251990, "centerLon" => -76.477690,
        "backLat" => 39.252044, "backLon" => -76.477790
    };
    
    // Hole #14 (Par 5)
    _courseData[13] = {
        "teeBoxLat" => 39.251398, "teeBoxLon" => -76.477874,
        "frontLat" => 39.248829669335215, "frontLon" => -76.47450751730452,
        "centerLat" => 39.24874006657675, "centerLon" => -76.47457999194881,
        "backLat" => 39.24865932553149, "backLon" => -76.47456727709894
    };
    
    // Hole #15 (Par 3)
    _courseData[14] = {
        "teeBoxLat" => 39.24889957910326, "teeBoxLon" => -76.47552979127963,
        "frontLat" => 39.249627227317475, "frontLon" => -76.47674533095854,
        "centerLat" => 39.24971485967715, "centerLon" => -76.47690045212705,
        "backLat" => 39.249790676351274, "backLon" => -76.47701107132299
    };
    
    // Hole #16 (Par 4)
    _courseData[15] = {
        "teeBoxLat" => 39.249589811224446, "teeBoxLon" => -76.47750313605175,
        "frontLat" => 39.25220211441712, "frontLon" => -76.47836586637102,
        "centerLat" => 39.252323219831624, "centerLon" => -76.47827686242188,
        "backLat" => 39.25243250990421, "backLon" => -76.47822981747733
    };
    
    // Hole #17 (Par 4)
    _courseData[16] = {
        "teeBoxLat" => 39.25240986423125, "teeBoxLon" => -76.47729654744356,
        "frontLat" => 39.25114616688508, "frontLon" => -76.47451681375685,
        "centerLat" => 39.25107921320021, "centerLon" => -76.47436423555831,
        "backLat" => 39.25102112098063, "backLon" => -76.4742510733944
    };
    
    // Hole #18 (Par 4)
    _courseData[17] = {
        "teeBoxLat" => 39.25145977222735, "teeBoxLon" => -76.47426288795727,
        "frontLat" => 39.25399188139234, "frontLon" => -76.47519206141156,
        "centerLat" => 39.25407706527352, "centerLon" => -76.47538762980079,
        "backLat" => 39.254124389607234, "backLon" => -76.47554652911705
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

function onStart(state) {
    // Start GPS tracking
    Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    
    // Start golf activity recording with current API
    _session = ActivityRecording.createSession({
        :name => "Sparrows Point Golf",
        :sport => Activity.SPORT_GOLF,
        :subSport => Activity.SUB_SPORT_GENERIC
    });
    _session.start();
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

function exportShotsAsJSON() {
    var jsonString = "{\"shots\":[";
    
    if (_shots != null) {
        for (var i = 0; i < _shots.size(); i++) {
            var shot = _shots[i];
            if (i > 0) {
                jsonString += ",";
            }
            jsonString += "{";
            jsonString += "\"hole\":" + shot.get("hole") + ",";
            jsonString += "\"stroke\":" + shot.get("stroke") + ",";
            jsonString += "\"lat\":" + shot.get("lat") + ",";
            jsonString += "\"lon\":" + shot.get("lon") + ",";
            jsonString += "\"gpsType\":\"" + shot.get("gpsType") + "\"";
            jsonString += "}";
        }
    }
    
    jsonString += "]}";
    return jsonString;
}

function uploadRoundData() {
    var jsonData = exportShotsAsJSON();
    
    // Get current date/time info
    var moment = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var dateString = moment.month + "/" + moment.day + "/" + moment.year + 
                    " " + moment.hour + ":" + moment.min.format("%02d");
    
    var url = "https://docs.google.com/forms/d/e/1FAIpQLSfY6SNBtxMq3YoIENPhNDGcx2-comn8xv71Yf1oxSFiY1s3qg/formResponse";
    
    var params = {
        "entry.1047502469" => "Sparrows Point",
        "entry.2091613779" => jsonData,
        "entry.217907754" => dateString // Normal date like "6/1/2025 2:30"
    };
    
    var options = {
        :method => Communications.HTTP_REQUEST_METHOD_POST,
        :headers => {
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
        }
    };

    Communications.makeWebRequest(url, params, options, method(:onUploadComplete));
}

function onUploadComplete(responseCode as Number, data as Dictionary) as Void {
    if (responseCode == 200) {
        // Upload successful - data should appear in your Google Form responses
    } else {
        // Upload failed
    }
}

function onStop(state) {
    // Upload shot data before closing activity
    uploadRoundData();
    
    // Stop and save golf activity
    if (_session != null && _session.isRecording()) {
        _session.stop();
        _session.save();
        _session = null;
    }
}

function completeHole() {
    _stats["holesCompleted"]++;
    if (_currentHole < 18) {
        _currentHole++;
        _strokes = 0; // Reset strokes for new hole
    }
    
    // Mark lap for completed hole
    if (_session != null && _session.isRecording()) {
        _session.addLap();
    }
    
    // Recalculate distances for new hole
    testAllHoles();
    
    WatchUi.requestUpdate();
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
    
    // Add shot location with proper error handling
    if (_shots != null) {
        var lat = null;
        var lon = null;
        var hasRealGPS = false;
        
        // Try to get real GPS coordinates
        try {
            if (_currentPosition != null && 
                _currentPosition has :toDegrees && 
                _currentPosition.toDegrees != null) {
                
                var pos = _currentPosition.toDegrees();
                if (pos != null && pos.size() >= 2) {
                    lat = pos[0];
                    lon = pos[1];
                    hasRealGPS = true;
                }
            }
        } catch (e) {
            // GPS access failed, will use fallback
            hasRealGPS = false;
        }
        
        // Fallback to course coordinates if no real GPS
        if (!hasRealGPS && _courseData != null) {
            var currentHoleIndex = _currentHole - 1;
            if (currentHoleIndex >= 0 && currentHoleIndex < _courseData.size()) {
                var holeData = _courseData[currentHoleIndex];
                lat = holeData.get("teeBoxLat");
                lon = holeData.get("teeBoxLon");
            }
        }
        
        // Record shot if we have coordinates
        if (lat != null && lon != null) {
            try {
                var shot = {
                    "hole" => _currentHole,
                    "stroke" => _strokes,
                    "lat" => lat,
                    "lon" => lon,
                    "gpsType" => hasRealGPS ? "real" : "simulated"
                };
                _shots.add(shot);
            } catch (e) {
                // Shot recording failed, but don't crash
            }
        }
    }
}

function getShots() {
    return _shots;
}

function getShotsForHole(holeNumber) {
    var holeShots = [];
    for (var i = 0; i < _shots.size(); i++) {
        if (_shots[i]["hole"] == holeNumber) {
            holeShots.add(_shots[i]);
        }
    }
    return holeShots;
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