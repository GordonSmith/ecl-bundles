EXPORT Dashboard := MODULE
		IMPORT javascript;
		
		SHARED STRING ddlOutput(STRING resultName, SET OF STRING notifies) := EMBED(javascript)
				JSON.stringify({
						from: resultName,
						id: resultName,
						notify: notifies
				});
		ENDEMBED;

		SHARED STRING ddlDatasource(SET OF STRING outputs) := EMBED(javascript)
				JSON.stringify({
						id: "self",
						WUID: true,
						outputs: outputs.map(function(output){return JSON.parse(output);})
				});
		ENDEMBED;

		SHARED STRING ddlTable(STRING vizID, STRING title, STRING outputID, SET OF STRING labels, STRING mappings) := EMBED(javascript)
				JSON.stringify({
						id: vizID,
						type: "TABLE",
						title: title,
						label: labels,
						source: {
								id: "self",
								output: outputID,
								mappings: JSON.parse(mappings)
						}
				});
		ENDEMBED;

		SHARED STRING ddlDashboard(STRING id, STRING label, STRING title, SET OF STRING visualizations, SET OF STRING datasources) := EMBED(javascript)
				JSON.stringify({
						id: id,
						label: label,
						title: title,
						visualizations: visualizations.map(function(visualization){return JSON.parse(visualization);}),
						datasources: datasources.map(function(datasource){return JSON.parse(datasource);})
				});
		ENDEMBED;

		SHARED SET OF STRING ids(SET OF STRING visualizations) := EMBED(javascript)
				visualizations.map(function(str){
						return JSON.parse(str).id;
				});
		ENDEMBED;
		
		SHARED FieldFuncDef := RECORD
			STRING field;
			STRING aggr;
			STRING aggr_field;
		END;
		
		SHARED STRING mappings(SET OF STRING fields, DATASET(FieldFuncDef) funcs = DATASET([], FieldFuncDef)) := EMBED(javascript)
				var funcsMap = {};
				funcs.forEach(function(row) {funcsMap[row.field] = row;});
				var retVal = {
					value: fields.map(function(field){
						var func = funcsMap[field];
						if (func) {
							return {
								"function": func.aggr,
								params: [{
									"param1": func.aggr_field
								}]
							};
						}
						return field;
					})
				};
				JSON.stringify(retVal);
		ENDEMBED;

		SHARED SET OF STRING fields(DATASET _dataset) := FUNCTION
			SET OF STRING tst(STRING ds) := EMBED(javascript)
				var obj = JSON.parse("{" + ds + "}");
				var retVal = [];
				for (var key in obj) {
					retVal.push(key);
				}
				retVal;
			ENDEMBED;
			RETURN tst((STRING)TOJSON(_dataset[1]));
		END;

		EXPORT SimpleTable(DATASET _data) := FUNCTION
				id := 'SimpleTable';
				_labels := fields(_data);
				_mappings := mappings(_labels, DATASET([{'typeofbreach', 'SUM', 'individualsaffected'}], FieldFuncDef));
				_table := ddlTable('viz_' + id, 'title_' + id, id + 'Data', _labels, _mappings );
				_mappings2 := mappings(_labels);
				_table2 := ddlTable('viz2_' + id, 'title_' + id, id + 'Data', _labels, _mappings2);
				_visualizations := [_table, _table2];
				_datasource := ddlDatasource([ddlOutput(id + 'Data', ids(_visualizations))]);
				data_out := OUTPUT(_data, NAMED(id + 'Data'));
				meta_out := OUTPUT('[' + ddlDashboard(id, id, id, _visualizations, [_datasource]) + ']', NAMED('Dashboard_DDL'));
		    RETURN SEQUENTIAL(data_out, meta_out);
		END;
		
		EXPORT main() := FUNCTION
			IMPORT HPCCVisualization.SampleData;
			test := SimpleTable(SampleData.DataBreach);
			//test := mappings(['a', 'b', 'c'], DATASET([{'b', 'SUM', 'b'}], FieldFuncDef));
		  RETURN SEQUENTIAL(test);
		END;
END;
