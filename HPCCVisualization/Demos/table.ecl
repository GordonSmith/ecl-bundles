#WORKUNIT('name', 'hpcc-viz-table');
IMPORT $.^.SampleData.DataBreach;
IMPORT $.^.ChartAny;

//  Output 'DataBreach' ---
OUTPUT(DataBreach.RawDataset,, NAMED('DataBreach'));

//  table - all columns ---
ChartAny.Grid('myTable',, 'DataBreach');


//  table - mapped columns ---
ChartAny.Grid('myTable2',, 'DataBreach', DATASET([{'US State', 'state'}, 
                                                  {'Type', 'typeofbreach'}, 
                                                  {'From', 'coveredentitytype'}
                                                  ], ChartAny.KeyValueDef));


//  table - custom properties ---
ChartAny.Grid('myTable3',, 'DataBreach',,, DATASET([{'pagination', '0'}, 
                                                   {'showHeader', '0'}
                                                   ], ChartAny.KeyValueDef));
