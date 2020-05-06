Class {
	#name : #SBClassNameInput,
	#superclass : #SBTextBubble,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBClassNameInput >> doubleClick: anEvent [

	self promptChangeClass
]

{ #category : #'as yet unclassified' }
SBClassNameInput >> promptChangeClass [

	(UIManager default chooseClassOrTrait) ifNotNil: [:class |
		self sandblockEditor do: ((SBMutatePropertyCommand newFor: self containingArtefact)
			target: self;
			selector: #contents;
			value: class name)]
]

{ #category : #'as yet unclassified' }
SBClassNameInput >> selectedClass [

	^ Smalltalk at: self contents asSymbol
]

{ #category : #'as yet unclassified' }
SBClassNameInput >> startInputAt: aNumber replacingContents: aBoolean [

	self promptChangeClass.
	
	^ nil
]