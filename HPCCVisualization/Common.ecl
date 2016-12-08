EXPORT Common := MODULE
    IMPORT Std;

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

    /**
    * Meta - Outputs visualization meta information  
    *
    * Creates a "special" output file, containing the meta information for 
    * the visualization.
    * 
    * @param _classID       Visualization Type
    * @param _id            Visualization ID
    * @param _dataSource    Location of result (WU, Logical File, Roxie)
    * @param _outputName    Result name (ignored for Logical Files)
    * @param _mappings      Maps Column Name <--> field ID
    * @param _filteredBy    Specifies filter condition
    * @param _properties    User specified dermatology properties
    * @return               A "meta" output describing the visualization 
    **/    
    EXPORT Meta(STRING _classID, STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        MetaDef := RECORD 
            STRING classid;
            STRING datasource;
            STRING resultname;
            DATASET(KeyValueDef) mappings;
            DATASET(FiltersDef) filteredby;
            DATASET(KeyValueDef) properties;
        END;

        id := IF(_id = '', _outputName, _id);
        ds := DATASET([{_classID, _dataSource, _outputName, _mappings, _filteredBy, _properties}], MetaDef);
        RETURN OUTPUT(ds, NAMED(id + '__hpcc_visualization'));
    END;
END;
