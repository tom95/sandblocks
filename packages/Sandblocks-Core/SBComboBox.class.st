Class {
	#name : #SBComboBox,
	#superclass : #SBTextBubble,
	#instVars : [
		'object',
		'values'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBComboBox >> currentTextMorph [

	^ nil
]

{ #category : #'as yet unclassified' }
SBComboBox >> display: anObject [

	^ anObject printString
]

{ #category : #'as yet unclassified' }
SBComboBox >> doubleClick: evt [

	self promptChangeValue
]

{ #category : #'as yet unclassified' }
SBComboBox >> keyStroke: anEvent [
]

{ #category : #'as yet unclassified' }
SBComboBox >> object [

	^ object
]

{ #category : #'as yet unclassified' }
SBComboBox >> object: anObject [

	object := anObject.
	self contents: (self display: object)
]

{ #category : #'as yet unclassified' }
SBComboBox >> promptChangeValue [

	| index |
	index := UIManager default chooseFrom: self values.
	index > 0 ifTrue: [
		self sandblockEditor do: (SBMutatePropertyCommand new
			target: self;
			selector: #object;
			value: (self values at: index))]
]

{ #category : #'as yet unclassified' }
SBComboBox >> startInputAt: aNumber replacingContents: aBoolean [

	self promptChangeValue.
	
	^ nil
]

{ #category : #'as yet unclassified' }
SBComboBox >> values [

	^ values
]

{ #category : #'as yet unclassified' }
SBComboBox >> values: aCollection [

	values := aCollection
]
