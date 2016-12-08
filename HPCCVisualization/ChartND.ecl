/*
    Multi Dimensional Visualizations

    Data requirements (can be overriden by mappings):
     * N Columns
       - Column 1 (string):  Label
       - Column 2 (number):  Value
       - Column 3 (number):  Value
       ...
       - Column N (number):  Value

    See __Test for an example.
*/    

IMPORT $.Common;

EXPORT ChartND := MODULE(Common)
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
    * Area - Renders data in a XY Axis chart 
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
    EXPORT Area(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Meta('chart_Area', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
    END;
    
    EXPORT Bar(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Meta('chart_Bar', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
    END;
    
    EXPORT Column(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Meta('chart_Column', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
    END;

    EXPORT HexBin(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Meta('chart_HexBin', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
    END;

    EXPORT Line(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Meta('chart_Line', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
    END;

    EXPORT Scatter(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Meta('chart_Scatter', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
    END;

    EXPORT Step(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Meta('chart_Step', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
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
        data_exams := OUTPUT(ds, NAMED('Chart2D__test'));

        viz_area := Area('area',, 'Chart2D__test');
        viz_bar := Bar('bar',, 'Chart2D__test');
        viz_column := Column('column',, 'Chart2D__test');
        viz_hexBin := HexBin('hexBin',, 'Chart2D__test');
        viz_line := Line('line',, 'Chart2D__test');
        viz_scatter := Scatter('scatter',, 'Chart2D__test');
        viz_step := Step('step',, 'Chart2D__test');
        
        RETURN SEQUENTIAL(data_exams, viz_area, viz_bar, viz_column, viz_hexBin, viz_line, viz_scatter, viz_step);
    END;
    
    EXPORT main := FUNCTION
        RETURN __test;
    END;
END;
