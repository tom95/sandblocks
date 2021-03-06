Class {
	#name : #SBBlockRow,
	#superclass : #Morph,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBBlockRow >> bindings: aCollection [

	self removeAllMorphs.
	
	aCollection do: [:m | self addMorphBack: m]
]

{ #category : #'as yet unclassified' }
SBBlockRow >> initialize [

	super initialize.
	
	self
		color: Color transparent;
		cellGap: 2 * self scalingFactor;
		extent: 0 @ 0;
		layoutPolicy: SBAlgebraLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		yourself
]

{ #category : #'as yet unclassified' }
SBBlockRow >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand softLineOrGap])
]

{ #category : #'as yet unclassified' }
SBBlockRow >> removedMorph: aMorph [

	super removedMorph: aMorph.
	
	self submorphCount < 1 ifTrue: [self extent: 0 @ 0]
]
