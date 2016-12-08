#WORKUNIT('name', 'hpcc-viz-SimpleDashbaord');
IMPORT $.^.SampleData.DataBreach;
IMPORT $.^.Chart2D;
IMPORT $.^.ChartND;
IMPORT $.^.ChartAny;
IMPORT $.^.GeoSpatial;

//  Aggregate by TypeOfBreach ---
OUTPUT(TABLE(DataBreach.RawDataset, {BreachType := TypeOfBreach, UNSIGNED INTEGER4 SumIndividualsAffected := SUM(GROUP, IndividualsAffected)}, TypeOfBreach, FEW), NAMED('TypeOfBreach'));
ChartND.Column('myColumnChart',, 'TypeOfBreach',,, DATASET([{'xAxisFocus', false}], Chart2D.KeyValueDef));

//  Aggregate by CoveredEntityType ---
OUTPUT(TABLE(DataBreach.RawDataset, {CoveredEntityType, UNSIGNED INTEGER4 SumIndividualsAffected := SUM(GROUP, IndividualsAffected)}, CoveredEntityType, FEW), NAMED('CoveredEntityType'));
Chart2D.Pie('myPieChart',, 'CoveredEntityType');

//  Aggregate by LocationOfInformation ---
OUTPUT(TABLE(DataBreach.RawDataset, {LocationOfInformation, UNSIGNED INTEGER4 SumIndividualsAffected := SUM(GROUP, IndividualsAffected)}, LocationOfInformation, FEW), NAMED('LocationOfInformation'));
ChartND.Bar('myBarChart',, 'LocationOfInformation');

//  All data filtered by previous visualizations ---
OUTPUT(CHOOSEN(SORT(DataBreach.RawDataset, submissiondate), ALL), NAMED('DataBreach'));

mappings :=  DATASET([  {'Date', 'submissiondate'}, 
                        {'Total', 'individualsaffected'}], ChartND.KeyValueDef);

filter := DATASET([     {'myColumnChart', [{'BreachType', 'TypeOfBreach'}]},
                        {'myPieChart', [{'CoveredEntityType', 'CoveredEntityType'}]},
                        {'myBarChart', [{'LocationOfInformation', 'LocationOfInformation'}]}], Chart2D.FiltersDef);

properties := DATASET([ {'xAxisType', 'time'}, 
                        {'xAxisTypeTimePattern', '%Y-%m-%d'}, 
                        {'yAxisType', 'pow'}, 
                        {'yAxisTypePowExponent', 0.06},
                        //{'interpolate', 'monotone'},
                        {'xAxisFocus', true}
                        ], ChartND.KeyValueDef);

ChartND.Line('myLine2',, 'DataBreach', mappings, filter, properties);

