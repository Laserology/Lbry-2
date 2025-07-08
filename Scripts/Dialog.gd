class_name Dialog
extends Node

static func ShowMessagePopup(Title: String, Message: String, Accept: String = "OK", AcceptAction = null) -> AcceptDialog:
	var Target: AcceptDialog = AcceptDialog.new()
	Target.title = Title
	Target.dialog_text = Message
	Target.ok_button_text = Accept

	if AcceptAction != null:
		Target.confirmed.connect(AcceptAction)

	return Target

static func ShowConfirmPopup(Title: String, Message: String, AcceptAction, CancelAction, Accept: String = "Yes", Cancel: String = "No") -> ConfirmationDialog:
	var Target: ConfirmationDialog = ConfirmationDialog.new()
	Target.title = Title
	Target.dialog_text = Message
	Target.ok_button_text = Accept
	Target.cancel_button_text = Cancel
	if AcceptAction != null:
		Target.confirmed.connect(AcceptAction)
	if CancelAction != null:
		Target.canceled.connect(CancelAction)
	return Target
