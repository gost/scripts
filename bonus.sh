HOST=localhost:8080/v1.0

# ----------------------------------------
# Create Test Thing(1) with location, Datastream, ObservedProperty and Sensor
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
# Create Observation 1 in Datastreams 1 wich is outside resultTime range but inside FOI filter name eq 'test foi 2' (should not return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 2,
	"resultTime": "2010-05-29T00:00:00Z",
	"featureOfInterest": {
		"@iot.id": 2
	}
}' "$HOST/Datastreams(1)/Observations"

# ----------------------------------------
# Create Observation 2 in Datastreams 1 wich is inside resultTime range and inside FOI filter name eq 'test foi 2' (should return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 3,
	"resultTime": "2010-06-01T00:00:00Z",
	"featureOfInterest": {
		"@iot.id": 2
	}
}' "$HOST/Datastreams(1)/Observations"

# ----------------------------------------
# Create Observation 3 in Datastreams 1 wich is inside resultTime range and inside FOI filter name eq 'test foi 2' (should return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 4,
	"resultTime": "2010-06-20T12:00:00Z",
	"featureOfInterest": {
		"@iot.id": 2
	}
}' "$HOST/Datastreams(1)/Observations"

# ----------------------------------------
# Create Observation 4 in Datastreams 1 wich is outside resultTime range but inside FOI filter name eq 'test foi 2' (should not return)
# ----------------------------------------
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -d '{
	"result" : 5,
	"resultTime": "2010-08-01T00:00:00Z",
	"featureOfInterest": {
		"@iot.id": 2
	}
}' "$HOST/Datastreams(1)/Observations"



