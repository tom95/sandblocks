Class {
	#name : #SBCursorInsert,
	#superclass : #SBCursorPosition,
	#instVars : [
		'command',
		'before',
		'adjacent',
		'container'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCursorInsert >> = aPosition [

	^ aPosition class = self class and: [aPosition adjacent = self adjacent and: [aPosition before = self before and: [aPosition container = self container]]]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> adjacent [

	^ adjacent
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> adjacent: aBlock [

	adjacent := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> before [

	^ before
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> before: aBoolean [

	before := aBoolean
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> block [

	^ self container
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> bounds [

	self adjacent ifNil: [
		^ self before
			ifTrue: [self container topLeft extent: self lineWidth @ self container height]
			ifFalse: [self container topRight - (self lineWidth @ 0) extent: self lineWidth @ self container height]].
	^ self before
		ifTrue: [self adjacent topLeft - (self lineWidth @ 0) extent: self lineWidth @ self adjacent height]
		ifFalse: [self adjacent topRight extent: self lineWidth @ self adjacent height]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> color [

	^ self container colorPolicy selectionColorForBlock: (self container parentSandblock ifNil: [self container])
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> command [

	^ command
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> command: aBlock [

	command := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> container [

	^ container
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> container: aBlock [

	container := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> drawOn: aCanvas [

	aCanvas fillRectangle: self bounds color: self color
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> hash [

	^ self adjacent hash bitXor: (self before hash bitXor: self container hash)
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> horizontalOffsetInFloat [

	^ self block containingFloat
		ifNotNil: [:float | | reference |
			reference := self bounds center x.
			reference - float left]
		ifNil: [self bounds center x]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> lineWidth [

	^ 3
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> mode [

	^ #insert
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> moveHorizontal: aNumber wordWise: aBoolean [

	| next |
	next := self adjacentPosition: aNumber in: self container sandblockEditor.
	^ (next class = self class and: [next command hasSamePositionAs: self command])
		ifTrue: [next adjacentPosition: aNumber in: self container sandblockEditor]
		ifFalse: [next]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> selectLarger [

	^ SBCursorSelect new block: self container
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> selectSmaller [

	
]
