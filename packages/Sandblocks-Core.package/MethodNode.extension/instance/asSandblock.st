*Sandblocks-Core
asSandblock

	^ SBMethod new
		selector: self selector arguments: (self arguments collect: #asMethodArgumentSandblock) class: self methodClass;
		body: (self block asMethodBodySandblock temporaries: (self temporaries collect: #asSandblock));
		yourself