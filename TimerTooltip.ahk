#NoEnv

#include OffsetTooltip.ahk
#include TimerTooltipConfig.ahk

;Script state variables
time_left = 0		;Milliseconds remaining on the counter
tasks_done = 0		;Number of times the hotkey has been used since reset
x1_ready := true	;Whether or not the main hotkey is ready for another click
last_interval = 0	;Tracks last time the Countdown sub was run.

;Main hotkey, clicks the spot and begins the countdown as long as the script is
;not in the process of counting down or waiting for the cycle time to elapse.
XButton1::
if(x1_ready) {
	;Only click if not waiting for the counter to reset.
	if(tasks_per = 0 || tasks_done < tasks_per) {
		;Click the mouse, reset the time left on the countdown, increment the
		;task counter, and make sure it doesn't reset from the last click.
		Click
		time_left := time_per
		++tasks_done
		SetTimer, ResetCounter, Off
	}
	;Prevent further clicks until the script is ready for them.
	x1_ready := false
	;Clear the time from the last run of Countdown so that the actual time
	;elapsed between counts can be calculated correctly, then begin the
	;countdown.
	last_interval := A_TickCount
	Gosub, Countdown
}
return

;Reset hotkey, resets the countdown and task counter.
XButton2::
if(time_left || tasks_done) {
	SetTimer, Countdown, Off
	time_left = 0
	tasks_done = 0
	x1_ready := true
	Gosub, HideTooltip
}
return

;Configuration hotkey, shows a window where the user can change the settings.
Control & T::
Gosub, GuiOpen
return

;A subroutine to update the state of the tooltip. If the countdown is ongoing,
;it displays the number of seconds remaining and optionally the number of tasks
;completed compared to the total per cycle. Otherwise it indicates either that
;the user can click again or that the cycle is complete.
Countdown:
;If the cycle is complete, indicate that and initiate the delay, if any. 
if(tasks_per > 0 && tasks_done >= tasks_per) {
	output = %msg_done%
	SetTimer, CycleDone, -%cycle_time%
	time_left = 0
} 
;Count the actual time since the last run, so that delays or timer inaccuracies
;don't pile up.
real_interval := A_TickCount - last_interval
time_left -= real_interval
last_interval := A_TickCount
if(time_left > 0) {
	;To minimize additional timer delays, begin the timer for the next count.
	SetTimer, Countdown, -%interval%
	;Determine the approprate number of decimal places based on the update
	;interval and round the remaining time based on that.
	places = 0
	if(Mod(interval, 1000)) {
		++places
		if(Mod(interval, 100)) {
			++places
			if(Mod(interval, 10)) {
				++places
			}
		}
	}
	output := Round(time_left / 1000, places) "s"
	;Tack on the task counter, if applicable.
	if(tasks_per > 0) {
		output = %output%`n%tasks_done%/%tasks_per%
	}
} else {
	if(tasks_per = 0) {
		;Not tracking tasks done, just display ready message.
		output = %msg_ready%
		tasks_done = 0
		x1_ready := true
	} else  if(tasks_done < tasks_per) {
		;Task is not complete, display ready message and show that counter.
		output = %msg_ready%`n%tasks_done%/%tasks_per%
		x1_ready := true
	}
	if(reset_time > 0) {
		;Prepare the automatic reset of the task counter.
		SetTimer, ResetCounter, -%reset_time%
	}
}
;Finally, display the tooltip.
OffsetTooltip(output, tip_xoff, tip_yoff, tip_time)
return

;A subroutine to ready the main hotkey to accept input again.
CycleDone:
x1_ready := true
return

;A subroutine to reset the task counter.
ResetCounter:
tasks_done = 0
return