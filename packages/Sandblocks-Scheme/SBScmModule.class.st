Class {
	#name : #SBScmModule,
	#superclass : #SBScmASTNode,
	#instVars : [
		'interpreter'
	],
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmModule class >> fromString: aString [

	^ SBScmParser new parse: aString readStream
]

{ #category : #'as yet unclassified' }
SBScmModule >> binding: aString for: block class: aClass ifPresent: aBlock [

	| sym |
	self
		withStatementsDo: [:l |
			l detect: [:s | s isSExpr and: [s ifDefinition: [:d | d = aString] otherwise: [false]]] ifFound: [:s | aBlock value: s]]
		ifNotApplicable: [].
	
	sym := aString asSymbol.
	self interpreter globalEnv car do: [:cons | cons car = sym ifTrue: [^ aBlock value: (SBScmIdentifier new contents: aString)]].
	^ super binding: aString for: block class: aClass ifPresent: aBlock
]

{ #category : #'as yet unclassified' }
SBScmModule >> canDeleteChild: aBlock [

	^ self expressions size > 1
]

{ #category : #'as yet unclassified' }
SBScmModule >> childSandblocksDo: aBlock [

	self expressions do: aBlock
]

{ #category : #'as yet unclassified' }
SBScmModule >> commandPaletteClass [

	^ SBScmPalette
]

{ #category : #'as yet unclassified' }
SBScmModule >> expressions [

	^ self submorphs
]

{ #category : #'as yet unclassified' }
SBScmModule >> fixedNumberOfChildren [

	^ false
]

{ #category : #'as yet unclassified' }
SBScmModule >> hasUnsavedChanges [

	^ false
]

{ #category : #'as yet unclassified' }
SBScmModule >> hasUnsavedChanges: aBoolean [
]

{ #category : #'as yet unclassified' }
SBScmModule >> initialize [

	super initialize.
	
	self
		layoutInset: 8;
		attachDecorator: SBMoveDecorator new;
		attachDecorator: SBResizableDecorator new;
		addMorphBack: self newNullBlock
]

{ #category : #'as yet unclassified' }
SBScmModule >> insertCommandRequest: anAfterBoolean near: aBlock [

	^ (SBInsertCommand newFor: self containingArtefact)
		index: (self childSandblocks indexOf: aBlock) + (anAfterBoolean ifTrue: [1] ifFalse: [0]);
		container: self;
		morph: self newNullBlock;
		shouldMergeWithNext: true;
		yourself
]

{ #category : #'as yet unclassified' }
SBScmModule >> interpreter [

	^ interpreter ifNil: [interpreter := QoppaInterpreter new.]
]

{ #category : #'as yet unclassified' }
SBScmModule >> isArtefact [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmModule >> isBlockBody [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmModule >> isMethodBody [

	^ false
]

{ #category : #'as yet unclassified' }
SBScmModule >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self expressions collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine withGap: true])
]

{ #category : #'as yet unclassified' }
SBScmModule >> sandblockBlockColorIfAbsent: aBlock [

	^ Color r: 0.271 g: 0.682 b: 0.851
]

{ #category : #'artefact protocol' }
SBScmModule >> saveTryFixing: aBoolean quick: anotherBoolean [

	^ true
]

{ #category : #'as yet unclassified' }
SBScmModule >> statements [

	^ self expressions
]

{ #category : #'as yet unclassified' }
SBScmModule >> withStatementsDo: aBlock ifNotApplicable: anotherBlock [

	aBlock value: self expressions
]

{ #category : #'as yet unclassified' }
SBScmModule >> writeSourceOn: aStream [

	self statements do: [:s | s writeSourceOn: aStream] separatedBy: [aStream cr]
]