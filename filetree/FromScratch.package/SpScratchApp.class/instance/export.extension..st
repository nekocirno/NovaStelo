private
export: anExporter extension: aString
	| fName f str |
	self closeMediaEditorsAndDialogs
		ifFalse: [ ^ self ].
	self stopAllProcesses.
	fName := self
		chooseNewFileDefault: self projectName
		extension: aString
		title: 'Export ...'
		type: #export.
	fName ifNil: [ ^ self ].
	fName := fName withExtension: aString.
	fName isFile
		ifTrue: [ (UIManager default
				confirm: 'Overwrite existing ' , fName basename , '?')
				ifFalse: [ ^ self ].
			fName delete ].
	f := nil.
	self class
		try: [ f := fName writeStream.
			str := anExporter exportFrom: self.
			f nextPutAll: str.
			f close ]
		onFailure: [ f ifNotNil: [ f close ].
			UIManager default
				alert: 'Could not write file' , fName basename
				title: 'Export failed' localized ]