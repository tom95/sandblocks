as yet unclassified
mouseUp: anEvent

	super mouseUp: anEvent.
	isDown := false.
	oldCursor ifNotNil: #show.
	
	scrubbingCommand oldValue ~= self contents ifTrue: [
		self sandblockEditor do: (scrubbingCommand value: self contents)].
	scrubbingCommand := nil