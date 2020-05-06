Class {
	#name : #SBCombinedCommand,
	#superclass : #SBCommand,
	#instVars : [
		'commands'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCombinedCommand class >> newWith: aCollection [

	^ self basicNew
		initialize;
		commands: aCollection;
		yourself
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> affectedArtefacts [

	" if we non-edit commands within our list we also may get nil artifacts "
	^ ((self commands gather: #affectedArtefacts) select: #notNil) asSet
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> commands [

	^ commands
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> commands: aCollection [

	commands := aCollection
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> do [

	self commands allButLastDo: #do.
	^ self commands last do
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> previousSelection [

	^ previousSelection ifNil: [self commands first previousSelection]
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> undo [

	self commands allButFirst reverseDo: #undo.
	^ self commands first undo
]

{ #category : #'as yet unclassified' }
SBCombinedCommand >> wasEdit [

	^ self commands anySatisfy: #wasEdit
]