#WORKUNIT('name', 'hpcc-viz-SimpleDashbaord');
IMPORT $.^.SampleData.DataBreach;
IMPORT $.^.Visualization;

//  Aggregate by TypeOfBreach ---
OUTPUT(TABLE(DataBreach.RawDataset, {BreachType := TypeOfBreach, UNSIGNED INTEGER4 SumIndividualsAffected := SUM(GROUP, IndividualsAffected)}, TypeOfBreach, FEW), NAMED('TypeOfBreach'));
Visualization.MultiD.Column('myColumnChart',, 'TypeOfBreach',,, DATASET([{'xAxisFocus', false}], Visualization.KeyValueDef));

//  Aggregate by CoveredEntityType ---
OUTPUT(TABLE(DataBreach.RawDataset, {CoveredEntityType, UNSIGNED INTEGER4 SumIndividualsAffected := SUM(GROUP, IndividualsAffected)}, CoveredEntityType, FEW), NAMED('CoveredEntityType'));
Visualization.TwoD.Pie('myPieChart',, 'CoveredEntityType');

//  Aggregate by LocationOfInformation ---
OUTPUT(TABLE(DataBreach.RawDataset, {LocationOfInformation, UNSIGNED INTEGER4 SumIndividualsAffected := SUM(GROUP, IndividualsAffected)}, LocationOfInformation, FEW), NAMED('LocationOfInformation'));
Visualization.MultiD.Bar('myBarChart',, 'LocationOfInformation');

//  All data filtered by previous visualizations ---
OUTPUT(CHOOSEN(SORT(DataBreach.RawDataset, submissiondate), ALL), NAMED('DataBreach'));

mappings :=  DATASET([  {'Date', 'submissiondate'}, 
                        {'Total', 'individualsaffected'}], Visualization.KeyValueDef);

filter := DATASET([     {'myColumnChart', [{'BreachType', 'TypeOfBreach'}]},
                        {'myPieChart', [{'CoveredEntityType', 'CoveredEntityType'}]},
                        {'myBarChart', [{'LocationOfInformation', 'LocationOfInformation'}]}], Visualization.FiltersDef);

properties := DATASET([ {'xAxisType', 'time'}, 
                        {'xAxisTypeTimePattern', '%Y-%m-%d'}, 
                        {'yAxisType', 'pow'}, 
                        {'yAxisTypePowExponent', 0.06},
                        //{'interpolate', 'monotone'},
                        {'xAxisFocus', true}
                        ], Visualization.KeyValueDef);

Visualization.MultiD.Line('myLine2',, 'DataBreach', mappings, filter, properties);

