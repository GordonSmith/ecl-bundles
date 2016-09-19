#WORKUNIT('name', 'Meetup 003');
IMPORT $.Chart2D;
IMPORT $.ChartND;
IMPORT $.GeoSpatial;
IMPORT $.SampleData.DataBreach;

//  Aggregate by CoveredEntityType ---
OUTPUT(TABLE(DataBreach.RawDataset, {CoveredEntityType, INTEGER4 RowCount := COUNT(GROUP)}, CoveredEntityType, FEW), NAMED('CoveredEntityType'));
Chart2D.Pie('myPieChart',, 'CoveredEntityType');

//  Aggregate by TypeOfBreach ---
OUTPUT(TABLE(DataBreach.RawDataset, {BreachType := TypeOfBreach, INTEGER4 RowCount := COUNT(GROUP)}, TypeOfBreach, FEW), NAMED('TypeOfBreach'));
ChartND.Column('myColumnChart',, 'TypeOfBreach');

//  Aggregate by State ---
OUTPUT(TABLE(DataBreach.RawDataset, {State, INTEGER4 RowCount := COUNT(GROUP)}, State, FEW), NAMED('State'));
GeoSpatial.Choropleth.USStates('usStates',, 'State');

//  Aggregate by LocationOfInformation ---
OUTPUT(TABLE(DataBreach.RawDataset, {LocationOfInformation, INTEGER4 RowCount := COUNT(GROUP)}, LocationOfInformation, FEW), NAMED('LocationOfInformation'));
ChartND.Bar('myBarChart',, 'LocationOfInformation');

//  Filtered Results ---
myTableFilter := DATASET([
    {'usStates', [{'State', 'State'}]},
    {'myColumnChart', [{'BreachType', 'TypeOfBreach'}]},
    {'myPieChart', [{'CoveredEntityType', 'CoveredEntityType'}]},
    {'myBarChart', [{'LocationOfInformation', 'LocationOfInformation'}]}
], Chart2D.FiltersDef);

//  Attempt 1
/*
Chart2D.Table('myTable','~HPCCVisualization::DataBreach',, , myTableFilter);
*/

//  Switch to Roxie - remove choropleth  ---
/*
ChartND.Line('myLine2','http://192.168.3.22:8002/WsEcl/submit/query/roxie/filtereddatabreach/json', 'DataBreachFiltered', DATASET([
                                                  {'xAxisType', 'time'}, 
                                                  {'xAxisTypeTimePattern', '%Y-%m-%d'}, 
                                                  {'yAxisType', 'pow'}, 
                                                  {'yAxisTypePowExponent', 0.06},
                                                  {'interpolate', 'monotone'},
                                                  {'xAxisFocus', 0}
                                                  ], ChartND.KeyValueDef), 
                                                  myTableFilter);

*/
