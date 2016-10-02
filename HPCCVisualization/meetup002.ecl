#WORKUNIT('name', 'Meetup 002');
IMPORT $.ChartND;
IMPORT $.GeoSpatial;
IMPORT $.SampleData.DataBreach;

//  Aggregate by Date ---
byDate := TABLE(DataBreach.RawDataset, {
    SubmissionDate, 
    UNSIGNED INTEGER4 MinIndividualsAffected := MIN(GROUP, IndividualsAffected),
    UNSIGNED INTEGER4 AveIndividualsAffected := AVE(GROUP, IndividualsAffected),
    UNSIGNED INTEGER4 MaxIndividualsAffected := MAX(GROUP, IndividualsAffected)
}, SubmissionDate, FEW);

//  Attempt 1  ---
/*
OUTPUT(CHOOSEN(SORT(byDate, SubmissionDate), 100), NAMED('SubmissionDate'));
ChartND.Line('myLine',, 'SubmissionDate');
*/

//  Attempt 2  ---
/*
ChartND.Line('myLine2',, 'SubmissionDate', DATASET([
                                                  {'xAxisType', 'time'}, 
                                                  {'xAxisTypeTimePattern', '%Y-%m-%d'}, 
                                                  {'yAxisType', 'pow'}, 
                                                  {'yAxisTypePowExponent', 0.06},
                                                  {'interpolate', 'monotone'},
                                                  {'xAxisFocus', 0}
                                                  ], ChartND.KeyValueDef));
*/

//  Attempt 3:  Roxie query  ---

varstring typeofbreach_value := '' : stored('TypeOfBreach');
varstring coveredentitytype_value := '' : stored('CoveredEntityType');
varstring locationofinformation_value := '' : stored('LocationOfInformation');

fetched := FETCH(DataBreach.File, DataBreach.Idx(   typeofbreach_value = '' OR typeofbreach_value = TypeOfBreach, 
                                                    coveredentitytype_value = '' OR coveredentitytype_value = CoveredEntityType, 
                                                    locationofinformation_value = '' OR locationofinformation_value = LocationOfInformation), RIGHT.RecPos);
byDate2 := TABLE(fetched, {
    SubmissionDate, 
    UNSIGNED INTEGER4 MinIndividualsAffected := MIN(GROUP, IndividualsAffected),
    UNSIGNED INTEGER4 AveIndividualsAffected := AVE(GROUP, IndividualsAffected),
    UNSIGNED INTEGER4 MaxIndividualsAffected := MAX(GROUP, IndividualsAffected)
}, SubmissionDate, FEW);

sortByDate := SORT(byDate2, SubmissionDate);
limitedOutput := CHOOSEN(sortByDate, 2000);
nullOutput := DATASET([], {STRING SubmissionDate, UNSIGNED INTEGER4 MinIndividualsAffected, UNSIGNED INTEGER4 AveIndividualsAffected, UNSIGNED INTEGER4 MaxIndividualsAffected});

OUTPUT(IF (typeofbreach_value = '' AND coveredentitytype_value = '' AND locationofinformation_value = '', nullOutput, limitedOutput), NAMED('DataBreachFiltered'), OVERWRITE);
/*
*/
