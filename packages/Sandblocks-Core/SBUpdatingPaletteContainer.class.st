Class {
	#name : #SBUpdatingPaletteContainer,
	#superclass : #SBPaletteContainer,
	#instVars : [
		'currentPalettes',
		'paletteMapping',
		'selectedBlock'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> addNoPalettesNotice [

	categories addMorphBack: (SBStringMorph new contents: 'No Palettes')
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> addPalette: aPalette [

	| currentMorphs newMorphs |
	currentMorphs := content submorphs, categories submorphs.
	aPalette buildOn: self.
	newMorphs := content submorphs, categories submorphs.
	paletteMapping at: aPalette put: (newMorphs difference: currentMorphs)
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> initialize [

	super initialize.
	
	currentPalettes := Set new.
	paletteMapping := Dictionary new
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> removeNoPalettesNotice [

	"self assert: categories submorphCount <= 1."
	categories removeAllMorphs
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> removePalette: aPalette [

	paletteMapping at: aPalette ifPresent: [:morphs | morphs do: #delete]
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> selectedBlock [

	^ selectedBlock
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> selectionChanged: aBlock [

	| newPalettes |
	(aBlock isNil or: [aBlock hasOwner: self]) ifTrue: [^ self].
	
	selectedBlock := aBlock.
	currentPalettes ifEmpty: [self removeNoPalettesNotice].
	
	newPalettes := SBPalette allSubclasses select: [:palette | (aBlock satisfies: palette context) and: [palette matchesBlock: aBlock]].
	
	(currentPalettes difference: newPalettes) do: [:palette | self removePalette: palette].
	(newPalettes difference: currentPalettes) do: [:palette | self addPalette: palette].
	
	currentPalettes := newPalettes asSet.
	
	currentPalettes ifEmpty: [self addNoPalettesNotice].
	
	self layoutChanged
]