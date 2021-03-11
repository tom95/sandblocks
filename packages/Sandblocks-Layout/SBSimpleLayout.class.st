Class {
	#name : #SBSimpleLayout,
	#superclass : #SBLayoutPolicy,
	#category : #'Sandblocks-Layout'
}

{ #category : #'as yet unclassified' }
SBSimpleLayout >> layout: aMorph in: aRectangle [

	| m |
	m := aMorph firstSubmorph.
	m layoutInBounds: (aRectangle topLeft extent: (m layoutPolicy ifNil: [aRectangle width @ m minExtent y] ifNotNil: [aRectangle width @ (m layoutPolicy minExtentOf: m in: aRectangle) y])) positioning: #topLeft
]

{ #category : #'as yet unclassified' }
SBSimpleLayout >> minExtentOf: aMorph in: aRectangle [

	| m |
	m := aMorph firstSubmorph.
	^ m layoutPolicy ifNil: [m minExtent] ifNotNil: [m layoutPolicy minExtentOf: m in: aRectangle]
]