Class {
	#name : #SBBlockRow,
	#superclass : #Morph,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBlockRow >> bindings: aCollection [

	self removeAllMorphs.
	
	aCollection do: [:m | self addMorphBack: m]
]

{ #category : #'as yet unclassified' }
SBBlockRow >> childSandblocksDo: aBlock [

	self submorphsDo: aBlock
]

{ #category : #'as yet unclassified' }
SBBlockRow >> initialize [

	super initialize.
	
	self
		color: Color transparent;
		layoutPolicy: SBHorizontalLayout new;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 2 * self scalingFactor;
		cellGap: 2 * self scalingFactor;
		extent: 0 @ 0;
		yourself
]

{ #category : #'as yet unclassified' }
SBBlockRow >> removedMorph: aMorph [

	super removedMorph: aMorph.
	
	self submorphCount < 1 ifTrue: [self extent: 0 @ 0]
]