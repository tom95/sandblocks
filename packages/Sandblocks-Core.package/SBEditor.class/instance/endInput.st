input
endInput

	| command input |
	currentInput ifNil: [^ self].
	command := currentInputCommand.
	input := currentInput.
	currentInput := nil.
	currentInputCommand := nil.
	
	input stopEditing: command.
	self mode: #command.
	
	command hasChange
		ifTrue: [self do: command]
		ifFalse: [undoStack ifNotEmpty: [undoStack last shouldMergeWithNext: false]]