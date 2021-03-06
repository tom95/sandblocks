Class {
	#name : #SBScratchColorPolicy,
	#superclass : #SBColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBScratchColorPolicy >> borderWidthForBlock: aBlock [

	^ (aBlock isMessagePart or: [aBlock prefersNoBorder]) ifTrue: [0] ifFalse: [1]
]

{ #category : #'as yet unclassified' }
SBScratchColorPolicy >> colorForBlock: aBlock [

	aBlock isScheme ifTrue: [^ self schemeColors: aBlock].
	aBlock isSmalltalk ifTrue: [^ self smalltalkColors: aBlock].
	
	^ super colorForBlock: aBlock
]

{ #category : #'as yet unclassified' }
SBScratchColorPolicy >> layoutInsetFor: aBlock [

	^ 4
]

{ #category : #'as yet unclassified' }
SBScratchColorPolicy >> schemeColors: aBlock [

	(aBlock isKindOf: SBScmModule) ifTrue: [^ Color veryDarkGray].
	
	aBlock isSExpr ifTrue: [
		aBlock
			ifWellFormedSpecialFormDo: [:form |
				(#('define' 'let' 'set!' 'set-car!' 'set-cdr!') includes: form) ifTrue: [^ Color r: 1 g: 0.553 b: 0.078].
				(#('lambda' 'let') includes: form) ifTrue: [^ Color r: 1 g: 0.678 b: 0.074].
				(#('cond' 'if' 'begin') includes: form) ifTrue: [^ Color r: 1 g: 0.678 b: 0.074]]
			ifNone: [nil].
		(aBlock submorphs notEmpty and: [aBlock firstSubmorph isSExpr not]) ifTrue: [ | op |
			op := aBlock firstSubmorph contents.
			(#('display' 'newline') includes: op) ifTrue: [^ Color r: 0.608 g: 0.4 b: 1].
			(#('perform') includes: op) ifTrue: [^ Color r: 1 g: 0.4 b: 0.506]].
		^ Color r: 0.349 g: 0.757 b: 0.349].
	
	^ super colorForBlock: aBlock
]

{ #category : #'as yet unclassified' }
SBScratchColorPolicy >> smalltalkColors: aBlock [

	aBlock isMessageSend ifTrue: [
		SBToggledCode
			comment: 'Control'
			active: 1
			do: {
				[
					(#(#ifTrue: #ifFalse: #ifTrue:ifFalse: #ifNil: #to:do: #to:by:do: #do:) includes: aBlock selector) ifTrue: [^ Color r: 1 g: 0.678 b: 0.074]]
			}.
		SBToggledCode
			comment: 'Operators'
			active: 1
			do: {
				[
					(#(#+ #* #/ #* #= #<= #>= #- #** #and: #or: #not) includes: aBlock selector) ifTrue: [^ Color r: 0.349 g: 0.757 b: 0.349]]
			}.
		SBToggledCode
			comment: 'output'
			active: 1
			do: {
				[
					(#(#showln: #nextPut: #nextPutAll: #cr) includes: aBlock selector) ifTrue: [^ Color r: 0.608 g: 0.4 b: 1]]
			}.
		SBToggledCode
			comment: 'drawing'
			active: 1
			do: {
				[
					(#(#fillRectangle:color: #line:to:width:color: #frameRectangle:width:color: #fillOval:color: #frameOval:width:color:) includes: aBlock selector) ifTrue: [^ Color r: 0.608 g: 0.4 b: 1]]
			}.
		^ Color r: 1 g: 0.4 b: 0.506].
	SBToggledCode comment: 'Variables' active: 1 do: {[aBlock isAssignment ifTrue: [^ Color r: 1 g: 0.553 b: 0.078]]}.
	SBToggledCode
		comment: 'Control/Block'
		active: 1
		do: {[(aBlock isBlockBody or: [aBlock isReturn]) ifTrue: [^ Color r: 1 g: 0.678 b: 0.074]]}.
	SBToggledCode comment: 'Arrays' active: 1 do: {[aBlock isArrayBlock ifTrue: [^ Color r: 1 g: 0.4 b: 0.506]]}.
	SBToggledCode comment: 'Method' active: 1 do: {[aBlock isMethod ifTrue: [^ Color r: 0.298 g: 0.596 b: 1]]}.
	^ super colorForBlock: aBlock
]
