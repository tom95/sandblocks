Class {
	#name : #SBCodeOpener,
	#superclass : #Morph,
	#instVars : [
		'categories',
		'selectedCategoryIndex',
		'selectedClassIndex',
		'selectedMethodIndex',
		'classes',
		'messages',
		'currentPanelIndex',
		'result',
		'showingClassSide',
		'preview'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCodeOpener >> categories [

	^ self systemOrganizer categories
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> classIconAt: anIndex [

	^ self toolIconForm: (ToolIcons iconForClass: (Smalltalk at: (self classes at: anIndex)))
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> classes [

	^ self systemOrganizer listAtCategoryNamed: (self categories at: self selectedCategoryIndex)
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> currentPanel [

	^ self submorphs at: currentPanelIndex
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> delete [

	super delete.
	
	preview ifNotNil: #delete
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> focus: aMethodOrClass [

	aMethodOrClass isBehavior
		ifTrue: [
			self showingClassSide: aMethodOrClass isClassSide.
			self selectedCategoryIndex: (self categories indexOf: aMethodOrClass category).
			self selectedClassIndex: (self classes indexOf: aMethodOrClass theNonMetaClass name).
			self focusPanel: 3]
		ifFalse: [
			self showingClassSide: aMethodOrClass methodClass isClassSide.
			self selectedCategoryIndex: (self categories indexOf: aMethodOrClass methodClass category).
			self selectedClassIndex: (self classes indexOf: aMethodOrClass methodClass theNonMetaClass name).
			self selectedMethodIndex: (self methods indexOf: aMethodOrClass selector).
			self focusPanel: 3]
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> focusPanel: aNumber [

	currentPanelIndex := aNumber clampLow: 1 high: self submorphCount.
	self methods ifEmpty: [currentPanelIndex := currentPanelIndex min: 2].
	
	(currentPanelIndex = 2 and: [self selectedClassIndex = 0]) ifTrue: [self selectedClassIndex: 1].
	currentPanelIndex < 2 ifTrue: [self selectedClassIndex: 0].
	
	(currentPanelIndex = 3 and: [self selectedMethodIndex = 0]) ifTrue: [self selectedMethodIndex: 1].
	currentPanelIndex < 3 ifTrue: [self selectedMethodIndex: 0]
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> handlesKeyboard: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> initialize [

	super initialize.
	
	selectedCategoryIndex := 1.
	selectedClassIndex := 0.
	selectedMethodIndex := 0.
	currentPanelIndex := 1.
	showingClassSide := false.
	
	self
		height: 200;
		changeTableLayout;
		addDropShadow;
		vResizing: #rigid;
		hResizing: #shrinkWrap;
		listDirection: #leftToRight;
		addMorphBack: (categories := (PluggableListMorphPlus
			on: self
			list: #categories
			selected: #selectedCategoryIndex
			changeSelected: #selectedCategoryIndex:
			menu: #menu:evaluate:)
				vResizing: #spaceFill;
				width: 200;
				yourself);
		addMorphBack: (classes := (PluggableListMorphPlus
			on: self
			list: #classes
			selected: #selectedClassIndex
			changeSelected: #selectedClassIndex:
			menu: #menu:evaluate:)
				getIconSelector: #classIconAt:;
				vResizing: #spaceFill;
				width: 200;
				yourself);
		addMorphBack: (messages := (PluggableListMorphPlus
			on: self
			list: #methods
			selected: #selectedMethodIndex
			changeSelected: #selectedMethodIndex:
			menu: #menu:evaluate:)
				getIconSelector: #messageIconAt:;
				vResizing: #spaceFill;
				width: 200;
				yourself).
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> keyStroke: anEvent [

	anEvent keyCharacter = Character escape ifTrue: [^ self delete].
	anEvent keyCharacter = Character arrowRight ifTrue: [^ self focusPanel: currentPanelIndex + 1].
	anEvent keyCharacter = Character arrowLeft ifTrue: [^ self focusPanel: currentPanelIndex - 1].
	anEvent keyCharacter = Character cr ifTrue: [result := self selectedClassOrMethod. ^ self delete].
	anEvent keyCharacter = Character tab ifTrue: [self showingClassSide: self showingClassSide not].
	(anEvent keyCharacter = $f and: [anEvent commandKeyPressed]) ifTrue: [^ self focus: UIManager default chooseClassOrTrait].
	self currentPanel keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> messageIconAt: aNumber [

	^ self toolIconForm: (ToolIcons
		iconForClass: (Smalltalk at: (self classes at: self selectedClassIndex))
		selector: (self methods at: aNumber))
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> methods [

	^ self selectedClassIndex > 0 ifTrue: [
		showingClassSide
			ifTrue: [(Smalltalk at: (self classes at: self selectedClassIndex)) class methodDict keys]
			ifFalse: [(Smalltalk at: (self classes at: self selectedClassIndex)) methodDict keys]] ifFalse: [#()]
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> open [

	| hand world |
	" from DialogWindow>>getUserResponse "
	self openInWorld.
	hand := self currentHand.
	world := self currentWorld.
	
	hand showTemporaryCursor: nil.
	
	hand keyboardFocus in: [:priorKeyboardFocus |
		hand mouseFocus in: [:priorMouseFocus |
			hand newMouseFocus: self.
			hand newKeyboardFocus: self.
			
			[[self isInWorld] whileTrue: [world doOneSubCycle]]
				ifCurtailed: [self delete].
			
			hand newKeyboardFocus: priorKeyboardFocus.
			hand newMouseFocus: priorMouseFocus]].
	
	^ result
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> openFor: aMethodOrClass [

	self focus: aMethodOrClass.
	^ self open
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> positionNear: aMorph [

	self position: (aMorph center x - (self fullBounds width / 2)) @ aMorph top
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> selectedCategory [

	^ self categories at: self selectedCategoryIndex
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> selectedCategoryIndex [

	^ selectedCategoryIndex
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> selectedCategoryIndex: aNumber [

	selectedCategoryIndex := aNumber.
	selectedMethodIndex := 0.
	selectedClassIndex := 0.
	self changed: #selectedCategoryIndex.
	self changed: #classes.
	self changed: #methods.
	self selectedClassIndex: 0
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> selectedClass [

	^ self classes at: self selectedClassIndex
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> selectedClassIndex [

	^ selectedClassIndex
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> selectedClassIndex: aNumber [

	selectedClassIndex := aNumber.
	self changed: #selectedClassIndex.
	self changed: #methods.
	self selectedMethodIndex: 0
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> selectedClassOrMethod [

	^ (self selectedMethodIndex > 0 and: [self methods notEmpty])
		ifTrue: [self selectedMethod]
		ifFalse: [self selectedClassIndex > 0 ifTrue: [Smalltalk at: self selectedClass] ifFalse: [nil]]
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> selectedMethod [

	| class |
	class := (Smalltalk at: self selectedClass).
	showingClassSide ifTrue: [class := class class].
	^  class >> (self methods at: self selectedMethodIndex)
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> selectedMethodIndex [

	^ selectedMethodIndex
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> selectedMethodIndex: aNumber [

	selectedMethodIndex := aNumber.
	self changed: #selectedMethodIndex.
	
	preview ifNotNil: #delete.
	
	(selectedMethodIndex > 0 and: [selectedClassIndex > 0]) ifTrue: [
		preview := SBSelection new
			methodClass: self selectedClass;
			colorPolicy: SBDefaultColorPolicy new;
			addMorphBack: self selectedMethod asSandblock.
		preview openInWorld.
		preview topCenter: self bottomCenter]
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> showingClassSide [

	^ showingClassSide
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> showingClassSide: aBoolean [

	showingClassSide := aBoolean.
	self changed: #methods.
	self selectedMethodIndex: (self methods notEmpty ifTrue: [1] ifFalse: [0])
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> systemOrganizer [

	^ SystemOrganizer default
]

{ #category : #'as yet unclassified' }
SBCodeOpener >> toolIconForm: aSymbolOrForm [

	" there appears to be an API change here that we need to catch "
	^ aSymbolOrForm isForm ifTrue: [aSymbolOrForm] ifFalse: [ToolIcons  iconNamed:aSymbolOrForm]
]