IMPORT $.Chart2D;
IMPORT $.ChartND;
IMPORT $.GeoSpatial;
IMPORT $.SampleData.DataBreach;

//  Aggregate by State ---
byDow := TABLE(DataBreach.RawDataset, {
    SubmissionDate, 
    UNSIGNED INTEGER4 MinIndividualsAffected := MIN(GROUP, IndividualsAffected),
    UNSIGNED INTEGER4 AveIndividualsAffected := AVE(GROUP, IndividualsAffected),
    UNSIGNED INTEGER4 MaxIndividualsAffected := MAX(GROUP, IndividualsAffected)
}, SubmissionDate, FEW);
OUTPUT(CHOOSEN(SORT(byDow, SubmissionDate), ALL), NAMED('SubmissionDOW'));
ChartND.Line('myLine',, 'SubmissionDOW', DATASET([{'xAxisType', 'time'}, {'xAxisFocus', 1}, {'xAxisTypeTimePattern', '%Y-%m-%dT%H:%M:%S.%LZ'}, {'yAxisType', 'pow'}, {'yAxisTypePowExponent', 0.06}], ChartND.KeyValueDef));

