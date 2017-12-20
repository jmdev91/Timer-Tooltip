;Since this is meant to be included from other scripts, the autoexec portion
;skips to the end of the file.
Goto, EndOfOffsetTooltip

;Utility function for placing a tooltip a specific distance from the mouse
;cursor, optionally specifying a period after which the tooltip will be
;cleared.
OffsetTooltip(text, xoff, yoff, life = 0) {
	MouseGetPos, mx, my
	ToolTip, %text%, mx + xoff, my + yoff
	if(life > 0)
		SetTimer, HideTooltip, -%life%
	return
}

;A simple subroutine to clear the tooltip.
HideTooltip:
Tooltip
return

EndOfOffsetTooltip: