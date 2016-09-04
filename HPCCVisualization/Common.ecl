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
    
    EXPORT Meta(STRING _classID, STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
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
    
    EXPORT Table(STRING _id, STRING _dataSource = '', STRING _outputName = '', DATASET(KeyValueDef) _properties = NullKeyValue, DATASET(FiltersDef) _filteredBy = NullFilters) := FUNCTION
        RETURN Meta('other_Table', _id, _dataSource, _outputName, _properties, _filteredBy);
    END;
END;
