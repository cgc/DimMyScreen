DimMyScreen.dmg: DimMyScreen.app appdmg.json
	-rm DimMyScreen.dmg
	./node_modules/.bin/appdmg appdmg.json DimMyScreen.dmg

