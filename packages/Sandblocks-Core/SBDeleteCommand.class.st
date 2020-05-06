Class {
	#name : #SBDeleteCommand,
	#superclass : #SBCommand,
	#instVars : [
		'target',
		'oldOwner',
		'oldIndex'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBDeleteCommand >> do [

	| nextSelection |
	oldOwner := target owner.
	nextSelection := (target submorphAfter ifNil: [target submorphBefore]) ifNotNil: [:m | m containingSandblock].
	oldIndex := oldOwner submorphIndexOf: target.
	oldOwner removeMorph: target.
	^ target focusAfterDeleteifNone: [nextSelection ifNil: [oldOwner containingSandblock]]
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> target: aMorph [

	target :=  aMorph
]

{ #category : #'as yet unclassified' }
SBDeleteCommand >> undo [

	oldOwner addMorph: target asElementNumber: oldIndex.
	^ target containingSandblock
]