HOST=localhost:8080/v1.0

# ----------------------------------------
# Create Test Thing(1) with location, 2 Datastreams, ObservedProperty and Sensor
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
    "name": "lantern",
    "description": "camping lantern",
    "properties": {
        "property1": "it’s waterproof",
        "property2": "it glows in the dark",
        "property3": "it repels insects"
    },
    "Locations": [{
        "name": "bla",
        "description": "my backyard",
        "encodingType": "application/vnd.geo+json",
        "location": {
            "type": "Point",
            "coordinates": [-117.123,
            54.123]
        }
    }],
    "Datastreams": [{
        "name": "DS1",
        "unitOfMeasurement": {
            "name": "Celsius",
            "symbol": "C",
            "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#Celsius"
        },
        "description": "Temperature measurement",
        "observationType": "http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement",
        "ObservedProperty": {
            "name": "Temperature",
            "definition": "http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#Temperature",
            "description": "Temperature of the camping site"
        },
        "Sensor": {
            "name": "This is a name",
            "description": "SensorUp Tempomatic 2000",
            "encodingType": "application/pdf",
            "metadata": "Calibration date:  Jan 1, 2014"
        }
    },
	{
        "name": "DS2",
        "unitOfMeasurement": {
            "name": "Celsius",
            "symbol": "C",
            "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#Celsius"
        },
        "description": "Temperature measurement 2",
        "observationType": "http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement",
        "ObservedProperty": {
            "@iot.id": 1
        },
        "Sensor": {
            "@iot.id": 1
        }
    }]
}' "$HOST/Things"

# ----------------------------------------
# Create Test Thing(2) with location, Datastream, ObservedProperty and Sensor
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
    "name": "lantern 2",
    "description": "camping lantern 2",
    "properties": {
        "property1": "it’s waterproof"
    },
    "Locations": [{
        "name": "bla 2",
        "description": "my backyard 2",
        "encodingType": "application/vnd.geo+json",
        "location": {
            "type": "Point",
            "coordinates": [-117.123,
            54.123]
        }
    }],
    "Datastreams": [{
        "name": "DS3",
        "unitOfMeasurement": {
            "name": "Celsius",
            "symbol": "C",
            "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#Celsius"
        },
        "description": "Temperature measurement 3",
        "observationType": "http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement",
        "ObservedProperty": {
			"@iot.id": 1
        },
        "Sensor": {
            "@iot.id": 1
        }
    }]
}' "$HOST/Things"

# ----------------------------------------
# Create Test Thing(3) with location, Datastream, ObservedProperty and Sensor
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
    "name": "lantern 3",
    "description": "camping lantern 3",
    "properties": {
        "property1": "it’s waterproof"
    },
    "Locations": [{
        "name": "bla 3",
        "description": "my backyard 3",
        "encodingType": "application/vnd.geo+json",
        "location": {
            "type": "Point",
            "coordinates": [-117.123,
            54.123]
        }
    }],
    "Datastreams": [{
        "name": "DS4",
        "unitOfMeasurement": {
            "name": "Celsius",
            "symbol": "C",
            "definition": "http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#Celsius"
        },
        "description": "Temperature measurement 4",
        "observationType": "http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement",
        "ObservedProperty": {
			"@iot.id": 1
        },
        "Sensor": {
            "@iot.id": 1
        }
    }]
}' "$HOST/Things"

# ----------------------------------------
# Create Test FOI 1
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
    "name": "test foi 1",
    "description": "nothing",
    "encodingType": "application/vnd.geo+json",
    "feature": {
        "coordinates": [51.08386,-114.13036],
        "type": "Point"
      }
}' "$HOST/FeaturesOfInterest"

# ----------------------------------------
# Create Test FOI 2
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
    "name": "test foi 2",
    "description": "nothing",
    "encodingType": "application/vnd.geo+json",
    "feature": {
        "coordinates": [52.08386,-115.13036],
        "type": "Point"
      }
}' "$HOST/FeaturesOfInterest"


# ----------------------------------------
# Create Observation in Datastreams 1 wich is in resultTime range but outside FOI filter name eq 'test foi 2' (should not return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 1,
	"resultTime": "2010-06-01T00:00:00Z",
	"featureOfInterest": {
		"@iot.id": 1
	}
}' "$HOST/Datastreams(1)/Observations"

# ----------------------------------------
# Create Observation 2 in Datastreams 1 wich is outside resultTime range but inside FOI filter name eq 'test foi 2' (should not return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 2,
	"resultTime": "2010-05-29T00:00:00Z",
	"featureOfInterest": {
		"@iot.id": 2
	}
}' "$HOST/Datastreams(1)/Observations"

# ----------------------------------------
# Create Observation 3 in Datastreams 1 wich is inside resultTime range and inside FOI filter name eq 'test foi 2' (should return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 3,
	"resultTime": "2010-06-01T00:00:00Z",
	"featureOfInterest": {
		"@iot.id": 2
	}
}' "$HOST/Datastreams(1)/Observations"

# ----------------------------------------
# Create Observation 4 in Datastreams 1 wich is inside resultTime range and inside FOI filter name eq 'test foi 2' (should return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 4,
	"resultTime": "2010-06-20T12:00:00Z",
	"featureOfInterest": {
		"@iot.id": 2
	}
}' "$HOST/Datastreams(1)/Observations"

# ----------------------------------------
# Create Observation 5 in Datastreams 1 wich is outside resultTime range but inside FOI filter name eq 'test foi 2' (should not return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 5,
	"resultTime": "2010-08-01T00:00:00Z",
	"featureOfInterest": {
		"@iot.id": 2
	}
}' "$HOST/Datastreams(1)/Observations"

# ----------------------------------------
# Create Observation 6 in Datastreams 2 wich is outside resultTime range but inside FOI filter name eq 'test foi 2' (should not return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 6,
	"resultTime": "2010-05-29T00:00:00Z",
	"featureOfInterest": {
		"@iot.id": 2
	}
}' "$HOST/Datastreams(2)/Observations"

# ----------------------------------------
# Create Observation 7 in Datastreams 3 wich is outside resultTime range but inside FOI filter name eq 'test foi 2' (should not return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 7,
	"resultTime": "2010-05-29T00:00:00Z",
	"featureOfInterest": {
		"@iot.id": 2
	}
}' "$HOST/Datastreams(3)/Observations"

# ----------------------------------------
# Create Observation 8 in Datastreams 4 wich is inside resultTime range and inside FOI filter name eq 'test foi 2' (should return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 8,
	"resultTime": "2010-06-01T00:00:00Z",
	"featureOfInterest": {
		"@iot.id": 2
	}
}' "$HOST/Datastreams(4)/Observations"

# ----------------------------------------
# Create Observation 9 in Datastreams 4 wich is inside resultTime range and inside FOI filter name eq 'test foi 2' (should return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 9,
	"resultTime": "2010-06-20T12:00:00Z",
	"featureOfInterest": {
		"@iot.id": 2
	}
}' "$HOST/Datastreams(4)/Observations"

# ----------------------------------------
# Create Observation 10 in Datastreams 4 wich is outside resultTime range but inside FOI filter name eq 'test foi 2' (should not return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 10,
	"resultTime": "2010-08-01T00:00:00Z",
	"featureOfInterest": {
		"@iot.id": 2
	}
}' "$HOST/Datastreams(4)/Observations"
