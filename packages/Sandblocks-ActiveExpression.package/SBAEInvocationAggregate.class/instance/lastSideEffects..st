accessing
lastSideEffects: aCollection

	lastSideEffects := aCollection.
	
	aCollection ifNotEmpty: [
		self addMorphBack: (SBStringMorph new
			contents: '      SIDE EFFECTS:';
			emphasis: TextEmphasis bold emphasisCode;
			yourself)].
	
	aCollection do: [:sideEffect |
		self addMorphBack: (SBStringMorph new
			contents: ('      ({1}) {2} := {3}' format: {sideEffect second printStringLimitedTo: 40. sideEffect first. sideEffect third});
			on: #click send: #openSideEffectStack:event:morph: to: self withValue: sideEffect fourth;
			onHoverHighlight: sideEffect second labeled: sideEffect third)]