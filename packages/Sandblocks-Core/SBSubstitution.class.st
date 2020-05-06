Class {
	#name : #SBSubstitution,
	#superclass : #SBBlock,
	#instVars : [
		'pc'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSubstitution class >> matches: aMessageSend [

	^ false
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> matchesCascades [

	^ false
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> newFrom: aMessage [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBSubstitution class >> suggestion [

	^ nil
]

{ #category : #'as yet unclassified' }
SBSubstitution >> codeActions [

	^super codeActions, {SBCodeAction
		labeled: 'Show as Message Send'
		for: self
		do: #replaceWithMessageSend}
]

{ #category : #'as yet unclassified' }
SBSubstitution >> constructorString: aString arguments: aCollection on: aStream [

	SBExample
		self: [SBSubstitution new]
		args: [{'replace:'. ({(SBNumber new contents: '3')}). '' writeStream}]
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
SBSubstitution >> initialize [

	super initialize.
	
	pc := 0
]

{ #category : #testing }
SBSubstitution >> isExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBSubstitution >> pc [

	^ pc
]

{ #category : #'as yet unclassified' }
SBSubstitution >> pc: aNumber [

	pc := aNumber
]

{ #category : #'as yet unclassified' }
SBSubstitution >> replaceWithMessageSend [

	| doIt |
	doIt := Parser new parse: self sourceString class: nil class noPattern: true notifying: nil ifFail: nil.
	
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
			replacer: (doIt block statements first expr asSandblockWithoutSubstitution pc: self pc);
			target: self)
]