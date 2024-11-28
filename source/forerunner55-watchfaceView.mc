import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
// import Toybox.Time;
import Toybox.Time.Gregorian;

class forerunner55_watchfaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        // ##### DATE #####
        var viewDate = View.findDrawableById("dateLabel") as Text;
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format(
            "$1$ $2$ $3$ $4$",
            [
                today.day_of_week,
                today.day,
                today.month,
                today.year
            ]
        );
        viewDate.setLocation(104, 60);
        viewDate.setFont(Graphics.FONT_XTINY);
        viewDate.setText(dateString);

        // ##### TIME #####
        var viewTime = View.findDrawableById("timeLabel") as Text;
        var timeFormat = "$1$:$2$:$3$";
        var hours = today.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, today.min.format("%02d"), today.sec.format("%02d")]);
        viewTime.setText(timeString);

        // ##### BATTERY #####
        var viewBattery = View.findDrawableById("batteryLabel") as Text;
        var batteryLevel = System.getSystemStats().battery;
        var batteryLevelFormat = "$1$";
        viewBattery.setLocation(104, 125);
        var batteryLevelText = "";
        if (batteryLevel.toNumber() >= 85 && batteryLevel.toNumber() < 100) {
            viewBattery.setColor(Graphics.COLOR_BLUE);
            batteryLevelText = "IIIIII";
        } else if (batteryLevel.toNumber() >= 70 && batteryLevel.toNumber() < 85) {
            batteryLevelText = "IIIII";
        } else if (batteryLevel.toNumber() >= 50 && batteryLevel.toNumber() < 70) {
            batteryLevelText = "IIII";
        } else if (batteryLevel.toNumber() >= 30 && batteryLevel.toNumber() < 50) {
            batteryLevelText = "III";
        } else if (batteryLevel.toNumber() >= 15 && batteryLevel.toNumber() < 30) {
            batteryLevelText = "II";
        } else if (batteryLevel.toNumber() >= 5 && batteryLevel.toNumber() < 15) {
            viewBattery.setColor(Graphics.COLOR_YELLOW);
            batteryLevelText = "I";
        } else if (batteryLevel.toNumber() < 5) {
            viewBattery.setColor(Graphics.COLOR_RED);
            batteryLevelText = "!";
        }
        viewBattery.setText(Lang.format(batteryLevelFormat, [batteryLevelText]));

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
