;Simple wrapper for is [type], so that they can be used in expressions.

;Since this is meant to be included from other scripts, the autoexec portion
;skips to the end of the file.
Goto, EndOfIstype

;Determines if the supplied value is a whole number.
IsInteger(val) {
	if val is Integer
		return true
	else
		return false
}

;Determines if the supplied is a number with a decimal point.
IsFloat(val) {
	if val is Float
		return true
	else
		return false
}

;Determines if the supplied value is any kind of number.
IsNumber(val) {
	if val is Number
		return true
	else
		return false
}

;Determines if the supplied value contains only base-10 digits (0-9).
IsDigit(val) {
	if val is Digit
		return true
	else
		return false
}

;Determines if the supplied value contains only hexadecimal digits (0-F).
IsXDigit(val) {
	if val is XDigit
		return true
	else
		return false
}

;Determines if the supplied value contains only letters.
IsAlpha(val) {
	if val is Alpha
		return true
	else
		return false
}

;Determines if the supplied value contains only uppercase letters.
IsUpper(val) {
	if val is Upper
		return true
	else
		return false
}

;Determines if the supplied value contains only lowercase letters.
IsLower(val) {
	if val is Lower
		return true
	else
		return false
}

;Determines if the supplied value contains only base-10 digits (0-9) and
;letters.
IsAlNum(val) {
	if val is AlNum
		return true
	else
		return false
}

;Determines if the supplied value is empty or contains only whitespace
;characters (spaces, tabs, linefeeds, carriage returns, and formfeeds.
IsSpace(val) {
	if val is Space
		return true
	else
		return false
}

;Determines if the supplied value represents a valid date and/or time.
IsTime(val) {
	if val is Time
		return true
	else
		return false
}

EndOfIsType: