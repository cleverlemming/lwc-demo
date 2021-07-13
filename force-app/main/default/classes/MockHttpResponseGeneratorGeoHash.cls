@isTest
global class MockHttpResponseGeneratorGeoHash implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
       
        //System.assert(String.containsIgnoreCase('geohash.world/v1/encode'));
        //System.assertEquals('GET', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"query": "/v1/encode/37.983810,23.727539?pre=6","lat": 37.98381,"lon": 23.727539,"precision": 6,"geohash": "swbb5f"}');
        //DEBUG|geohash mockresponse: {"query": "/v1/encode/37.983810,23.727539?pre=6","lat": 37.98381,"lon": 23.727539,"precision": 6,"geohash": "swbb5f"}
        res.setStatusCode(200);
        System.debug('returning geohash mocked response: ' + res);
        return res;
    }
}