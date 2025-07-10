class_name Dialog
extends Node

static func ShowMessagePopup(Title: String, Message: String, Accept: String = "OK", AcceptAction = null) -> void:
	var Target: AcceptDialog = AcceptDialog.new()
	Target.title = Title
	Target.dialog_text = Message
	Target.ok_button_text = Accept

	if AcceptAction != null:
		Target.confirmed.connect(AcceptAction)

	Constants.GlobalRoot.add_child(Target)
	Target.popup_centered()

static func ShowConfirmPopup(Title: String, Message: String, AcceptAction, CancelAction, Accept: String = "Yes", Cancel: String = "No") -> void:
	var Target: ConfirmationDialog = ConfirmationDialog.new()
	Target.title = Title
	Target.dialog_text = Message
	Target.ok_button_text = Accept
	Target.cancel_button_text = Cancel
	if AcceptAction != null:
		Target.confirmed.connect(AcceptAction)
	if CancelAction != null:
		Target.canceled.connect(CancelAction)

	Constants.GlobalRoot.add_child(Target)
	Target.popup_centered()
