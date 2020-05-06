"
A SBEditorCanvas is an infite scrolling morph that clips its submorphs. Via 2d scroll viewport can be moved around. It supports smoothly animating to positions or rectangles in its coordinate system.
"
Class {
	#name : #SBEditorCanvas,
	#superclass : #SBClippingTransformMorph,
	#instVars : [
		'dragging',
		'lastDragPosition',
		'dragStartPosition',
		'dragLeftOverVelocity',
		'targetPosition'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #viewport }
SBEditorCanvas >> animateToPosition: aPoint [

	targetPosition := aPoint
]

{ #category : #viewport }
SBEditorCanvas >> basicViewportPosition: aPoint [

	self transform: (self transform withOffset: aPoint - self position).
	self changed
]

{ #category : #'event handling' }
SBEditorCanvas >> click: anEvent [

	self sandblockEditor selectClick: nil
]

{ #category : #'geometry testing' }
SBEditorCanvas >> containsPoint: aPoint [

	^ self bounds containsPoint: aPoint
]

{ #category : #accessing }
SBEditorCanvas >> currentPosition [

	^ self position + self transform offset
]

{ #category : #'event handling' }
SBEditorCanvas >> doubleClick: anEvent [

	| closest method point |
	point := self transform globalPointToLocal: anEvent position.
	closest := self submorphs fold: [:a :b |
		(a center squaredDistanceTo: point) < (b center squaredDistanceTo: point) ifTrue: [a] ifFalse: [b]].
	
	self sandblockEditor
		openMorphInView: (method := SBMethod new
			selector: ''
			arguments: #()
			class: (closest ifNotNil: [:container | container relatedClass] ifNil: [UIManager default chooseClassOrTrait]);
			body: (SBBlockBody new statements: {SBUnknown new})).
	
	method center: point.
	method hasUnsavedChanges: true.
	self sandblockEditor startInput: method at: 1 replacingContents: true
]

{ #category : #drawing }
SBEditorCanvas >> drawSubmorphsOn: aCanvas [

	super drawSubmorphsOn: aCanvas
	
	"aCanvas asBalloonCanvas transformBy: self transform
		during:[:myCanvas| submorphs reverseDo: [:m | myCanvas fullDrawMorph: m]]"
]

{ #category : #accessing }
SBEditorCanvas >> extentToFit [

	| full |
	full := self submorphBounds.
	^ full extent + ((full origin max: 0 @ 0) - self position)
]

{ #category : #viewport }
SBEditorCanvas >> finishDragVelocity [

	self moveViewport: dragLeftOverVelocity.
	dragLeftOverVelocity := dragLeftOverVelocity * 0.85.
	(dragLeftOverVelocity closeTo: 0 @ 0)
		ifTrue: [
			self viewportPosition: targetPosition rounded.
			self stopSteppingSelector: #finishDragVelocity]
]

{ #category : #'event handling' }
SBEditorCanvas >> handlesMouseDown: anEvent [

	^ true
]

{ #category : #'event handling' }
SBEditorCanvas >> handlesMouseWheel: anEvent [

	^ true
]

{ #category : #initialization }
SBEditorCanvas >> initialize [

	super initialize.
	
	dragging := false.
	targetPosition := 0 @ 0.
	dragLeftOverVelocity := 0 @ 0.
	self smoothing: 2.
	
	self color: Color white
]

{ #category : #'event handling' }
SBEditorCanvas >> mouseDown: anEvent [ 
	anEvent hand waitForClicksOrDrag: self event: anEvent.
	self stopSteppingSelector: #finishDragVelocity.
	
	anEvent yellowButtonPressed ifTrue: [
		lastDragPosition := anEvent position.
		dragging := true]
]

{ #category : #'event handling' }
SBEditorCanvas >> mouseMove: anEvent [ 
	dragging
		ifTrue: [| delta |
			delta := anEvent position - lastDragPosition.
			anEvent shiftPressed
				ifTrue: [self zoomViewport: delta y from: dragStartPosition]
				ifFalse: [self moveViewport: delta].
			lastDragPosition := anEvent position.
			dragLeftOverVelocity := delta]
]

{ #category : #'event handling' }
SBEditorCanvas >> mouseUp: anEvent [ 
	(dragLeftOverVelocity closeTo: 0 @ 0)
		ifFalse: [self startSteppingSelector: #finishDragVelocity].
	dragging := false
]

{ #category : #'event handling' }
SBEditorCanvas >> mouseWheel: anEvent [

	(anEvent commandKeyPressed and: [dragStartPosition notNil])
		ifTrue: [self zoomViewport: anEvent wheelDelta y from: dragStartPosition]
		ifFalse: [self viewportPosition: targetPosition + anEvent wheelDelta negated]
]

{ #category : #viewport }
SBEditorCanvas >> moveViewport: aPoint [

	self viewportPosition: targetPosition + aPoint negated
]

{ #category : #constants }
SBEditorCanvas >> scrollShowMargin [

	^ 10 * self scalingFactor
]

{ #category : #viewport }
SBEditorCanvas >> scrollToShow: aMorph [
	
	| viewport x y target |
	viewport := 0 @ 0 extent: self extent.
	target := (aMorph boundsInWorld translateBy: (self topLeft) negated) expandBy: self scrollShowMargin.
	(viewport containsRect: target) ifTrue: [^ self].
	x := targetPosition x.
	y := targetPosition y.
	target right > viewport right
		ifTrue: [
			x := target right - viewport right + targetPosition x
					min: target left - viewport left + targetPosition x].
	target left < viewport left ifTrue: [x := target left - viewport left + targetPosition x].
	target bottom > viewport bottom
		ifTrue: [
			y := target bottom - viewport bottom + (self offset) y
					min: target top - viewport top + (self offset) y].
	target top < viewport top ifTrue: [y := target top - viewport top + targetPosition y].
	"self offset: x @ y"
	self animateToPosition: x @ y
]

{ #category : #'event handling' }
SBEditorCanvas >> startDrag: anEvent [

	| canvas |
	anEvent redButtonPressed
		ifTrue: [
			canvas := SBDrawCanvas new center: (self transform globalPointToLocal: anEvent position).
			self addMorphBack: canvas.
			canvas mouseDown: (anEvent transformedBy: self transform).
			anEvent hand newMouseFocus: canvas]
		ifFalse: [
			dragging := true.
			lastDragPosition := anEvent position.
			dragStartPosition := anEvent position]
]

{ #category : #'stepping and presenter' }
SBEditorCanvas >> step [

	(dragLeftOverVelocity closeTo: 0 @ 0)
		ifTrue: [
			((self currentPosition dist: self targetPosition) closeTo: 0)
				ifTrue: [self currentPosition ~= self targetPosition ifTrue: [self viewportPosition: self targetPosition rounded]]
				ifFalse: [self basicViewportPosition: (self currentPosition interpolateTo: self targetPosition at: 0.2)]]
]

{ #category : #'stepping and presenter' }
SBEditorCanvas >> stepTime [

	^ 1
]

{ #category : #accessing }
SBEditorCanvas >> targetPosition [

	^ targetPosition
]

{ #category : #viewport }
SBEditorCanvas >> viewportPosition: aPoint [

	targetPosition := aPoint.
	self basicViewportPosition: aPoint
]

{ #category : #viewport }
SBEditorCanvas >> zoomViewport: aNumber from: aPoint [

	self offset: self offset + ((aPoint - self position) * aNumber * self scale * 0.001).
	self scale: (self scale + (aNumber * self scale * 0.001))
]