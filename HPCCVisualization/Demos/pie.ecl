#WORKUNIT('name', 'hpcc-viz-pie');
IMPORT $.^.SampleData.DataBreach;
IMPORT $.^.Chart2D;

//  Aggregate by TypeOfBreach ---
byTypeOfBreach := TABLE(DataBreach.RawDataset, {
    TypeOfBreach, 
    UNSIGNED INTEGER4 rowCount := COUNT(GROUP),
    UNSIGNED INTEGER4 individualsAffected := SUM(GROUP, IndividualsAffected)
}, TypeOfBreach, FEW);

//  Output 'byTypeOfBreach' ---
OUTPUT(byTypeOfBreach,, NAMED('byTypeOfBreach'));

//  pie ---
Chart2D.Pie('myPieChart',, 'byTypeOfBreach');

//  pie - mapped data ---
Chart2D.Pie('myPieChart2',, 'byTypeOfBreach', DATASET([{'Type', 'TypeOfBreach'}, 
                                                  {'Affected Individuals', 'individualsAffected'} 
                                                  ], Chart2D.KeyValueDef));

Chart2D.__test;