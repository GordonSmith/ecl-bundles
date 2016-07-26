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
		
    EXPORT Widget(STRING _id = 'myChart', STRING _classID = 'TABLE', ANY _data, DATASET(KeyValueDef) _mappings = DATASET([], KeyValueDef), DATASET(KeyValueDef) _properties = DATASET([], KeyValueDef)) := FUNCTION
			MetaDef := RECORD 
				STRING id; 
				STRING classID;
				DATASET(KeyValueDef) mappings;
				DATASET(KeyValueDef) properties;
			END;
			MetaDS := DATASET([{_id, _classID, _mappings, _properties}], MetaDef);
			RETURN SEQUENTIAL(OUTPUT(_data, named(_id)), OUTPUT(MetaDS, named(_id + '_meta')));
		END;
		
    EXPORT Column(DATASET(RecordDef) _data, DATASET(KeyValueDef) _props = DATASET([], KeyValueDef), STRING name = 'myChart') := FUNCTION
			RETURN SEQUENTIAL(OUTPUT(_data, named(name)), OUTPUT(_props, named(name + '_chart2d_props')));
		END;
		
    //EXPORT __selfTest := MODULE
			//IMPORT $.SampleData;
			//d := aggregateData(SampleData.DataBreach, State, IndividualsAffected, 'SUM');
			//EXPORT run := Column(d, DATASET([{'orientation', 'vertical'}], KeyValueDef));		
    //END;
		
		EXPORT ddl(STRING chartID) := FUNCTION
			_notify := {
				STRING id
			};
			_output := {
				STRING id,
				STRING from,
				DATASET(_notify) notifies{xpath('notify')}
			};
			datasource := { 
				STRING id,
				BOOLEAN WUID,
				DATASET(_output) outputs{xpath('outputs')}	
			};
			mapping := {
				SET OF STRING _value{xpath('value')}
			};
			source := {
				STRING id,
				STRING _output{xpath('output')},
				mapping mappings{xpath('mappings')}
			};
			visualization := {
				STRING id,
				STRING type,
				STRING title,
				SET OF STRING labels{xpath('label')},
				source _source{xpath('source')}
			};
			ddl := {
				STRING id, 
				STRING title, 
				STRING label := '',
				DATASET(datasource) datasources{xpath('datasources')},
				DATASET(visualization) visualizations{xpath('visualizations')}
			};

			RETURN '[{' + TOJSON(ROW(
				{
					chartID + '_ddl', 
					chartID + '_ddl', 
					chartID + '_ddl', 
					[{
						chartID,
						TRUE,
						[{
							chartID,
							chartID,
							[{
								'viz_' + chartID
							}]
						}]
					}], 
					[{
						'viz_' + chartID,
						'TABLE',
						'testing',
						['label', 'value'],
						{
							'self',
							chartID,
							{
								['State', 'IndividualsAffected']
							}
						}
					}]
				}, ddl)) + '}]';
		END;
END;
