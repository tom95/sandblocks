Class {
	#name : #SBExplorerRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBExplorerRepresentation class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBExplorerRepresentation class >> isSandblock [

	^ true
]

{ #category : #'as yet unclassified' }
SBExplorerRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBExplorerRepresentation class >> matches: anObject [

	^ true
]

{ #category : #'as yet unclassified' }
SBExplorerRepresentation class >> newFor: anObject [

	^ SBExplorer on: anObject
]

{ #category : #'as yet unclassified' }
SBExplorerRepresentation class >> priority [

	^ 2
]
