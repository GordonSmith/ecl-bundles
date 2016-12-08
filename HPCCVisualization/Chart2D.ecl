/*
    Two Dimensional Visualizations

    Default Data requirements (can be overriden by mappings):
     * 2 Columns
       - Column 1 (string):  Label
       - Column 2 (number):  Value

    All other columns will be ignored.  See __test for an example.
*/    

IMPORT $.Common;

EXPORT Chart2D := MODULE(Common)
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
    EXPORT Bubble(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Meta('chart_Bubble', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
    END;
    
    EXPORT Pie(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Meta('chart_Pie', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
    END;
    
    EXPORT Summary(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        _props2 := DATASET([{'playInterval', 3000}], KeyValueDef) + _properties;
        RETURN Meta('chart_Summary', _id, _dataSource, _outputName, , _filteredBy, _props2);
    END;

    EXPORT WordCloud(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Meta('other_WordCloud', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
    END;
    

    EXPORT __test := FUNCTION
        ds := DATASET([ {'English', 5},
                        {'History', 17},
                        {'Geography', 7},
                        {'Chemistry', 16},
                        {'Irish', 26},
                        {'Spanish', 67},
                        {'Bioligy', 66},
                        {'Physics', 46},
                        {'Math', 98}],
                        {STRING subject, INTEGER4 year});
        data_exams := OUTPUT(ds, NAMED('Chart2D__test'));
        
        viz_bubble := Bubble('bubble',, 'Chart2D__test');
        viz_pie := Pie('pie',, 'Chart2D__test');
        viz_summary := Summary('summary',, 'Chart2D__test');
        viz_wordCloud := WordCloud('wordCloud',, 'Chart2D__test');
        
        RETURN SEQUENTIAL(data_exams, viz_bubble, viz_pie, viz_summary, viz_wordCloud);
    END;
    
    EXPORT main := FUNCTION
        RETURN __test;
    END;
END;
