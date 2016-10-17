#WORKUNIT('name', 'hpcc-viz-LookAndFeel2');
IMPORT $.^.SampleData.DataBreach;
IMPORT $.^.Chart2D;
IMPORT $.^.ChartND;

//  Aggregate by TypeOfBreach ---
byTypeOfBreach := TABLE(DataBreach.RawDataset, {
    TypeOfBreach, 
    UNSIGNED INTEGER4 rowCount := COUNT(GROUP)
}, TypeOfBreach, FEW);

//  Output 'byTypeOfBreach' ---
OUTPUT(byTypeOfBreach,, NAMED('byTypeOfBreach'));

//  Visualize 'byTypeOfBreach' ---
Chart2D.Pie('myPieChart',, 'byTypeOfBreach');

byLocationOfInformation := TABLE(DataBreach.RawDataset, {
    LocationOfInformation, 
    UNSIGNED INTEGER4 rowCount := COUNT(GROUP)
}, LocationOfInformation, FEW);
OUTPUT(byLocationOfInformation,, NAMED('byLocationOfInformation'));
ChartND.Column('myColumnChart',, 'byLocationOfInformation');
