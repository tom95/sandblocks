as yet unclassified
resizeToFit

	| extent |
	self fullBounds.
	extent := scroll extentToFit + self extent - scroll extent + (20 @ 40 * self scalingFactor).
	((self ownerThatIsA: SystemWindow) ifNil: [self]) extent: extent x @ (extent y min: Display height - (200 * self scalingFactor)).
	scroll setScrollDeltas