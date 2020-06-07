Class {
	#name : #SBMessagePartTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testAddColon [

	| message |
	message := '5 yourself' parseAsSandblock
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testBinaryMessageEdit [

	| message editor |
	message := '5 + 2' parseAsSandblock.
	editor := self editorFor: message.
	editor startInput: message at: 0 replacingContents: false.
	message messageParts first keyStroke: (self keyboardEvent: $-).
	self assert: message selector = '-+'.
	message messageParts first keyStroke: (self keyboardEvent: Character backspace).
	self assert: message selector = '+'.
	message messageParts first keyStroke: (self keyboardEvent: $4).
	self assert: message arguments first contents = '42'.
	self assert: message arguments first isSelected
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testChangeDoesNothing [

	| message |
	message := '5 yourself' parseAsSandblock.
	self editorFor: message.
	message messageParts first select.
	message messageParts first changeToUnknown.
	self assert: message selector equals: 'yourself'
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testDeleteAround [

	| block |
	block := '[5 yourself: 2 send: 8]' parseAsSandblock.
	self editorFor: block.
	
	block statements first messageParts second deleteAround.
	self assert: block statements first contents = 'send'
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testHasColon [

	| message |
	message := '5 yourself' parseAsSandblock.
	message selector: 'yourself' arguments: #().
	self deny: message messageParts first hasColon.
	message selector: 'yourself:' arguments: {SBUnknown new}.
	self assert: message messageParts first hasColon.
	message selector: '++' arguments: {SBUnknown new}.
	self deny: message messageParts first hasColon
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testInsertMessagePartAtEnd [

	| message |
	message := 'a do: b' parseAsSandblock.
	self editorFor: message.
	message arguments last insertElementAfter.
	self assert: message selector = 'do::'.
	self assert: message arguments last isUnknown
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testInsertMessagePartAtStart [

	| message |
	{[message receiver insertElementAfter]. [message messageParts first insertElementBefore]} do: [:cmd |
		message := 'a do: b' parseAsSandblock.
		self editorFor: message.
		cmd value.
		self assert: message selector = ':do:']
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testInsertMessagePartBeforeEnd [

	| message |
	message := 'a do: b' parseAsSandblock.
	self editorFor: message.
	message messageParts last insertElementAfter.
	self assert: message selector = 'do::'.
	self assert: message arguments first isUnknown
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testPressColonInExistingMessage [

	| message argument part |
	message := '5 yourself: 2' parseAsSandblock.
	part := message messageParts first.
	argument := message arguments first.
	(self editorFor: message) startInput: message at: 3 replacingContents: false.
	part keyStroke: (self keyboardEvent: $:).
	self assert: message selector = 'yourself:'.
	self assert: message arguments first = argument
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testTypeBinary [

	| receiver message editor |
	receiver := SBUnknown new.
	editor := self editorFor: receiver.
	message := receiver wrapInMessageSend.
	self assert: message selector isEmpty.
	self assert: editor currentInput = message messageParts first.
	message messageParts first keyStroke: (self keyboardEvent: $+).
	self assert: message selector = '+'.
	self assert: message arguments size = 1.
	self assert: editor currentInput = message messageParts first.
	message messageParts first keyStroke: (self keyboardEvent: $-).
	self assert: message selector = '+-'.
	message messageParts first keyStroke: (self keyboardEvent: $').
	self assert: editor currentInput = message messageParts first.
	self assert: message selector = '+-'
]

{ #category : #'as yet unclassified' }
SBMessagePartTest >> testUseSuggestion [

	| message editor |
	message := '5 yourself' parseAsSandblock.
	(editor := self editorFor: message) startInput: message at: 1 replacingContents: false.
	message useSuggestion: 'yourself:'.
	self assert: message arguments last isSelected.
	self assert: message arguments first isUnknown.
	self assert: message selector = 'yourself:'.
	editor undo.
	self assert: message selector = 'yourself'.
	editor redo.
	self assert: message arguments first isUnknown.
	self assert: message selector = 'yourself:'.
	editor startInput: message at: 1 replacingContents: false.
	message useSuggestion: 'from:to:do:'.
	self assert: (message arguments allSatisfy: #isUnknown).
	editor undo.
	editor redo.
	self assert: (message arguments allSatisfy: #isUnknown).
	editor startInput: message at: 1 replacingContents: false.
	message useSuggestion: 'yourself'.
	self assert: message selector = 'yourself'.
	self assert: message messageParts first isSelected
]