/*
    Geo Spatial Visualizations

    Data requirements (can be overriden by mappings):
     * 2 Columns
       - Column 1 (string):  location ID (depends on geo spatial type)
       - Column 2 (number):  Value

    See __Test for an example.
*/    


IMPORT $.Common;

EXPORT GeoSpatial := MODULE(Common)
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
    
    EXPORT Choropleth := MODULE

        /**
        * USStates - US States Choropleth 
        *
        * Data requirements (can be overriden by mappings):
        *  * 2 Columns
        *    - Column 1 (string):  State 2 letter code
        *    - Column 2 (number):  Value
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
        EXPORT USStates(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
            RETURN Meta('map_ChoroplethStates', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
        END;

        /**
        * USCounties - US States Choropleth 
        *
        * Data requirements (can be overriden by mappings):
        *  * 2 Columns
        *    - Column 1 (number):  FIPS code
        *    - Column 2 (number):  Value
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
        EXPORT USCounties(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
            RETURN Meta('map_ChoroplethCounties', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
        END;

        /**
        * Euro - US States Choropleth 
        *
        * Data requirements (can be overriden by mappings):
        *  * 2 Columns
        *    - Column 1 (number):  Administration name
        *    - Column 2 (number):  Value
        *
        * @param _id            Visualization ID
        * @param _region        2 Letter Euro Code (GB, IE etc.)
        * @param _dataSource    Location of result (WU, Logical File, Roxie), defaults to current WU
        * @param _outputName    Result name (ignored for Logical Files)
        * @param _mappings      Maps Column Name <--> field ID
        * @param _filteredBy    Specifies filter condition
        * @param _properties    User specified dermatology properties
        * @return               A "meta" output describing the visualization 
        * @see                  Common/Meta
        **/    
        EXPORT Euro(STRING _id, STRING _region, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
            _props2 := DATASET([{'region', _region}], KeyValueDef) + _properties;
            RETURN Meta('map_TopoJSONChoropleth', _id, _dataSource, _outputName, _mappings, _filteredBy, _props2);
        END;

        EXPORT EuroIE(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
            RETURN Euro(_id, 'IE', _dataSource, _outputName, _mappings, _filteredBy, _properties);
        END;

        EXPORT EuroGB(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
            RETURN Euro(_id, 'GB', _dataSource, _outputName, _mappings, _filteredBy, _properties);
        END;
    END;
    
    EXPORT GoogleMap := MODULE 
        EXPORT Pins(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
            RETURN Meta('map_GMapPins', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
        END;
    END;
   

    SHARED __testData := FUNCTION
        usStates := DATASET([   {'AL', 4779736}, 
                                {'AK', 710231}, 
                                {'AZ', 6392017}, 
                                {'AR', 2915918}],
                            {STRING State, INTEGER4 weight});
        data_usStates := OUTPUT(usStates, NAMED('geospatial_usStates'));

        usCounties := DATASET([ {1073,29.946185501741},
                                {1097,0.79566003616637},
                                {1117,1.5223596574691},
                                {4005,27.311773623042}],
                                {STRING FIPS, INTEGER4 weight});
        data_usCounties := OUTPUT(usCounties, NAMED('geospatial_usCounties'));
        
        euroIE := DATASET([ {'Carlow', '27431', '27181', '54612'}, 
                            {'Dublin City', '257303', '270309', '527612'}, 
                            {'Kilkenny', '47788', '47631', '95419'}, 
                            {'Cork', '198658', '201144', '399802'}],
                            {STRING region, INTEGER4 males, INTEGER4 females, INTEGER4 total});
        data_euroIE := OUTPUT(euroIE, NAMED('geospatial_euroIE'));
        
        RETURN SEQUENTIAL(data_usStates, data_usCounties, data_euroIE);
    END;

    EXPORT __test := FUNCTION
        viz_usstates := Choropleth.USStates('usStates',, 'geospatial_usStates');
        viz_uscounties := Choropleth.USCounties('usCounties',, 'geospatial_usCounties');
        viz_euroIE := Choropleth.EuroIE('euroIE',, 'geospatial_euroIE', DATASET([{'County', 'region'}, {'Population', 'total'}], KeyValueDef),, DATASET([{'paletteID', 'Greens'}], KeyValueDef));
        viz_euroGB := Choropleth.EuroGB('euroGB');
        
        RETURN SEQUENTIAL(__testData, viz_usstates, viz_uscounties, viz_euroIE, viz_euroGB);
    END;
    
    EXPORT main := FUNCTION
        RETURN __test;
    END;
END;
