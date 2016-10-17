#WORKUNIT('name', 'hpcc-viz-SimpleChoropleth');
IMPORT $.^.SampleData.DataBreach;
IMPORT $.^.GeoSpatial;

//  Aggregate by TypeOfBreach ---
byTypeOfBreach := TABLE(DataBreach.RawDataset, {
    State, 
    UNSIGNED INTEGER4 rowCount := COUNT(GROUP)
}, State, FEW);

//  Output 'byTypeOfBreach' ---
OUTPUT(byTypeOfBreach,, NAMED('byTypeOfBreach'));

//  Visualize 'byTypeOfBreach' ---
GeoSpatial.Choropleth.USStates('myUSStates',, 'byTypeOfBreach');
