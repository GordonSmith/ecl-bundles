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
		
		EXPORT aggregateData(_d, _aggrBy, _groupBy, _AGGR) := FUNCTIONMACRO
				LOCAL aggr := _AGGR(GROUP, _d._groupBy);
				LOCAL aggrRec := { _d._aggrBy, _groupBy := aggr};
				RETURN TABLE(_d, aggrRec, _d._aggrBy, FEW);
		ENDMACRO;
		
		SHARED Meta2D_fm(_classID, labelField, valueField, _data) := FUNCTIONMACRO
				LOCAL MappingDef := RECORD
						STRING label;
						STRING weight;
				END;
				LOCAL TwoDMetaDef := RECORD 
						STRING classID;
						MappingDef mappings;
						DATASET(RECORDOF(_data)) __data { XPATH('data') };
				END;
				LOCAL ds := DATASET([{_classID, {labelField, valueField}, _data}], TwoDMetaDef);
				RETURN OUTPUT(ds, NAMED('__hpcc_visualization'));
		ENDMACRO;

    EXPORT Column(DATASET(RecordDef) _data, DATASET(KeyValueDef) _props = DATASET([], KeyValueDef), STRING name = 'myChart') := FUNCTION
				RETURN SEQUENTIAL(OUTPUT(_data, named(name)), OUTPUT(_props, named(name + '_chart2d_props')));
		END;

		SHARED MetaDef := RECORD 
				STRING classid;
				STRING resultname;
				DATASET(KeyValueDef) properties;
		END;
		
		SHARED Meta(STRING _classID, STRING _outputName, DATASET(KeyValueDef) _properties = DATASET([], KeyValueDef), STRING _id = '') := FUNCTION
				id := IF(_id = '', _outputName, _id);
				ds := DATASET([{_classID, _outputName, _properties}], MetaDef);
				RETURN OUTPUT(ds, NAMED(id + '__hpcc_visualization'));
		END;

    EXPORT __test_column := MODULE
				ds := DATASET([	{'English', 5, 43, 41, 92},
												{'History', 17, 43, 83, 93},
												{'Geography', 7, 45, 52, 83},
												{'Chemistry', 16, 73, 52, 83},
												{'Spanish', 26, 83, 11, 72},
												{'Bioligy', 66, 60, 85, 6},
												{'Physics', 46, 20, 53, 7},
												{'Math', 98, 30, 23, 13}],
												{STRING subject, INTEGER year1, INTEGER year2, INTEGER year3, INTEGER year4});
				dataOut := OUTPUT(ds, NAMED('myData'));
				vizOut := Meta('chart_Column', 'myData');
				vizOut2 := Meta('chart_Column', 'myData', DATASET([{'orientation', 'vertical'}], KeyValueDef), 'myData2');
				vizOut3 := Meta('chart_Pie', 'myData', DATASET([{'orientation', 'vertical'}], KeyValueDef), 'myData3');
				EXPORT run := SEQUENTIAL(dataOut, vizOut, vizOut2, vizOut3);
    END;

    EXPORT __test_functionMacros := MODULE
			IMPORT $.SampleData;
			ds1 := aggregateData(SampleData.DataBreach, TypeOfBreach, IndividualsAffected, SUM);
			EXPORT run := Meta2D_fm('chart_Column', 'TypeOfBreach', 'IndividualsAffected', ds1);
    END;
		
		EXPORT main := FUNCTION
			RETURN SEQUENTIAL(__test_column.run);//, __test_functionMacros.run);
		END;
END;
