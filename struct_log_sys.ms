
struct LogSys
(
	source = "",

	fn Info msg_text = (format "%_INFO: % | %\n" source (GetTimeStamp()) msg_text),
	fn Warning msg_text = (format "%_WARNING: % | %\n" source (GetTimeStamp()) msg_text),
	fn Error msg_text = (format "%_ERROR: % | %\n" source (GetTimeStamp()) msg_text)
)