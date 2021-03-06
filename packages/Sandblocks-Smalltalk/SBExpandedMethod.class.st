Class {
	#name : #SBExpandedMethod,
	#superclass : #SBStSubstitution,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBExpandedMethod class >> applyAutomatically [

	^ false
]

{ #category : #'as yet unclassified' }
SBExpandedMethod class >> matches: aBlock [

	^ super matches: aBlock
]

{ #category : #'as yet unclassified' }
SBExpandedMethod class >> newFor: aBlock [

	^ self new send: aBlock
]

{ #category : #'as yet unclassified' }
SBExpandedMethod class >> priority [

	^ 3
]

{ #category : #'as yet unclassified' }
SBExpandedMethod >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		cellGap: 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #'as yet unclassified' }
SBExpandedMethod >> send: aBlock [

	"aBlock actualReceiver guessClassExpensive
		ifNotNil: [:class |
			(class lookupSelector: aBlock selector asSymbol) ifNotNil: [:m |
				self addMorphBack: m asSandblock]]."
	
	| impls |
	self addMorphBack: aBlock veryDeepCopy.
	
	impls := self systemNavigation allImplementorsOf: aBlock selector asSymbol.
	impls ifNotEmpty: [
		self addMorphBack: (self systemNavigation allImplementorsOf: aBlock selector asSymbol) first compiledMethod asSandblock]
]

{ #category : #'as yet unclassified' }
SBExpandedMethod >> writeSourceOn: aStream [

	self firstSubmorph writeSourceOn: aStream
]
