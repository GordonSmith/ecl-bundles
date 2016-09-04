IMPORT $.Common;
EXPORT ChartND := MODULE(Common)
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
        
    EXPORT Area(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        RETURN Meta('chart_Area', _id, _dataSource, _outputName, _properties, _filteredBy);
    END;
    
    EXPORT Bar(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        RETURN Meta('chart_Bar', _id, _dataSource, _outputName, _properties, _filteredBy);
    END;
    
    EXPORT Column(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        _props2 := DATASET([{'playInterval', 3000}], KeyValueDef) + _properties;
        RETURN Meta('chart_Column', _id, _dataSource, _outputName, _props2, _filteredBy);
    END;

    EXPORT HexBin(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        RETURN Meta('chart_HexBin', _id, _dataSource, _outputName, _properties, _filteredBy);
    END;

    EXPORT Line(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        RETURN Meta('chart_Line', _id, _dataSource, _outputName, _properties, _filteredBy);
    END;

    EXPORT Scatter(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        RETURN Meta('chart_Scatter', _id, _dataSource, _outputName, _properties, _filteredBy);
    END;

    EXPORT Step(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        RETURN Meta('chart_Step', _id, _dataSource, _outputName, _properties, _filteredBy);
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
                        {STRING subject, INTEGER year1, INTEGER year2, INTEGER year3, INTEGER year4});
        op_data := OUTPUT(ds, NAMED('myData'));

        viz_area := Area('area',, 'myData');
        viz_bar := Bar('bar',, 'myData');
        viz_column := Column('column',, 'myData');
        viz_hexBin := HexBin('hexBin',, 'myData');
        viz_line := Line('line',, 'myData');
        viz_scatter := Scatter('scatter',, 'myData');
        viz_step := Step('step',, 'myData');
        
        RETURN SEQUENTIAL(op_data, viz_area, viz_bar, viz_column, viz_hexBin, viz_line, viz_scatter, viz_step);
    END;
    
    EXPORT main := FUNCTION
        RETURN SEQUENTIAL(__test);
    END;
END;
