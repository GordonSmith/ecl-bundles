IMPORT $.Common;

EXPORT Chart2D := MODULE(Common)
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
        
    EXPORT Bubble(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        RETURN Meta('chart_Bubble', _id, _dataSource, _outputName, _properties, _filteredBy);
    END;
    
    EXPORT Pie(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        RETURN Meta('chart_Pie', _id, _dataSource, _outputName, _properties, _filteredBy);
    END;
    
    EXPORT Summary(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        _props2 := DATASET([{'playInterval', 3000}], KeyValueDef) + _properties;
        RETURN Meta('chart_Summary', _id, _dataSource, _outputName, _props2, _filteredBy);
    END;

    EXPORT WordCloud(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        RETURN Meta('other_WordCloud', _id, _dataSource, _outputName, _properties, _filteredBy);
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
        data_exams := OUTPUT(ds, NAMED('myData'));
        
        viz_bubble := Bubble('bubble',, 'myData');
        viz_pie := Pie('pie',, 'myData');
        viz_summary := Summary('summary',, 'myData');
        viz_wordCloud := WordCloud('wordCloud',, 'myData');
        
        RETURN SEQUENTIAL(data_exams, viz_bubble, viz_pie, viz_summary, viz_wordCloud);
    END;
    
    EXPORT main := FUNCTION
        RETURN SEQUENTIAL(__test);
    END;
END;
