Class {
	#name : #SBLanguageBox,
	#superclass : #SBBlock,
	#instVars : [
		'language'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBLanguageBox class >> eval: aString lang: anotherString [

	^ [SBScmModule newInterpreter readAndEvaluate: aString]
		on: QoppaUnboundVariableFailure
		do: [:e | | context name |
			name := e variableName asSymbol asString.
			context := thisContext methodReturnContext sender.
			e resumeWithValue: (context namedTempAt: (context tempNames indexOf: name ifAbsent: [^ e signal]))]
]

{ #category : #'as yet unclassified' }
SBLanguageBox class >> matches: aMessageSend [

	^ (super matches: aMessageSend) and: [aMessageSend selector = 'eval:lang:']
]

{ #category : #'as yet unclassified' }
SBLanguageBox class >> newFor: aBlock [

	^ self new source: aBlock arguments first contents lang: aBlock arguments second contents
]

{ #category : #'as yet unclassified' }
SBLanguageBox class >> suggestion [

	^ [:block | | box |
		box := (SBStLanguageBox new source: '' lang: 'scheme').
		block sandblockEditor do: ((SBReplaceCommand newFor: block containingArtefact)
			target: block;
			replacer: box).
		box inputNextUnknown]
]

{ #category : #testing }
SBLanguageBox >> canAppearInBlockBody [

	^ true
]

{ #category : #'colors and color policies' }
SBLanguageBox >> drawnColor [

	^ self root drawnColor
]

{ #category : #accessing }
SBLanguageBox >> grammarHandler [

	^ self parentSandblock grammarHandler
]

{ #category : #initialization }
SBLanguageBox >> initialize [

	super initialize.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutInset: 0;
		layoutPolicy: SBAlgebraLayout new
]

{ #category : #testing }
SBLanguageBox >> isExpression [

	^ true
]

{ #category : #accessing }
SBLanguageBox >> language [

	^ language
]

{ #category : #layout }
SBLanguageBox >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: {
			self firstSubmorph layoutCommands.
			self root statements size > 1
				ifTrue: [SBAlgebraCommand hardLine withGap: true]
				ifFalse: [SBAlgebraCommand gap].
			self root layoutCommands}
]

{ #category : #accessing }
SBLanguageBox >> root [

	^ self submorphs last
]

{ #category : #initialization }
SBLanguageBox >> source: aString lang: anotherString [

	language := anotherString.

	self removeAllMorphs.
	self addMorphBack: (anotherString
		caseOf: {
			['smalltalk'] -> [SBStContainer new setFromSource: aString].
			['scheme'] -> [SBScmModule fromString: aString].
			['js'] -> [SBJsModule fromString: aString]}
		otherwise: [SBMultilineOwnTextMorph new contents: aString]).
	
	self addMorphFront: ((self root class respondsTo: #icon)
		ifTrue: [self root class icon asMorph]
		ifFalse: [SBIcon iconQuestion])
]

{ #category : #printing }
SBLanguageBox >> writeSourceOn: aStream [

	self grammarHandler writeSourceOn: aStream for: self
]