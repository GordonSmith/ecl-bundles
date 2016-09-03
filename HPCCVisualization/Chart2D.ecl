EXPORT Chart2D := MODULE, FORWARD
    IMPORT Std;

    EXPORT Bundle := MODULE(Std.BundleBase)
        EXPORT Name := 'HPCCVisualization';
        EXPORT Description := 'HPCC Visualizations';
        EXPORT Authors := ['Gordon Smith'];
        EXPORT License := 'http://www.apache.org/licenses/LICENSE-2.0';
        EXPORT Copyright := 'Copyright (C) 2016 HPCC Systems';
        EXPORT DependsOn := [];
        EXPORT Version := '0.0.0';
    END;
        
    EXPORT KeyValueDef := RECORD 
        STRING key;
        STRING value 
    END;
    SHARED NullKeyValue := DATASET([], KeyValueDef);

    EXPORT FiltersDef := RECORD 
        STRING source;
        DATASET(KeyValueDef) mappings;
    END;
    SHARED NullFilters := DATASET([], FiltersDef);

    EXPORT Chart(STRING _classID, STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        MetaDef := RECORD 
            STRING classid;
            STRING datasource;
            STRING resultname;
            DATASET(KeyValueDef) properties;
            DATASET(FiltersDef) filteredby;
        END;

        id := IF(_id = '', _outputName, _id);
        ds := DATASET([{_classID, _dataSource, _outputName, _properties, _filteredBy}], MetaDef);
        RETURN OUTPUT(ds, NAMED(id + '__hpcc_visualization'));
    END;
        
    EXPORT Column(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Chart('chart_Column', _id, _dataSource, _outputName, _properties);
    END;

    EXPORT Bar(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Chart('chart_Bar', _id, _dataSource, _outputName, _properties);
    END;

    EXPORT Pie(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Chart('chart_Pie', _id, _dataSource, _outputName, _properties);
    END;
    
    EXPORT Table(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        RETURN Chart('other_Table', _id, _dataSource, _outputName, _properties, _filteredBy);
    END;
    
    EXPORT __test_column := FUNCTION
        ds := DATASET([ {'English', 5, 43, 41, 92},
                        {'History', 17, 43, 83, 93},
                        {'Geography', 7, 45, 52, 83},
                        {'Chemistry', 16, 73, 52, 83},
                        {'Spanish', 26, 83, 11, 72},
                        {'Bioligy', 66, 60, 85, 6},
                        {'Physics', 46, 20, 53, 7},
                        {'Math', 98, 30, 23, 13}],
                        {STRING subject, INTEGER year1, INTEGER year2, INTEGER year3, INTEGER year4});
        dataOut := OUTPUT(ds, NAMED('myData'));
        vizOut := Chart('chart_Column', 'col1',, 'myData');
        vizOut2 := Chart('chart_Column', 'bar1',, 'myData', DATASET([{'orientation', 'vertical'}], KeyValueDef));
        vizOut3 := Chart('chart_Pie', 'pie1',, 'myData');
        RETURN SEQUENTIAL(dataOut, vizOut, vizOut2, vizOut3);
    END;
        
    EXPORT __test_sampleData := FUNCTION
        IMPORT $.SampleData;
        IMPORT $.Chart2D;
        
        //  Sample Data  ---
        DataBreach := SampleData.DataBreach;

        //  Aggregate by TypeOfBreach ---
        op1 := OUTPUT(TABLE(DataBreach, {BreachType := TypeOfBreach, SumIndividualsAffected := SUM(GROUP, IndividualsAffected)}, TypeOfBreach, FEW), NAMED('TypeOfBreach'));
        myColumnChart := Chart2D.Column('myColumnChart',, 'TypeOfBreach', DATASET([{'xAxisFocus', true}], Chart2D.KeyValueDef));

        //  Aggregate by CoveredEntityType ---
        op2 := OUTPUT(TABLE(DataBreach, {CoveredEntityType, SumIndividualsAffected := SUM(GROUP, IndividualsAffected)}, CoveredEntityType, FEW), NAMED('CoveredEntityType'));
        myPieChart := Chart2D.Pie('myPieChart',, 'CoveredEntityType');

        //  Aggregate by LocationOfInformation ---
        op3 := OUTPUT(TABLE(DataBreach, {LocationOfInformation, SumIndividualsAffected := SUM(GROUP, IndividualsAffected)}, LocationOfInformation, FEW), NAMED('LocationOfInformation'));
        myBarChart := Chart2D.Bar('myBarChart',, 'LocationOfInformation');
        
        op4 := OUTPUT(CHOOSEN(DataBreach, ALL), NAMED('DataBreach'));
        myTableFilter := DATASET([
            {'myColumnChart', [{'BreachType', 'TypeOfBreach'}]},
            {'myPieChart', [{'CoveredEntityType', 'CoveredEntityType'}]},
            {'myBarChart', [{'LocationOfInformation', 'LocationOfInformation'}]}
        ], Chart2D.FiltersDef);
        myTables := SEQUENTIAL( Chart2D.Table('myTable',, 'DataBreach',, myTableFilter),
                                Chart2D.Table('myTable2','~HPCCVisualization::DataBreach',, , myTableFilter),
                                Chart2D.Table('myTable3','http://192.168.3.22:8002/WsEcl/submit/query/roxie/databreach.1', 'result_1', , myTableFilter));

        RETURN SEQUENTIAL(op1, op2, op3, op4, myColumnChart, myPieChart, myBarChart, myTables);
    END;

    EXPORT main := FUNCTION
        RETURN SEQUENTIAL(__test_sampleData);//__test_column, __test_functionMacros.run);
    END;

    /*
    EXPORT aggregateData(_d, _aggrBy, _groupBy, _AGGR) := FUNCTIONMACRO
        LOCAL aggr := _AGGR(GROUP, _d._groupBy);
        LOCAL aggrRec := { _d._aggrBy, _groupBy := aggr};
        RETURN TABLE(_d, aggrRec, _d._aggrBy, FEW);
    ENDMACRO;
    */
        
    /*
    EXPORT __test_functionMacros := MODULE
        IMPORT $.SampleData;
        ds := aggregateData(SampleData.DataBreach, TypeOfBreach, IndividualsAffected, SUM);
        dataOut := OUTPUT(ds, NAMED('breach1'));
        vizOut := Chart('other_Table', 'table1', 'breach1', DATASET([{'pagination', false}], KeyValueDef));
        EXPORT run := SEQUENTIAL(dataOut, vizOut);
    END;
    */    

END;
