#NoEnv

#include IsType.ahk

;Configuration variables
time_per = 3000	;Milliseconds between valid clicks
interval = 100		;Number of milliseconds per update of the timer
tasks_per = 0		;Number of hotkey uses before the user has to wait for reset
cycle_time = 0		;Number of milliseconds to wait after a complete cycle
reset_time = 0		;Number of milliseconds before the task counter resets
tip_xoff = 32		;How far away from the mouse the tooltip will appear, horizontally
tip_yoff = 0		;How far away from the mouse the tooltip will appear, vertically
tip_time = 1000	;Milliseconds before the tooltip disappears
msg_ready = Ready!	;Message displayed when the next action is ready
msg_done = Bank!	;Message displayed when the user has to wait for reset

Gosub, LoadConfig

;GUI state variables
gui_time_per := time_per
gui_interval := interval
gui_tasks_per := tasks_per
gui_cycle_time := cycle_time
gui_reset_time := reset_time
gui_tip_xoff := tip_xoff
gui_tip_yoff := tip_yoff
gui_tip_time := tip_time
gui_msg_ready := msg_ready
gui_msg_done := msg_done
;gui_validate_ok	<-Just shown to have the complete state list in one place.

Goto, EndOfTimerTooltipConfig

;A subroutine to read the values for each configuration variable from
;TimerTooltip.ini.
LoadConfig:
;Only load the values from TimerTooltip.ini if it exists, otherwise keep the
;defaults.
if(FileExist("TimerTooltip.ini")) {
	IniRead, time_per, TimerTooltip.ini, Config, TimePerClick
	IniRead, interval, TimerTooltip.ini, Config, UpdateInterval
	IniRead, tasks_per, TimerTooltip.ini, Config, TasksPerCycle
	IniRead, cycle_time, TimerTooltip.ini, Config, CycleTime
	IniRead, reset_time, TimerTooltip.ini, Config, ResetTime
	IniRead, tip_xoff, TimerTooltip.ini, Config, TooltipXOffset
	IniRead, tip_yoff, TimerTooltip.ini, Config, TooltipYOffset
	IniRead, tip_time, TimerTooltip.ini, Config, TooltipLifetime
	IniRead, msg_ready, TimerTooltip.ini, ReadyMessage
	IniRead, msg_done, TimerTooltip.ini, DoneMessage
}
return

;A subroutine to create the configuration window, add the proper controls to
;it, and display it.
GuiOpen:
Gui, New
;Most of the controls are split up into 3 columns. For layout purposes, the
;controls are added column-by-column.

;Label text column, each gives a short description of what the edit control to
;its right is for.
Gui, Add, Text, Section, Time Per Click:
Gui, Add, Text, , Update Interval:
Gui, Add, Text, , Tasks Per Cycle:
Gui, Add, Text, , Cycle Time:
Gui, Add, Text, , Reset Time:
Gui, Add, Text, , Tooltip X Offset:
Gui, Add, Text, , Tooltip Y Offset:
Gui, Add, Text, , Tooltip Lifetime:
Gui, Add, Text, r2, Ready Message:
Gui, Add, Text, r2, Done Message:

;Edit column, each holds the entered or default value for a configuration
;variable which will be applied to that variable when Apply or Ok is clicked.
Gui, Add, Edit, ys w100 vgui_time_per, %time_per%
Gui, Add, Edit, wp vgui_interval, %interval%
Gui, Add, Edit, wp vgui_tasks_per, %tasks_per%
Gui, Add, Edit, wp vgui_cycle_time, %cycle_time%
Gui, Add, Edit, wp vgui_reset_time, %reset_time%
Gui, Add, Edit, wp vgui_tip_xoff, %tip_xoff%
Gui, Add, Edit, wp vgui_tip_yoff, %tip_yoff%
Gui, Add, Edit, wp vgui_tip_time, %tip_time%
Gui, Add, Edit, wp r2 vgui_msg_ready, %msg_ready%
Gui, Add, Edit, wp r2 vgui_msg_done, %msg_done%

;Description text column, each gives a more precise description of what the
;edit control to its left does than the corresponding label.
Gui, Add, Text, ys, How many ms between valid clicks.
Gui, Add, Text, , How many ms between visible updates of the timer.
Gui, Add, Text, , How many tasks you want to do per cycle (i.e. per inventory).
Gui, Add, Text, , How many ms you must wait after completing a cycle.
Gui, Add, Text, , How many ms of not pressing the hotkey before the counter resets.
Gui, Add, Text, , The x position of the tooltip relative to the mouse cursor.
Gui, Add, Text, , The y position of the tooltip relative to the mouse cursor.
Gui, Add, Text, , How many ms tooltip remains visible.
Gui, Add, Text, r2, The message to display when you can click again.
Gui, Add, Text, r2, The message to display when the cycle is finished.

;Button row, each works as expected by its name.
Gui, Add, Button, Section xs gApply, Apply
Gui, Add, Button, ys gOk, Ok
Gui, Add, Button, ys gCancel, Cancel
Gui, Show
return

;A sub to apply the entered values to their corresponding configuration
;variables if they validate succesffuly. Each invalid value shows a message
;box indicating what was wrong with it.
SaveConfig:
Gui, Submit, NoHide
gui_validate_ok := true

;These tests validate each entered value. All of them ensure that what was
;entered was an integer value, while some of them also ensure that it was
;positive. Successful validation saves the entered value to the approprate
;configuration variable.
if (IsInt(gui_time_per) && gui_time_per >= 0) {
	time_per := gui_time_per
} else {
	MsgBox, Must enter a positive, whole number for Time Per Click.
	gui_time_per := time_per
	GuiControl, Text, gui_time_per, %gui_time_per%
	gui_validate_ok := false
}
if (IsInt(gui_interval) && gui_interval >= 0) {
	interval := gui_interval
} else {
	MsgBox, Must enter a positive, whole number for Update Interval.
	gui_interval := interval
	GuiControl, Text, gui_interval, %gui_interval%
	gui_validate_ok := false
}
if (IsInt(gui_tasks_per) && gui_tasks_per >= 0) {
	tasks_per := gui_tasks_per
} else {
	MsgBox, Must enter a positive, whole number for Tasks Per Cycle.
	gui_tasks_per := tasks_per
	GuiControl, Text, gui_tasks_per, %gui_tasks_per%
	gui_validate_ok := false
}
if (IsInt(gui_cycle_time) && gui_cycle_time >= 0) {
	cycle_time := gui_cycle_time
} else {
	MsgBox, Must enter a positive, whole number for Cycle Time.
	gui_cycle_time := cycle_time
	GuiControl, Text, gui_cycle_time, %gui_cycle_time%
	gui_validate_ok := false
}
if (IsInt(gui_reset_time) && gui_reset_time >= 0) {
	reset_time := gui_reset_time
} else {
	MsgBox, Must enter a positive, whole number for Reset Time.
	gui_reset_time := reset_time
	GuiControl, Text, gui_reset_time, %gui_reset_time%
	gui_validate_ok := false
}
if (IsInt(gui_tip_xoff)) {
	tip_xoff := gui_tip_xoff
} else {
	MsgBox, Must enter a whole number for Tooltip X Offset.
	gui_tip_xoff := tip_xoff
	GuiControl, Text, gui_tip_xoff, %gui_tip_xoff%
	gui_validate_ok := false
}
if (IsInt(gui_tip_yoff)) {
	tip_yoff := gui_tip_yoff
} else {
	Msgbox, Must enter a whole number for Tooltip Y Offset.
	gui_tip_yoff := tip_yoff
	GuiControl, Text, gui_tip_yoff, %gui_tip_yoff%
	gui_validate_ok := false
}
if (IsInt(gui_tip_time) && gui_tip_time >= 0) {
	tip_time := gui_tip_time
} else {
	MsgBox, Must enter a positive, whole number for Tooltip Lifetime.
	gui_tip_time := tip_time
	GuiControl, Text, gui_tip_time, %gui_tip_time%
	gui_validate_ok := false
}

;These values can't be invalid, so they're always saved.
msg_ready := gui_msg_ready
msg_done := gui_msg_done

;Saves the newly modified configuration variables to TimerTooltip.ini.
Gosub, SaveConfigFile
return

;A subroutine to write the values of each configuration variable to
;TimerTooltip.ini.
SaveConfigFile:
;The text values can be multi-line, so to avoid writing them repeatedly they
;need to be deleted first.
IniDelete, TimerTooltip.ini, ReadyMessage
IniDelete, TimerTooltip.ini, DoneMessage

IniWrite, %time_per%, TimerTooltip.ini, Config, TimePerClick
IniWrite, %interval%, TimerTooltip.ini, Config, UpdateInterval
IniWrite, %tasks_per%, TimerTooltip.ini, Config, TasksPerCycle
IniWrite, %cycle_time%, TimerTooltip.ini, Config, CycleTime
IniWrite, %reset_time%, TimerTooltip.ini, Config, ResetTime
IniWrite, %tip_xoff%, TimerTooltip.ini, Config, TooltipXOffset
IniWrite, %tip_yoff%, TimerTooltip.ini, Config, TooltipYOffset
IniWrite, %tip_time%, TimerTooltip.ini, Config, TooltipLifetime
IniWrite, %msg_ready%, TimerTooltip.ini, ReadyMessage
IniWrite, %msg_done%, TimerTooltip.ini, DoneMessage
return

;The subroutine that gets run whenever the user clicks the Apply button.
;Just uses SaveConfig to apply the valid entries to their corresponding
;configuration variables.
Apply:
Gosub, SaveConfig
return

;The subroutine that gets run whenever the user clicks the Ok button. Uses
;SaveConfig to apply the valid entries to their corresponding configuration
;variables and closes the window if all entries were valid.
Ok:
Gosub, SaveConfig
if(gui_validate_ok)
	Gui, Destroy
return

;The subroutine that gets run whenever the user clicks the Cancel button.
;Closes the window.
Cancel:
Gui, Destroy
return

EndOfTimerTooltipConfig: