Extension { #name : #Collection }

{ #category : #'*Sandblocks-Core-converting' }
Collection >> asCollectionView: converter [
	<convert>
	
	converter
		if: [self size < 20 and: [self isString not and: [self isDictionary not]]]
		do: [SBCollection new interface: converter objectInterface object: self]
]

{ #category : #'*Sandblocks-Core' }
Collection >> asSandblockShortcut [

	^ self
]

{ #category : #'*Sandblocks-Core' }
Collection >> includesRepresentation: aSymbol [

	^ self includes: aSymbol
]

{ #category : #'*Sandblocks-Core' }
Collection >> matchesEvent: anEvent [

	^ self anySatisfy: [:shortcut | shortcut matchesEvent: anEvent]
]

{ #category : #'*Sandblocks-Core' }
Collection >> matchesEvent: anEvent mode: aSymbol [

	^ self anySatisfy: [:shortcut | shortcut matchesEvent: anEvent mode: aSymbol]
]
