Class {
	#name : #SBScmParserTest,
	#superclass : #TestCase,
	#category : #'Sandblocks-Scheme-Tests'
}

{ #category : #'as yet unclassified' }
SBScmParserTest >> assertParses: aString [

	self assertParses: aString as: aString
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> assertParses: aString as: anotherString [

	self assert: anotherString equals: (SBScmParser new parse: aString readStream) sourceString
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testComments [

	self assertParses: '(+ 2 3)

; hello!

3 ; hello' as: '(+ 2 3)

; hello!

3
; hello'.
	self assertParses: '(+ 2 3)
; test
; hello!
; abc
3 ; hello' as: '(+ 2 3)
; test
; hello!
; abc
3
; hello'
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testKeepEmptyLines [

	| string |
	string := '(a)

(b)'.
	self assert: string equals: (SBScmParser new parse: string readStream) prettySourceString
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testParseBinaryExpr [

	self assertParses: '(+ 3 4)'
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testParseBraceInString [

	self assertParses: '")"'
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testParseDefineProcedure [

	self assertParses: '(define (my-proc x) (* x x))'
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testParseDottedTail [

	self assertParses: '(a . b)'
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testParseEmptyList [

	self assertParses: '''()'.
	self assertParses: '(test ''())'
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testParseExtraWhitespaces [

	self assertParses: '   (  +   3    2   (   - 3 2)  )  ' as: '(+ 3 2 (- 3 2))'
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testParseMultipleTopLevelExprs [

	self assertParses: '(define x 5)
(define y 6)
(+ x y)'
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testParseNegativeNumber [

	self assert: ((SBScmParser new parse: '-3' readStream) expressions first isKindOf: SBScmNumber)
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testParseNestedExpr [

	self assertParses: '(+ 3 4 (+ 5 6) 2)'
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testParseString [

	self assertParses: '"hello world, how are you?"'
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testParseSymbol [

	self assertParses: '''test'
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testParserErrorsWithMalformed [

	self should: [SBScmParser new parse: '(+ 3 4   ' readStream] raise: Error
]

{ #category : #'as yet unclassified' }
SBScmParserTest >> testQuote [

	self assertParses: '''()
''(+ 2 3)'
]
