Class {
	#name : #SBStNameBehavior,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStNameBehavior class >> checkCastFor: aBlock parent: aMorph [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> actions [

	^ Array streamContents: [:stream |
		self class withAllSuperclassesDo: [:class |
			Pragma
				withPragmasIn: class
				do: [:pragma |
					(#(#action #multiSelectAction #inputAction) includes: pragma keyword) ifTrue: [stream nextPut: pragma]].
			SBStNameBehavior = class ifTrue: [^ stream contents]]]
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> attached: aName [

	name := aName.
	aName currentTextMorph clearEmphasis
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> block [

	^ name
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> block: aBlock [
	" ignore, we already know which block we belong to "
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> contents [

	^ self block contents
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> contentsChanged [
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> declareBlockVariable [
	<action>
	<actionValidIf: #noValidBinding>
	
	self block containingBlock declareTemporaryVariable: self contents
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> declareInstanceVariable [
	<action>
	<actionValidIf: #noValidBinding>

	self block sandblockEditor do: (SBStDeclareInstVarCommand new
		class: self block containingArtefact methodClass;
		name: self contents;
		source: self block)
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> declareMethodVariable [
	<action>
	<actionValidIf: #noValidBinding>
	
	self block containingArtefact body declareTemporaryVariable: self contents
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> detached: aBlock [

	name := nil
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> doubleClick: anEvent [
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> fixActions [

	^ #()
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> guessedClass [

	^ self block binding ifNotNil: [:b | b value class]
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> handleDroppedBlock: aBlock event: anEvent adding: aBoolean near: aMorph [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> inputCommandClass [

	^ SBInputCommand
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isBinding [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isBlockBinding [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isBooleanBlock [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isDeclaration [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isKeyword [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isLiteralBlock [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isMethodArgument [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isMethodLocal [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> isTemporaryVariable [

	^ false
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> lowercaseSuggestions [

	^ Array streamContents: [:str |
		self block containingArtefact declarations
			select: [:v | v contents sandblockMatch: self contents]
			thenDo: [:v | str nextPut: v asSuggestionItem].
		self block containingBlocksDo: [:block |
			block temporaries
				select: [:v | v contents sandblockMatch: self contents]
				thenDo: [:v | str nextPut: v asSuggestionItem].
			block bindings
				select: [:v | v contents sandblockMatch: self contents]
				thenCollect: [:v | str nextPut: v asSuggestionItem]]]
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> noValidBinding [

	^ self validBinding not
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> prefix [

	^ nil
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> printBlockOn: aStream [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> resolveBinding [

	^ nil
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> symbolsFor: aColorPolicy [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> updateSuggestions [

	| suggestions |
	suggestions := self contents ifEmpty: [#()] ifNotEmpty: [:text |
		text first isUppercase
			ifTrue: [self uppercaseSuggestions]
			ifFalse: [self lowercaseSuggestions]].
	self block updateSuggestions: suggestions showNear: self block
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> uppercaseSuggestions [

	self flag: #todo.
	"pool dict etc"
	^ Array streamContents: [:stream |
		Smalltalk globals keysAndValuesDo: [:key :value |
			(key sandblockMatch: self contents) ifTrue: [
				stream nextPut: (SBSuggestionItem selector: key label: ((value isBehavior and: [key == value name])
					ifTrue: ['class']
					ifFalse: ['global']))]].
		SBStSubstitution allSubclassesDo: [:class | (class name sandblockMatch: self contents) ifTrue: [class suggestion ifNotNil: [:block | stream nextPut: ((SBSuggestionItem selector: class name label: 'projection') completionAction: block)]]]]
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> valid [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBStNameBehavior >> validBinding [

	^ true
]
