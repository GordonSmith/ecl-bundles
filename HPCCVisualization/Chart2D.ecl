EXPORT Chart2D := MODULE
		IMPORT Std;

    EXPORT Bundle := MODULE(Std.BundleBase)
			EXPORT Name := 'HPCCVisualization';
			EXPORT Description := 'HPCC Visualizations';
			EXPORT Authors := ['Gordon Smith'];
			EXPORT License := 'http://www.apache.org/licenses/LICENSE-2.0';
			EXPORT Copyright := 'Copyright (C) 2016 HPCC Systems';
			EXPORT DependsOn := [];
			EXPORT Version := '0.0.0';
    END;
		
    EXPORT KeyValueDef := { STRING key, STRING value };
    EXPORT RecordDef := { STRING label, REAL value };
		
		EXPORT aggregateData2(_data, _label, _value, _aggr) := FUNCTIONMACRO
			RETURN TABLE(_data, { 
				STRING label := _data._label, 
				REAL value := CASE(_aggr, 	'SUM' => SUM(GROUP, _value),
											'MIN' => MIN(GROUP, _value),
											'MAX' => MAX(GROUP, _value),
											'AVE' => AVE(GROUP, _value),
											'COUNT' => COUNT(GROUP), 
											SUM(GROUP, _value))
				}, _label, FEW);
		ENDMACRO;
		
		EXPORT aggregateData(_d, _aggrBy, _groupBy, _AGGR) := FUNCTIONMACRO
				LOCAL aggr := _AGGR(GROUP, _d._groupBy);
				LOCAL aggrRec := { _d._aggrBy, _groupBy := aggr};
				RETURN TABLE(_d, aggrRec, _d._aggrBy, FEW);
		ENDMACRO;
		
		SHARED Meta(_classID, labelField, valueField, _data) := FUNCTIONMACRO
				LOCAL MappingDef := RECORD
						STRING label;
						STRING weight;
				END;
				LOCAL MetaDef := RECORD 
						STRING classID;
						MappingDef mappings;
						DATASET(RECORDOF(_data)) __data { XPATH('data') };
				END;
				LOCAL ds := DATASET([{_classID, {labelField, valueField}, _data}], MetaDef);
				RETURN OUTPUT(ds, NAMED('__hpcc_visualization'));
		ENDMACRO;

    EXPORT Column(DATASET(RecordDef) _data, DATASET(KeyValueDef) _props = DATASET([], KeyValueDef), STRING name = 'myChart') := FUNCTION
			RETURN SEQUENTIAL(OUTPUT(_data, named(name)), OUTPUT(_props, named(name + '_chart2d_props')));
		END;
		
    EXPORT __selfTest := MODULE
			IMPORT $.SampleData;
			t := aggregateData(SampleData.DataBreach, TypeOfBreach, IndividualsAffected, SUM);
			EXPORT run := Meta('chart_Pie', 'TypeOfBreach', 'IndividualsAffected', t);
    END;
		
		EXPORT main := FUNCTION
			RETURN SEQUENTIAL(__selfTest.run);
		END;
END;
