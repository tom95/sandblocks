"
A SBEdgeInsets models a Morph's layoutInset without requiring the caller to pretend its a Rectangle to specify four different values. As such, it also supports adding to numbers and points.
"
Class {
	#name : #SBEdgeInsets,
	#superclass : #Object,
	#instVars : [
		'left',
		'right',
		'top',
		'bottom'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBEdgeInsets class >> left: leftNumber right: rightNumber top: topNumber bottom: bottomNumber [ 

	^ self basicNew left: leftNumber right: rightNumber top: topNumber bottom: bottomNumber
]

{ #category : #'as yet unclassified' }
SBEdgeInsets >> + anObject [

	^ anObject adaptToEdgeInsetsAndAdd: self
]

{ #category : #'as yet unclassified' }
SBEdgeInsets >> adaptToEdgeInsetsAndAdd: anEdgeInsets [

	^ SBEdgeInsets
		left: anEdgeInsets left + self left
		right: anEdgeInsets right + self right
		top: anEdgeInsets top + self top
		bottom: anEdgeInsets bottom + self bottom
]

{ #category : #'as yet unclassified' }
SBEdgeInsets >> adaptToInteger: aNumber andSend: aSymbol [

	self flag: #todo.
	self assert: aSymbol = #+.
	^ aNumber adaptToEdgeInsetsAndAdd: self
]

{ #category : #'as yet unclassified' }
SBEdgeInsets >> adaptToPoint: aPoint andSend: aSymbol [

	self flag: #todo.
	self assert: aSymbol = #+.
	^ aPoint adaptToEdgeInsetsAndAdd: self
]

{ #category : #'as yet unclassified' }
SBEdgeInsets >> bottom [

	^ bottom
]

{ #category : #'as yet unclassified' }
SBEdgeInsets >> corner [
	" compatibility to e.g. Rectangle>>insetBy: "

	^ right @ bottom
]

{ #category : #'as yet unclassified' }
SBEdgeInsets >> isRectangle [

	^ true
]

{ #category : #'as yet unclassified' }
SBEdgeInsets >> isZero [

	^ left isZero and: [right isZero and: [top isZero and: [bottom isZero]]]
]

{ #category : #'as yet unclassified' }
SBEdgeInsets >> left [

	^ left
]

{ #category : #'as yet unclassified' }
SBEdgeInsets >> left: leftNumber right: rightNumber top: topNumber bottom: bottomNumber [ 

	left := leftNumber.
	right := rightNumber.
	top := topNumber.
	bottom := bottomNumber
]

{ #category : #'as yet unclassified' }
SBEdgeInsets >> origin [
	" compatibility to e.g. Rectangle>>insetBy: "

	^ left @ top
]

{ #category : #'as yet unclassified' }
SBEdgeInsets >> right [

	^ right
]

{ #category : #'as yet unclassified' }
SBEdgeInsets >> top [

	^ top
]