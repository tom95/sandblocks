as yet unclassified
status: aSymbol

	status := aSymbol.
	self updateLabel.
	aSymbol ~= #notActive ifTrue: [self run]