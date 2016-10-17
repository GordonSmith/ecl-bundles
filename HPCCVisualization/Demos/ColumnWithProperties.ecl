#WORKUNIT('name', 'hpcc-viz-ColumnWithProperties');
IMPORT $.^.SampleData.DataBreach;
IMPORT $.^.ChartND;

//  Aggregate by TypeOfBreach ---
byTypeOfBreach := TABLE(DataBreach.RawDataset, {
    TypeOfBreach, 
    UNSIGNED INTEGER4 rowCount := COUNT(GROUP)
}, TypeOfBreach, FEW);

//  Output 'byTypeOfBreach' ---
OUTPUT(byTypeOfBreach,, NAMED('byTypeOfBreach'));

//  Visualize 'byTypeOfBreach' ---
columnProperties := DATASET([
    {'paletteID', 'Dark2'},
    {'yAxisTitle', 'Row Count'},
    {'yAxisDomainLow', 0},
    {'yAxisDomainHigh', 1000}
], ChartND.KeyValueDef);
ChartND.Column('myColumnChart',, 'byTypeOfBreach', columnProperties);
