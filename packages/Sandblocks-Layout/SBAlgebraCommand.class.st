"
A SBAlgebraCommand is a specification of layout behavior. See SBAlgebraLayout.

XXX: this class should probably be split into subclasses.
"
Class {
	#name : #SBAlgebraCommand,
	#superclass : #Object,
	#instVars : [
		'type',
		'morph',
		'data'
	],
	#category : #'Sandblocks-Layout'
}

{ #category : #'as yet unclassified' }
SBAlgebraCommand class >> container [

	^ self new type: #container
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand class >> gap [

	^ self new type: #gap
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand class >> group [

	^ self new type: #group
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand class >> hardLine [

	^ self new type: #hardLine; withGap: false
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand class >> indent [

	^ self new type: #indent
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand class >> morph [

	^ self new type: #morph
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand class >> noop [

	^ self new type: #noop
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand class >> root [

	^ self new type: #root
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand class >> softLine [

	^ self new type: #softLine; withGap: false
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand class >> softLineOrGap [

	^ self new type: #softLineOrGap; withGap: false
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand >> data [

	^ data
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand >> data: anObject [

	data := anObject
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand >> debugStoreString [

	^ SBFormatter
		formatString: (String streamContents: [:stream | self storeOn: stream])
		class: nil class
		noPattern: true
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand >> morph [

	^ morph
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand >> morph: aMorph [

	morph := aMorph
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand >> printOn: aStream [

	aStream nextPutAll: self className; nextPut: $(; nextPutAll: self type; nextPut: $)
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand >> storeOn: aStream [
	" NOTE: does not produce valid code! Meant for debugging purposes (morphs are not stored) "

	aStream
		nextPutAll: '(SBAlgebraCommand ';
		nextPutAll: type;
		nextPutAll: ' data: '.
	
	data isArray
		ifTrue: [aStream nextPut: ${. data do: [:e | aStream store: e] separatedBy: [aStream nextPut: $.]. aStream nextPut: $}]
		ifFalse: [
			aStream store: (data isMorph
				ifTrue: ['<morph>']
				ifFalse: [data]).].
				
	aStream
		nextPutAll: ')'
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand >> type [

	^ type
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand >> type: aSymbol [

	type := aSymbol
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand >> withGap [

	^ self data
]

{ #category : #'as yet unclassified' }
SBAlgebraCommand >> withGap: aBoolean [

	self data: aBoolean
]