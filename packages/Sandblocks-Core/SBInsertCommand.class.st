Class {
	#name : #SBInsertCommand,
	#superclass : #SBCommand,
	#instVars : [
		'index',
		'morph',
		'container',
		'select'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBInsertCommand >> container [

	^ container
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> container: aMorph [

	container := aMorph
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> do [

	container addMorph: morph asElementNumber: index.
	self applyPositionTo: morph in: container.
	^ select ifNil: [morph]
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> hasSamePositionAs: aCommand [

	^ aCommand class = self class and: [self container = aCommand container and: [self index = aCommand index]]
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> index [

	^ index
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> index: aNumber [

	index := aNumber
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> morph [

	^ morph
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> morph: aMorph [

	morph := aMorph
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> select: aBlock [

	select := aBlock
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> setArtefactFrom [

	^ container
]

{ #category : #'as yet unclassified' }
SBInsertCommand >> undo [

	| parentBlock |
	index := container submorphIndexOf: morph.
	container removeMorph: morph.
	
	parentBlock := container containingSandblock.
	^ (parentBlock childSandblocks notEmpty and: [index notNil])
		ifTrue: [parentBlock childSandblocks at: (index clampLow: 1 high: parentBlock childSandblocks size)]
		ifFalse: [nil]
]
