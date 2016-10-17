#WORKUNIT('name', 'hpcc-viz-SimpleColumn');
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
ChartND.Column('myColumnChart',, 'byTypeOfBreach');
