EXPORT Common := MODULE
    IMPORT Std;
		
		EXPORT keyValueDataset(arr) := FUNCTIONMACRO
			RETURN DATASET(arr, { STRING key, STRING value });
		ENDMACRO;
		
		EXPORT mappings22(arr) := FUNCTIONMACRO
			IMPORT $.Common;
			RETURN Common keyValueDataset(arr);
		ENDMACRO;
	
		EXPORT aggregateData(_data, _label, _value, _aggr = 'SUM') := FUNCTIONMACRO
			RETURN TABLE(_data, { 
				STRING label := _data._label, 
				REAL value := CASE(_aggr, 'SUM' => SUM(GROUP, _value),
																	'MIN' => MIN(GROUP, _value),
																	'MAX' => MAX(GROUP, _value),
																	'AVE' => AVE(GROUP, _value),
																	'COUNT' => COUNT(GROUP), 
																	SUM(GROUP, _value))
				}, _label, FEW);
		ENDMACRO;
END;
