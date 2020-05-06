Class {
	#name : #SBForm,
	#superclass : #SBSubstitution,
	#instVars : [
		'infoLabel',
		'image',
		'filename'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBForm class >> matches: aBlock [

	^ aBlock receiver isBinding
		and: [aBlock receiver contents = 'Form']
		and: [aBlock selector = 'fromFileNamed:']
		and: [aBlock arguments first isStringBubble]
]

{ #category : #'as yet unclassified' }
SBForm class >> newFrom: aBlock [

	^ self new filename: aBlock arguments first contents
]

{ #category : #'as yet unclassified' }
SBForm >> childSandblocksDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBForm >> doubleClick: anEvent [

	(UIManager default chooseFileMatching: '*') ifNotNil: [:f | self filename: f]
]

{ #category : #'as yet unclassified' }
SBForm >> filename: aString [

	| form |
	filename := aString.
	
	[form := Form fromFileNamed: aString] on: Error do: [
		image visible: false; disableLayout: true.
		infoLabel contents: 'invalid image'.
		^ self].
	
	infoLabel contents: form extent asString.
	image visible: true; disableLayout: false; image: (form scaledIntoFormOfSize: 48 asPoint)
]

{ #category : #'as yet unclassified' }
SBForm >> guessedClass [

	^ Form
]

{ #category : #'as yet unclassified' }
SBForm >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		cellGap: 4 * self scalingFactor;
		cellPositioning: #center;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (image := ImageMorph new);
		addMorphBack: (infoLabel := SBStringMorph new)
]

{ #category : #'as yet unclassified' }
SBForm >> printOn: aStream [

	aStream nextPutAll: 'form from '.
	aStream nextPutAll: (filename size > 20 ifTrue: ['...', (filename last: 20)] ifFalse: [filename])
]

{ #category : #'as yet unclassified' }
SBForm >> writeSourceOn: aStream [

	aStream nextPutAll: '(Form fromFileNamed: '.
	filename storeOn: aStream.
	aStream nextPut: $)
]