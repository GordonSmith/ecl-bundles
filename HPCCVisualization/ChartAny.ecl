/*
    Any Visualizations

    The following visualizations work with "any" data shapes.

    See __test for an example.
*/    

IMPORT $.Common;

EXPORT ChartAny := MODULE(Common)
    IMPORT Std;

    EXPORT Bundle := MODULE(Std.BundleBase)
        EXPORT Name := 'HPCCVisualization';
        EXPORT Description := 'HPCC Visualizations';
        EXPORT Authors := ['HPCC Systems'];
        EXPORT License := 'http://www.apache.org/licenses/LICENSE-2.0';
        EXPORT Copyright := 'Copyright (C) 2016 HPCC Systems';
        EXPORT DependsOn := [];
        EXPORT Version := '0.0.0';
    END;

        
    /**
    * Grid - Renders data in a data grid / table 
    *
    * mappings can be used to limit / rename the columns.
    * 
    * @param _id            Visualization ID
    * @param _dataSource    Location of result (WU, Logical File, Roxie), defaults to current WU
    * @param _outputName    Result name (ignored for Logical Files)
    * @param _mappings      Maps Column Name <--> field ID
    * @param _filteredBy    Specifies filter condition
    * @param _properties    User specified dermatology properties
    * @return               A "meta" output describing the visualization 
    * @see                  Common/Meta
    **/    
    EXPORT Grid(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Meta('other_Table', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
    END;

    EXPORT HandsonGrid(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Meta('handson_Table', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
    END;


    EXPORT __test := FUNCTION
        ds := DATASET([ {'English', 5, 43, 41, 92},
                        {'History', 17, 43, 83, 93},
                        {'Geography', 7, 45, 52, 83},
                        {'Chemistry', 16, 73, 52, 83},
                        {'Spanish', 26, 83, 11, 72},
                        {'Bioligy', 66, 60, 85, 6},
                        {'Physics', 46, 20, 53, 7},
                        {'Math', 98, 30, 23, 13}],
                        {STRING subject, INTEGER4 year1, INTEGER4 year2, INTEGER4 year3, INTEGER4 year4});
        data_exams := OUTPUT(ds, NAMED('ChartAny__test'));

        viz_grid := Grid('grid',, 'ChartAny__test');
        viz_grid2 := HandsonGrid('handsonGrid',, 'ChartAny__test', DATASET([{'Subject', 'subject'}, {'2013', 'year3'}, {'2014', 'year4'}], KeyValueDef), , DATASET([{'fixedColumn', true}], KeyValueDef));
        
        RETURN SEQUENTIAL(data_exams, viz_grid, viz_grid2);
    END;
    
    EXPORT main := FUNCTION
        RETURN __test;
    END;
END;
