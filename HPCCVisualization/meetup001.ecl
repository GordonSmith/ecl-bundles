IMPORT $.SampleData.DataBreach;

ds := DataBreach.File;

SampleDef := RECORD
    STRING _sample;
    INTEGER4 sampleCount;
END;

CardinalityReportDef := RECORD
  STRING fieldID;
  INTEGER4 rowCount;
  DATASET(SampleDef) top5;
  DATASET(SampleDef) bottom5;
END;

calcCardinality(field, label) := FUNCTIONMACRO
    cardTable := TABLE(ds, {fieldID := field, fieldCount := COUNT(GROUP)}, field, FEW);

    SampleDef toSampleDef(cardTable l) := TRANSFORM
      SELF._sample := (STRING)l.fieldID;
      SELF.sampleCount := l.fieldCount;
    END;
    top5 := CHOOSEN(SORT(cardTable, -fieldCount), 5);
    bottom5 := CHOOSEN(SORT(cardTable, fieldCount), 5);

    RETURN DATASET([{label, COUNT(cardTable), PROJECT(top5, toSampleDef(LEFT)), PROJECT(bottom5, toSampleDef(LEFT))}], CardinalityReportDef);
ENDMACRO;

report := 
    calcCardinality(ds.State, 'State') +
    calcCardinality(ds.CoveredEntityType, 'CoveredEntityType') +
    calcCardinality(ds.IndividualsAffected, 'IndividualsAffected') +
    calcCardinality(ds.SubmissionDate, 'SubmissionDate') +
    calcCardinality(ds.TypeOfBreach, 'TypeOfBreach') +
    calcCardinality(ds.LocationOfInformation, 'LocationOfInformation') +
    calcCardinality(ds.SubmissionYear, 'SubmissionYear') +
    calcCardinality(ds.SubmissionMonth, 'SubmissionMonth') +
    calcCardinality(ds.SubmissionQuarter, 'SubmissionQuarter') +
    calcCardinality(ds.SubmissionDOW, 'SubmissionDOW') +
    calcCardinality(ds.SubmissionDay, 'SubmissionDay')
;
OUTPUT(SORT(report, rowCount));
