Extension { #name : #SBUnknown }

{ #category : #'*Sandblocks-Smalltalk' }
SBUnknown >> canAppearInBlockBody [

	^ true
]

{ #category : #'*Sandblocks-Smalltalk' }
SBUnknown >> guessClassExpensive [

	^ nil
]

{ #category : #'*Sandblocks-Smalltalk' }
SBUnknown >> guessedClass [

	^ nil
]

{ #category : #'*Sandblocks-Smalltalk' }
SBUnknown >> isSmalltalk [

	^ self grammarHandler isKindOf: SBStGrammarHandler
]