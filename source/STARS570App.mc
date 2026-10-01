import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;


class STARS570App extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }


    // ========================================
    // APPLICATION START
    // ========================================
    function onStart(state as Dictionary?) as Void {
    }


    // ========================================
    // APPLICATION STOP
    // ========================================
    function onStop(state as Dictionary?) as Void {
    }


    // ========================================
    // SETTINGS CHANGED
    //
    // Called when the user changes
    // Color Theme in App Settings.
    // ========================================
    function onSettingsChanged() as Void {

        WatchUi.requestUpdate();
    }


    // ========================================
    // INITIAL VIEW
    // ========================================
    function getInitialView() as [Views] or [Views, InputDelegates] {

        return [
            new STARS570View()
        ];
    }
}


function getApp() as STARS570App {

    return Application.getApp() as STARS570App;
}