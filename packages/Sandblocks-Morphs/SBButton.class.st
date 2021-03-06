Class {
	#name : #SBButton,
	#superclass : #Morph,
	#instVars : [
		'action',
		'hovered',
		'pressed'
	],
	#category : #'Sandblocks-Morphs'
}

{ #category : #'as yet unclassified' }
SBButton >> borderStyle [

	^ BorderStyle width: 1 color: (self colorPolicy ifNotNil: [:c | c borderColorForButton: self] ifNil: [Color gray alpha: 0.3])
]

{ #category : #'as yet unclassified' }
SBButton >> clicked [

	action value.
	self mouseEntered
]

{ #category : #'as yet unclassified' }
SBButton >> color [

	| base |
	SBToggledCode
		comment: ''
		active: 1
		do: {[base := self containingSandblock ifNotNil: #drawnColor ifNil: [Color white]]. [base := self colorPolicy colorForButton: self]}.
	self pressed ifTrue: [^ base darker darker].
	self hovered ifTrue: [^ base darker].
	^ base
]

{ #category : #'as yet unclassified' }
SBButton >> colorPolicy [

	^ self containingSandblock ifNotNil: [:b | b colorPolicy]
]

{ #category : #'as yet unclassified' }
SBButton >> example [

	SBMorphExample
		setUp: [SBButton new]
		cases: {
			(SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:m |
					m label: 'Hello' shortcut: $p command do: [nil].
					m owner addMorphBack: (SBButton new icon: (SBIcon iconUndo color: Color black) shortcut: $p asSandblockShortcut do: [nil])])
		}
		extent: 300 @ 300
]

{ #category : #'as yet unclassified' }
SBButton >> fillStyle [

	^ self color
]

{ #category : #'as yet unclassified' }
SBButton >> handlesMouseDown: anEvent [

	^ anEvent redButtonPressed
]

{ #category : #'as yet unclassified' }
SBButton >> hovered [

	^ hovered ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBButton >> hovered: aBoolean [

	hovered := aBoolean.
	self changed
]

{ #category : #'as yet unclassified' }
SBButton >> icon: anIconMorph label: aString do: aBlock [

	SBExample
		self: [SBButton new]
		args: [{SBIcon iconUndo. $u asSandblockShortcut. [nil]}]
		label: 'icon'.
	
	self widget: anIconMorph shortcut: nil do: aBlock.
	
	self addMorphBack: (SBStringMorph new
		contents: aString;
		emphasis: TextEmphasis bold emphasisCode)
]

{ #category : #'as yet unclassified' }
SBButton >> icon: anIconMorph shortcut: aShortcut do: aBlock [

	SBExample
		self: [SBButton new]
		args: [{SBIcon iconUndo. $u asSandblockShortcut. [nil]}]
		label: 'icon'.
	self widget: anIconMorph shortcut: aShortcut do: aBlock
]

{ #category : #'as yet unclassified' }
SBButton >> initialize [

	super initialize.
	
	hovered := false.
	
	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #leftToRight;
		cellGap: 8;
		layoutInset: 8 @ 4;
		cornerStyle: #rounded;
		on: #mouseEnter send: #mouseEntered to: self;
		on: #mouseLeave send: #mouseLeft to: self;
		on: #mouseDown send: #mouseDown to: self;
		on: #mouseUp send: #mouseUp to: self;
		on: #mouseLeaveDragging send: #mouseLeft to: self;
		on: #click send: #clicked to: self
]

{ #category : #'as yet unclassified' }
SBButton >> invokeMetaMenu: evt [

	
]

{ #category : #'as yet unclassified' }
SBButton >> label [

	^ (self submorphs detect: [:m | m isKindOf: SBStringMorph]) contents
]

{ #category : #'as yet unclassified' }
SBButton >> label: aString [

	(self submorphs detect: [:m | m isKindOf: SBStringMorph] ifNone: [
		^ self addMorphFront: (SBStringMorph new
			contents: aString;
			emphasis: TextEmphasis bold emphasisCode)]) contents: aString
]

{ #category : #'as yet unclassified' }
SBButton >> label: aString shortcut: aShortcut do: aBlock [

	SBExample self: [SBButton new] args: [{'hello'. $p command. [nil]}] label: 'label'.
	self
		widget: (SBStringMorph new
			contents: aString;
			emphasis: TextEmphasis bold emphasisCode)
		shortcut: aShortcut
		do: aBlock
]

{ #category : #'as yet unclassified' }
SBButton >> mouseDown [
	
	self pressed: true
]

{ #category : #'as yet unclassified' }
SBButton >> mouseEntered [

	self hovered: true
]

{ #category : #'as yet unclassified' }
SBButton >> mouseLeft [

	self hovered: false.
	self pressed: false
]

{ #category : #'as yet unclassified' }
SBButton >> mouseUp [

	self pressed: false
]

{ #category : #'as yet unclassified' }
SBButton >> onClick: aBlock [

	action := aBlock
]

{ #category : #'as yet unclassified' }
SBButton >> pressed [

	^ pressed ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBButton >> pressed: aBoolean [

	pressed := aBoolean.
	self changed
]

{ #category : #'as yet unclassified' }
SBButton >> widget: aMorph shortcut: aShortcut do: aBlock [

	action := aBlock.
	self addMorphBack: aMorph.
	aShortcut ifNotNil: [
		self addMorphBack: (SBStringMorph new
			contents: (aShortcut isCollection
				ifTrue: [aShortcut anyOne displayString]
				ifFalse: [aShortcut displayString]);
			opacity: 0.7)]
]
