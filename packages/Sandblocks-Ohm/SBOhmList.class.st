Class {
	#name : #SBOhmList,
	#superclass : #SBOhmASTNode,
	#category : #'Sandblocks-Ohm'
}

{ #category : #'as yet unclassified' }
SBOhmList >> canDeleteChild: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmList >> connect [

	^ self firstSubmorph contents
]

{ #category : #'as yet unclassified' }
SBOhmList >> connect: aString expressions: aCollection [

	self addMorph: (SBOwnTextMorph new
		contents: aString;
		bold).
	self addAllMorphsBack: aCollection
]

{ #category : #'as yet unclassified' }
SBOhmList >> currentTextMorph [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBOhmList >> expressions [

	^ self submorphs viewAllButFirst
]

{ #category : #'as yet unclassified' }
SBOhmList >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBOhmList >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [2] ifFalse: [1]);
		container: self;
		morph: (self newNullBlock label: 'seq');
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBOhmList >> isAlternative [

	^ self connect = 'OR'
]

{ #category : #'as yet unclassified' }
SBOhmList >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBOhmList >> isSequence [

	^ self connect = 'AND'
]

{ #category : #'as yet unclassified' }
SBOhmList >> layoutCommands [

	^ SBToggledCode comment: '' active: 2 do: {
		[
			SBAlgebraCommand container
				data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand softLineOrGap]);
				morph: self].
		[
			SBAlgebraCommand container
				data: {
					self submorphs first layoutCommands.
					SBAlgebraCommand indent data: {SBAlgebraCommand softLineOrGap}, (self submorphs viewAllButFirst
						collect: #layoutCommands
						separatedBy: [SBAlgebraCommand softLineOrGap withGap: true])};
				morph: self]}
]

{ #category : #'as yet unclassified' }
SBOhmList >> maybeUnwrapList [

	^ self expressions size < 2 ifTrue: [self expressions first] ifFalse: [self]
]

{ #category : #'as yet unclassified' }
SBOhmList >> writeSourceOn: aStream [

	| needsParens |
	needsParens := self parentSandblock isAlternative not and: [self parentSandblock isRule not].
	
	needsParens ifTrue: [aStream nextPut: $(].
	self expressions
		do: [:s | s writeSourceOn: aStream]
		separatedBy: [aStream nextPutAll: (self connect = 'OR' ifTrue: [' | '] ifFalse: [' '])].
	needsParens ifTrue: [aStream nextPut: $)]
]