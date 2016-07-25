IMPORT $.Common;
EXPORT Chart2D := MODULE(Common)
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
		
    EXPORT __selfTest := MODULE
			IMPORT $.SampleData;
			d := aggregateData(SampleData.DataBreach, State, IndividualsAffected, 'SUM');
			EXPORT run := Column(d, DATASET([{'orientation', 'vertical'}], KeyValueDef));		
    END;
END;
