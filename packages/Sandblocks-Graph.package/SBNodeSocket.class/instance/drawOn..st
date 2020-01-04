as yet unclassified
drawOn: aCanvas

	(type = #flowIn or: [type = #flowOut])
		ifTrue: [
			aCanvas drawPolygon: (type =  #flowIn
				ifTrue: [{self topLeft. self topRight. self bottomCenter}]
				ifFalse: [{self bottomLeft. self bottomRight. self topCenter}]) fillStyle: Color red]
		ifFalse: [
			aCanvas clipBy: self bounds during: [:canvas |
				canvas fillOval: (self bounds translateBy: self width / 2 * (type = #output ifTrue: [1] ifFalse: [-1]) @ 0) color: self color]]