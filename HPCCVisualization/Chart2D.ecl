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
    EXPORT Column(DATASET(RecordDef) _data, DATASET(KeyValueDef) _props = DATASET([], KeyValueDef), STRING name = 'myChart') := FUNCTION
			RETURN SEQUENTIAL(OUTPUT(_data, named(name)), OUTPUT(_props, named(name + '_chart2d_props')));
		END;
		
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

    EXPORT __selfTest := MODULE
			IMPORT $.SampleData;
			d := aggregateData(SampleData.DataBreach, State, IndividualsAffected, 'SUM');
			EXPORT run := Column(d, DATASET([{'orientation', 'vertical'}], KeyValueDef));		
    END;
END;
