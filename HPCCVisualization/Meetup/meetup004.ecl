#WORKUNIT('name', 'Meetup 004');
IMPORT $.Chart2D;
IMPORT $.ChartND;
IMPORT $.GeoSpatial;
IMPORT $.SampleData.DataBreach;

//  Aggregate by State ---
data_byState := OUTPUT(TABLE(DataBreach.RawDataset, {State, UNSIGNED INTEGER4 SumIndividualsAffected := SUM(GROUP, IndividualsAffected)}, State, FEW), NAMED('State'));
viz_usStates := GeoSpatial.Choropleth.USStates('usStates',, 'State');

//  Aggregate by TypeOfBreach ---
data_byTypeOfBreach := OUTPUT(TABLE(DataBreach.RawDataset, {BreachType := TypeOfBreach, UNSIGNED INTEGER4 SumIndividualsAffected := SUM(GROUP, IndividualsAffected)}, TypeOfBreach, FEW), NAMED('TypeOfBreach'));
myColumnChart := ChartND.Column('myColumnChart',, 'TypeOfBreach', DATASET([{'xAxisFocus', false}], Chart2D.KeyValueDef));

//  Aggregate by CoveredEntityType ---
data_byCoveredEntityType := OUTPUT(TABLE(DataBreach.RawDataset, {CoveredEntityType, UNSIGNED INTEGER4 SumIndividualsAffected := SUM(GROUP, IndividualsAffected)}, CoveredEntityType, FEW), NAMED('CoveredEntityType'));
myPieChart := Chart2D.Pie('myPieChart',, 'CoveredEntityType');

//  Aggregate by LocationOfInformation ---
data_byLocationOfInformation := OUTPUT(TABLE(DataBreach.RawDataset, {LocationOfInformation, UNSIGNED INTEGER4 SumIndividualsAffected := SUM(GROUP, IndividualsAffected)}, LocationOfInformation, FEW), NAMED('LocationOfInformation'));
myBarChart := ChartND.Bar('myBarChart',, 'LocationOfInformation');

op4 := OUTPUT(CHOOSEN(DataBreach.RawDataset, ALL), NAMED('DataBreach'));
myTableFilter := DATASET([
    {'usStates', [{'State', 'State'}]},
    {'myColumnChart', [{'BreachType', 'TypeOfBreach'}]},
    {'myPieChart', [{'CoveredEntityType', 'CoveredEntityType'}]},
    {'myBarChart', [{'LocationOfInformation', 'LocationOfInformation'}]}
], Chart2D.FiltersDef);
myTables := SEQUENTIAL( Chart2D.Table('myTable',, 'DataBreach',, myTableFilter),
                        Chart2D.Table('myTable2','~HPCCVisualization::DataBreach',, , myTableFilter),
                        Chart2D.Table('myTable3','http://192.168.3.22:8002/WsEcl/submit/query/roxie/databreach.1', 'result_1', , myTableFilter));

SEQUENTIAL(data_byState, viz_usStates, data_byTypeOfBreach, data_byCoveredEntityType, data_byLocationOfInformation, op4, myColumnChart, myPieChart, myBarChart, myTables);
