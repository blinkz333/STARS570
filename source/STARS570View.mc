using Toybox.WatchUi as WatchUi;

using Toybox.Graphics as Gfx;

using Toybox.System as Sys;

using Toybox.Time as Time;

using Toybox.Time.Gregorian as Gregorian;

using Toybox.SensorHistory as SensorHistory;

using Toybox.ActivityMonitor as ActivityMonitor;

using Toybox.Application.Properties as Properties;





class STARS570View extends WatchUi.WatchFace {



    var _timeFont;

    var _dateFont;



    var _lowPower = false;





    function initialize() {

        WatchFace.initialize();

    }





    function onLayout(dc as Gfx.Dc) as Void {



        _timeFont = WatchUi.loadResource(

            Rez.Fonts.TimeFont

        );



        _dateFont = WatchUi.loadResource(

            Rez.Fonts.DateFont

        );

    }





    function onShow() as Void {

    }





    // ============================================

    // THEME TEXT

    //

    // strongGlow:

    // true  = TIME

    // false = DATE / BATTERY / HR / STEPS

    // ============================================

    function drawThemeText(

        dc as Gfx.Dc,

        x,

        y,

        font,

        text,

        justify,

        normalColor,

        isTacticalRed,

        strongGlow

    ) as Void {



        // ========================================

        // ORIGINAL THEME

        // ========================================

        if (!isTacticalRed) {



            dc.setColor(

                normalColor,

                Gfx.COLOR_TRANSPARENT

            );



            dc.drawText(

                x,

                y,

                font,

                text,

                justify

            );



            return;

        }





        // ========================================

        // TACTICAL RED COLORS

        // ========================================

        var outerGlowColor = 0x3A070A;

        var innerGlowColor = 0x8A1017;

        var mainRedColor = 0xFF3038;





        // ========================================

        // OUTER GLOW - 2PX

        // ========================================

        dc.setColor(

            outerGlowColor,

            Gfx.COLOR_TRANSPARENT

        );



        dc.drawText(

            x - 2,

            y,

            font,

            text,

            justify

        );



        dc.drawText(

            x + 2,

            y,

            font,

            text,

            justify

        );



        dc.drawText(

            x,

            y - 2,

            font,

            text,

            justify

        );



        dc.drawText(

            x,

            y + 2,

            font,

            text,

            justify

        );





        // ========================================

        // STRONG TIME GLOW

        // ========================================

        if (strongGlow) {



            dc.drawText(

                x - 2,

                y - 1,

                font,

                text,

                justify

            );



            dc.drawText(

                x - 2,

                y + 1,

                font,

                text,

                justify

            );



            dc.drawText(

                x + 2,

                y - 1,

                font,

                text,

                justify

            );



            dc.drawText(

                x + 2,

                y + 1,

                font,

                text,

                justify

            );



            dc.drawText(

                x - 1,

                y - 2,

                font,

                text,

                justify

            );



            dc.drawText(

                x + 1,

                y - 2,

                font,

                text,

                justify

            );



            dc.drawText(

                x - 1,

                y + 2,

                font,

                text,

                justify

            );



            dc.drawText(

                x + 1,

                y + 2,

                font,

                text,

                justify

            );

        }





        // ========================================

        // INNER GLOW - 1PX

        // ========================================

        dc.setColor(

            innerGlowColor,

            Gfx.COLOR_TRANSPARENT

        );



        dc.drawText(

            x - 1,

            y,

            font,

            text,

            justify

        );



        dc.drawText(

            x + 1,

            y,

            font,

            text,

            justify

        );



        dc.drawText(

            x,

            y - 1,

            font,

            text,

            justify

        );



        dc.drawText(

            x,

            y + 1,

            font,

            text,

            justify

        );





        // ========================================

        // EXTRA INNER GLOW FOR TIME

        // ========================================

        if (strongGlow) {



            dc.drawText(

                x - 1,

                y - 1,

                font,

                text,

                justify

            );



            dc.drawText(

                x + 1,

                y - 1,

                font,

                text,

                justify

            );



            dc.drawText(

                x - 1,

                y + 1,

                font,

                text,

                justify

            );



            dc.drawText(

                x + 1,

                y + 1,

                font,

                text,

                justify

            );

        }





        // ========================================

        // MAIN RED TEXT

        // ========================================

        dc.setColor(

            mainRedColor,

            Gfx.COLOR_TRANSPARENT

        );



        dc.drawText(

            x,

            y,

            font,

            text,

            justify

        );

    }





    function onUpdate(dc as Gfx.Dc) as Void {



        // ========================================

        // LOW POWER / AOD

        // ========================================

        if (_lowPower) {



            drawLowPowerMode(dc);



            return;

        }





        // ========================================

        // THEME

        //

        // 0 = ORIGINAL

        // 1 = TACTICAL RED

        // ========================================

        var colorTheme =

            Properties.getValue("colorTheme");





        if (colorTheme == null) {

            colorTheme = 0;

        }





        var isTacticalRed =

            (colorTheme == 1);





        // ========================================

        // ORIGINAL COLORS

        // ========================================

        var dateColor = 0x69AFC2;

        var batteryColor = 0x69AFC2;

        var stepsColor = 0x69AFC2;



        var progressColor = 0x36D982;

        var progressBackground = 0x071416;





        // ========================================

        // TACTICAL RED COLORS

        // ========================================

        if (isTacticalRed) {



            dateColor = 0xFF3038;

            batteryColor = 0xFF3038;

            stepsColor = 0xFF3038;



            progressColor = 0xFF3038;

            progressBackground = 0x24080B;

        }





        // ========================================

        // BACKGROUND

        // ========================================

        dc.setColor(

            Gfx.COLOR_BLACK,

            Gfx.COLOR_BLACK

        );



        dc.clear();





        var bg;





        if (isTacticalRed) {



            bg = WatchUi.loadResource(

                Rez.Drawables.StarsBackgroundTactical

            );



        } else {



            bg = WatchUi.loadResource(

                Rez.Drawables.StarsBackgroundV4

            );

        }





        dc.drawBitmap(

            0,

            0,

            bg

        );





        // ========================================

        // DATE

        // ========================================

        var date = Gregorian.info(

            Time.now(),

            Time.FORMAT_SHORT

        );





        var dayNames = [

            "SUN",

            "MON",

            "TUE",

            "WED",

            "THU",

            "FRI",

            "SAT"

        ];





        var monthNames = [

            "JAN",

            "FEB",

            "MAR",

            "APR",

            "MAY",

            "JUN",

            "JUL",

            "AUG",

            "SEP",

            "OCT",

            "NOV",

            "DEC"

        ];





        var dayText =

            dayNames[date.day_of_week - 1];





        var monthText =

            monthNames[date.month - 1];





        var dateNumberText =

            date.day.format("%02d");





        // ========================================

        // DATE SETTINGS

        // ========================================

        var dayX = 75;

        var dateX = 76;



        var dayY = 145;

        var monthY = 165;



        var dateSpacing = 5;





        // ========================================

        // DAY

        // ========================================

        drawThemeText(

            dc,

            dayX,

            dayY,

            _dateFont,

            dayText,

            Gfx.TEXT_JUSTIFY_LEFT,

            dateColor,

            isTacticalRed,

            false

        );





        // ========================================

        // MONTH

        // ========================================

        drawThemeText(

            dc,

            dateX,

            monthY,

            _dateFont,

            monthText,

            Gfx.TEXT_JUSTIFY_LEFT,

            dateColor,

            isTacticalRed,

            false

        );





        var monthWidth =

            dc.getTextWidthInPixels(

                monthText,

                _dateFont

            );





        // ========================================

        // DATE NUMBER

        // ========================================

        drawThemeText(

            dc,

            dateX + monthWidth + dateSpacing,

            monthY,

            _dateFont,

            dateNumberText,

            Gfx.TEXT_JUSTIFY_LEFT,

            dateColor,

            isTacticalRed,

            false

        );





        // ========================================

        // BATTERY

        // ========================================

        var stats =

            Sys.getSystemStats();





        var battery =

            stats.battery;





        var batteryText =

            battery.format("%d") + "%";





        var batteryX = 353;

        var batteryY = 145;





        drawThemeText(

            dc,

            batteryX,

            batteryY,

            _dateFont,

            batteryText,

            Gfx.TEXT_JUSTIFY_CENTER,

            batteryColor,

            isTacticalRed,

            false

        );





        // ========================================

        // CURRENT TIME

        // ========================================

        var clock =

            Sys.getClockTime();





        var hour =

            clock.hour;





        // ========================================

        // SUPPORT 12 / 24 HOUR

        // ========================================

        var timeFormat =

            Properties.getValue("timeFormat");





        if (timeFormat == null) {

            timeFormat = 0;

        }





        var use24Hour =

            Sys.getDeviceSettings().is24Hour;





        // 0 = System Default

        // 1 = 12 Hour

        // 2 = 24 Hour

        if (timeFormat == 1) {



            use24Hour = false;



        } else if (timeFormat == 2) {



            use24Hour = true;

        }





        if (!use24Hour) {



            hour = hour % 12;



            if (hour == 0) {

                hour = 12;

            }

        }





        var hourText =

            hour.format("%02d");





        var colonText =

            ":";





        var minuteText =

            clock.min.format("%02d");





        // ========================================

        // TIME SETTINGS

        // ========================================

        var timeY = 180;



        var colonY = 173;



        var colonSpacing = 14;



        var timeColor = 0xC7C9C6;

        var colonColor = 0xA82C32;





        // ========================================

        // MEASURE TIME

        // ========================================

        var hourWidth =

            dc.getTextWidthInPixels(

                hourText,

                _timeFont

            );





        var colonWidth =

            dc.getTextWidthInPixels(

                colonText,

                _timeFont

            );





        var minuteWidth =

            dc.getTextWidthInPixels(

                minuteText,

                _timeFont

            );





        var totalWidth =

            hourWidth +

            colonSpacing +

            colonWidth +

            colonSpacing +

            minuteWidth;





        var startX =

            (dc.getWidth() - totalWidth) / 2;





        // ========================================

        // HOURS

        // ========================================

        drawThemeText(

            dc,

            startX,

            timeY,

            _timeFont,

            hourText,

            Gfx.TEXT_JUSTIFY_LEFT,

            timeColor,

            isTacticalRed,

            true

        );





        // ========================================

        // COLON

        // ========================================

        var colonX =

            startX +

            hourWidth +

            colonSpacing;





        if ((clock.sec % 2) == 0) {



            drawThemeText(

                dc,

                colonX,

                colonY,

                _timeFont,

                colonText,

                Gfx.TEXT_JUSTIFY_LEFT,

                colonColor,

                isTacticalRed,

                true

            );

        }





        // ========================================

        // MINUTES

        // ========================================

        var minuteX =

            colonX +

            colonWidth +

            colonSpacing;





        drawThemeText(

            dc,

            minuteX,

            timeY,

            _timeFont,

            minuteText,

            Gfx.TEXT_JUSTIFY_LEFT,

            timeColor,

            isTacticalRed,

            true

        );





        // ========================================

        // HEART RATE / VITAL

        // ========================================

        var heartRateText = "--";





        var hrIterator =

            SensorHistory.getHeartRateHistory({

                :period => 1,

                :order => SensorHistory.ORDER_NEWEST_FIRST

            });





        if (hrIterator != null) {



            var sample =

                hrIterator.next();



            if (

                sample != null &&

                sample.data != null

            ) {



                heartRateText =

                    sample.data.format("%d");

            }

        }





        // ========================================

        // HEART RATE SETTINGS

        // ========================================

        var heartRateX = 110;

        var heartRateY = 285;



        var heartRateColor = 0xC7C9C6;





        drawThemeText(

            dc,

            heartRateX,

            heartRateY,

            _dateFont,

            heartRateText,

            Gfx.TEXT_JUSTIFY_CENTER,

            heartRateColor,

            isTacticalRed,

            false

        );





        // ========================================

        // STEPS / MISSION

        // ========================================

        var activity =

            ActivityMonitor.getInfo();





        var steps = 0;

        var hasSteps = false;





        if (activity.steps != null) {



            steps =

                activity.steps;



            hasSteps =

                true;

        }





        // ========================================

        // STEPS SETTINGS

        // ========================================

        var stepsX = 329;

        var stepsY = 285;



        var commaSpacing = -5;





        // ========================================

        // NO STEP DATA

        // ========================================

        if (!hasSteps) {



            drawThemeText(

                dc,

                stepsX,

                stepsY,

                _dateFont,

                "--",

                Gfx.TEXT_JUSTIFY_CENTER,

                stepsColor,

                isTacticalRed,

                false

            );





        // ========================================

        // STEPS UNDER 1,000

        // ========================================

        } else if (steps < 1000) {



            var stepsText =

                steps.format("%d");





            drawThemeText(

                dc,

                stepsX,

                stepsY,

                _dateFont,

                stepsText,

                Gfx.TEXT_JUSTIFY_CENTER,

                stepsColor,

                isTacticalRed,

                false

            );





        // ========================================

        // STEPS 1,000+

        // ========================================

        } else {



            var thousands =

                (steps / 1000).toNumber();



            var remainder =

                steps % 1000;



            var leftText =

                thousands.format("%d");



            var commaText =

                ",";



            var rightText =

                remainder.format("%03d");





            // ====================================

            // MEASURE PARTS

            // ====================================

            var leftWidth =

                dc.getTextWidthInPixels(

                    leftText,

                    _dateFont

                );





            var commaWidth =

                dc.getTextWidthInPixels(

                    commaText,

                    _dateFont

                );





            var rightWidth =

                dc.getTextWidthInPixels(

                    rightText,

                    _dateFont

                );





            var totalStepsWidth =

                leftWidth +

                commaWidth +

                commaSpacing +

                rightWidth;





            var stepsStartX =

                stepsX -

                (totalStepsWidth / 2);





            // ====================================

            // LEFT

            // ====================================

            drawThemeText(

                dc,

                stepsStartX,

                stepsY,

                _dateFont,

                leftText,

                Gfx.TEXT_JUSTIFY_LEFT,

                stepsColor,

                isTacticalRed,

                false

            );





            // ====================================

            // COMMA

            // ====================================

            var commaX =

                stepsStartX +

                leftWidth;





            drawThemeText(

                dc,

                commaX,

                stepsY,

                _dateFont,

                commaText,

                Gfx.TEXT_JUSTIFY_LEFT,

                stepsColor,

                isTacticalRed,

                false

            );





            // ====================================

            // RIGHT

            // ====================================

            var rightX =

                commaX +

                commaWidth +

                commaSpacing;





            drawThemeText(

                dc,

                rightX,

                stepsY,

                _dateFont,

                rightText,

                Gfx.TEXT_JUSTIFY_LEFT,

                stepsColor,

                isTacticalRed,

                false

            );

        }





        // ========================================

        // STEP GOAL PROGRESS

        //

        // Read Step Goal from Settings.

        //

        // Supported values:

        // 5000

        // 7500

        // 10000

        // 12500

        // 15000

        //

        // Default / fallback = 10000

        // ========================================

        var stepGoal =

            Properties.getValue("stepGoal");





        // ========================================

        // STEP GOAL FALLBACK

        // ========================================

        if (

            stepGoal == null ||

            stepGoal <= 0

        ) {



            stepGoal = 10000;

        }





        var currentSteps = 0;





        if (activity.steps != null) {



            currentSteps =

                activity.steps;

        }





        // ========================================

        // PROGRESS BAR SETTINGS

        // ========================================

        var progressX = 113;

        var progressY = 328;



        var progressWidth = 228;

        var progressHeight = 4;





        // ========================================

        // CALCULATE PROGRESS

        //

        // Progress now uses the Step Goal

        // selected by the user.

        // ========================================

        var progressWidthFilled =

            (

                currentSteps *

                progressWidth /

                stepGoal

            ).toNumber();





        // ========================================

        // LIMIT TO FULL BAR

        // ========================================

        if (

            progressWidthFilled >

            progressWidth

        ) {



            progressWidthFilled =

                progressWidth;

        }





        // ========================================

        // SAFETY

        // ========================================

        if (progressWidthFilled < 0) {



            progressWidthFilled = 0;

        }





        // ========================================

        // PROGRESS BACKGROUND

        // ========================================

        dc.setColor(

            progressBackground,

            Gfx.COLOR_TRANSPARENT

        );





        dc.fillRectangle(

            progressX,

            progressY,

            progressWidth,

            progressHeight

        );





        // ========================================

        // PROGRESS FILL

        //

        // No glow in Tactical Red.

        // ========================================

        if (progressWidthFilled > 0) {



            dc.setColor(

                progressColor,

                Gfx.COLOR_TRANSPARENT

            );





            dc.fillRectangle(

                progressX,

                progressY,

                progressWidthFilled,

                progressHeight

            );

        }

    }





    // ============================================

    // AOD / LOW POWER

    //

    // ORIGINAL:

    // Gray time + dark red colon

    //

    // TACTICAL RED:

    // Dark red time + darker red colon

    //

    // No glow in AOD.

    // ============================================

    function drawLowPowerMode(

        dc as Gfx.Dc

    ) as Void {



        // ========================================

        // BLACK BACKGROUND

        // ========================================

        dc.setColor(

            Gfx.COLOR_BLACK,

            Gfx.COLOR_BLACK

        );



        dc.clear();





        // ========================================

        // READ CURRENT THEME

        //

        // 0 = ORIGINAL / RPD BLUE

        // 1 = TACTICAL RED

        // ========================================

        var colorTheme =

            Properties.getValue("colorTheme");





        if (colorTheme == null) {

            colorTheme = 0;

        }





        var isTacticalRed =

            (colorTheme == 1);





        // ========================================

        // GET CURRENT TIME

        // ========================================

        var clock =

            Sys.getClockTime();





        var hour =

            clock.hour;





        // ========================================

        // SUPPORT SYSTEM 12 / 24 HOUR

        // ========================================

        var timeFormat =

            Properties.getValue("timeFormat");





        if (timeFormat == null) {

            timeFormat = 0;

        }





        var use24Hour =

            Sys.getDeviceSettings().is24Hour;





        // 0 = System Default

        // 1 = 12 Hour

        // 2 = 24 Hour

        if (timeFormat == 1) {



            use24Hour = false;



        } else if (timeFormat == 2) {



            use24Hour = true;

        }





        if (!use24Hour) {



            hour = hour % 12;



            if (hour == 0) {

                hour = 12;

            }

        }





        var hourText =

            hour.format("%02d");





        var colonText =

            ":";





        var minuteText =

            clock.min.format("%02d");





        // ========================================

        // DEFAULT ORIGINAL AOD COLORS

        // ========================================

        var aodColor =

            0x666666;





        var aodColonColor =

            0x5A2023;





        // ========================================

        // TACTICAL RED AOD

        //

        // Dark red display.

        // No glow.

        // ========================================

        if (isTacticalRed) {



            aodColor =

                0x8A181C;





            aodColonColor =

                0x651015;

        }





        // ========================================

        // TIME SPACING

        // ========================================

        var colonSpacing =

            14;





        // ========================================

        // PIXEL SHIFT

        //

        // Move AOD every minute between

        // four positions to reduce burn-in.

        // ========================================

        var shiftIndex =

            clock.min % 4;



        var shiftX = 0;

        var shiftY = 0;





        if (shiftIndex == 0) {



            shiftX = -4;

            shiftY = -3;



        } else if (shiftIndex == 1) {



            shiftX = 4;

            shiftY = -3;



        } else if (shiftIndex == 2) {



            shiftX = 4;

            shiftY = 3;



        } else {



            shiftX = -4;

            shiftY = 3;

        }





        // ========================================

        // MEASURE TIME

        // ========================================

        var hourWidth =

            dc.getTextWidthInPixels(

                hourText,

                _timeFont

            );





        var colonWidth =

            dc.getTextWidthInPixels(

                colonText,

                _timeFont

            );





        var minuteWidth =

            dc.getTextWidthInPixels(

                minuteText,

                _timeFont

            );





        var totalWidth =

            hourWidth +

            colonSpacing +

            colonWidth +

            colonSpacing +

            minuteWidth;





        // ========================================

        // CENTER TIME

        // ========================================

        var startX =

            (

                dc.getWidth() -

                totalWidth

            ) / 2;



        startX +=

            shiftX;





        // ========================================

        // AOD Y POSITIONS

        // ========================================

        var timeY =

            180 + shiftY;



        var colonY =

            173 + shiftY;





        // ========================================

        // HOURS

        // ========================================

        dc.setColor(

            aodColor,

            Gfx.COLOR_TRANSPARENT

        );





        dc.drawText(

            startX,

            timeY,

            _timeFont,

            hourText,

            Gfx.TEXT_JUSTIFY_LEFT

        );





        // ========================================

        // COLON POSITION

        // ========================================

        var colonX =

            startX +

            hourWidth +

            colonSpacing;





        // ========================================

        // COLON

        //

        // Always visible in AOD.

        // ========================================

        dc.setColor(

            aodColonColor,

            Gfx.COLOR_TRANSPARENT

        );





        dc.drawText(

            colonX,

            colonY,

            _timeFont,

            colonText,

            Gfx.TEXT_JUSTIFY_LEFT

        );





        // ========================================

        // MINUTES POSITION

        // ========================================

        var minuteX =

            colonX +

            colonWidth +

            colonSpacing;





        // ========================================

        // MINUTES

        // ========================================

        dc.setColor(

            aodColor,

            Gfx.COLOR_TRANSPARENT

        );





        dc.drawText(

            minuteX,

            timeY,

            _timeFont,

            minuteText,

            Gfx.TEXT_JUSTIFY_LEFT

        );

    }





    function onHide() as Void {

    }





    // ============================================

    // ENTER LOW POWER / AOD

    // ============================================

    function onEnterSleep() as Void {



        _lowPower = true;



        WatchUi.requestUpdate();

    }





    // ============================================

    // EXIT LOW POWER / AOD

    // ============================================

    function onExitSleep() as Void {



        _lowPower = false;



        WatchUi.requestUpdate();

    }

}