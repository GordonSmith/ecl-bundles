IMPORT javascript;
EXPORT ut := MODULE
	EXPORT fields(ds) := FUNCTIONMACRO
		LOCAL _record := RECORDOF(ds);
		
		
		SET OF STRING _fields(DATASET(_record) tmp = DATASET([ROW([], _record)], _record)) := EMBED(javascript)
				var retVal = [];
				for (var key in tmp[0]) {
					retVal.push(key);
				}
				retVal;
		ENDEMBED;
		

		
		RETURN _fields();
	ENDMACRO;
END;
