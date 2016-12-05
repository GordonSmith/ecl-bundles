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
    
    EXPORT Table(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _mappings = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters, DATASET(KeyValueDef) _properties = NullKeyValue) := FUNCTION
        RETURN Meta('other_Table', _id, _dataSource, _outputName, _mappings, _filteredBy, _properties);
    END;
END;
