public without sharing class TicketmasterConnector {
    
    @TestVisible
    private static String continuationLabel;
    // Action method
    @AuraEnabled(continuation=true cacheable=true)
    public static Object startRequest(String id) {
        System.debug('entering continuation...');
        System.debug('account id: ' + id);
        
        //get the recordGeohash
        Account ac = [SELECT id, Geohash__c FROM Account WHERE Id = :id LIMIT 1];
        System.debug('geohash from record: ' + ac.Geohash__c);
        // Create continuation. Argument is timeout in seconds.
        Continuation con = new Continuation(60);
        // Set callback method
        con.continuationMethod='renderResponse';
        
        // Create callout request
        HttpRequest req = new HttpRequest();
        ticketmaster_settings__c teaSet = [select id, consumer_key__c from ticketmaster_settings__c];
        System.debug('consumer key: ' + teaSet.consumer_key__c);
        req.setMethod('GET');
        req.setEndpoint('callout:ticketmaster_discovery' + '/v2/events.json?countryCode=US&apikey='  
        + teaSet.consumer_key__c + '&geoPoint=' + ac.Geohash__c + '&size=5&unit=miles&radius=50&sort=distance,asc' );
         // Configure standard headers
        req.setHeader('Accept-Encoding', 'gzip, deflate, br');
        req.setHeader('Accept', '*/*');
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');

        // Store the reference to the HttRequest and make it accessible for a test-context
        continuationLabel = con.addHttpRequest(req);
        // Store data to be sent to the callback function
        con.state='httpRequest complete';
        // Return the continuation
        System.debug('returning continuation...');
        return con;
    }
    
    // Callback method
    @AuraEnabled(cacheable=true)
    public static Object renderResponse(List<String> labels, Object state) {
        System.debug('continuation callack method executing');
        // Get the response using the unique label
        HttpResponse response = Continuation.getResponse(labels[0]);
        //truncated in console
        System.debug('response body: ' + response.getBody());
        if (response.getStatusCode() == 200) {
            String result = response.getBody();
            return result;
        }
        return null;
    }
   
}
