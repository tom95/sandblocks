selection
selectNextStatement

	selectionDownHistory removeAll.
	
	(self selection topFirstMorphThat: [:m | m isStatement and: [m ~= self selection]]) ifNotNil: [:s | ^ self select: s].
	(self selection morphAfterThat: #isStatement) ifNotNil: [:s | ^ self select: s].
	((self selection ownerSatisfying: #isStatement) morphAfterThat: #isStatement) ifNotNil: [:s | self select: s]