Class {
	#name : #SBStSubstitution,
	#superclass : #SBStASTNode,
	#instVars : [
		'pc'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStSubstitution class >> applyAutomatically [

	^ true
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> catchesAll [

	^ false
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> causesSideEffects [

	^ false
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> derive: anObject [

	^ anObject
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> identity [

	^ false
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> isSmalltalkExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> matches: aMessageSend [

	^ aMessageSend isSandblock and: [(aMessageSend isMessageSend and: [aMessageSend receiver notNil]) or: [self matchesCascades and: [aMessageSend isCascade]]]
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> matchesCascades [

	^ false
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> newFor: aMessage [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> prettyName [

	^ self name allButFirst: 2
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> priority [

	^ 10
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> selector: aString receiverMatches: aMessage [

	^ (aMessage receiver satisfies: #(notNil isBinding)) and: [self name = aMessage receiver contents and: [aMessage selector = aString]]
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> suggestion [

	^ nil
]

{ #category : #'as yet unclassified' }
SBStSubstitution class >> supports: aSymbol [

	^ (self respondsTo: aSymbol) and: [self perform: aSymbol]
]

{ #category : #'as yet unclassified' }
SBStSubstitution >> asSmalltalk: converter [
	<convert>
	
	converter do: [self sourceString parseAsSandblockWithoutSubstitution]
]

{ #category : #'as yet unclassified' }
SBStSubstitution >> constructorString: aString arguments: aCollection on: aStream [

	SBExample
		self: [SBStSubstitution new]
		args: [{'replace:'. ({(SBStNumber new contents: '3')}). '' writeStream}]
		label: 'simple'.
	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream space.
	aString keywords
		with: aCollection
		do: [:keyword :arg | 
			aStream nextPutAll: keyword.
			aStream space.
			arg writeSourceOn: aStream.
			aStream space].
	aStream nextPut: $)
]

{ #category : #initialization }
SBStSubstitution >> initialize [

	super initialize.
	
	pc := 0
]

{ #category : #testing }
SBStSubstitution >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBStSubstitution >> pc [

	^ pc
]

{ #category : #'as yet unclassified' }
SBStSubstitution >> pc: aNumber [

	pc := aNumber
]
