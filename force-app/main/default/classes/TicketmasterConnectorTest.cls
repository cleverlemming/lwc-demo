@isTest
private class TicketmasterConnectorTest {
    @isTest static void calloutTest() {

        //create a custom setting
        ticketmaster_settings__c setting = new ticketmaster_settings__c();
        setting.Name = 'test_settings';
        setting.consumer_key__c = 'mockconsumerkey';
        insert setting;

        //get the ticketmaster result
        Http_Response__mdt tm = Http_Response__mdt.getInstance('Ticketmaster');
    
        //create an account 
        List <Account> accountList = TestDataFactory.createAccounts(1);
        //need an assigned Id
        insert accountList;

        String mockResponseBody = tm.Json_Payload__c;
 
        Test.startTest();
        Continuation con = (Continuation) TicketmasterConnector.startRequest(accountList[0].id);
        Test.stopTest();

 
        // Verify that the continuation has the correct number of requests
        Map<String, HttpRequest> requests = con.getRequests();
        
        for (String it : requests.keySet() ){
            system.debug('httprequests key: ' + it);
            system.debug('httprequests value: ' + requests.get(it));
        }
        
        System.assertEquals(1, requests.size(), 'The number of requests associated to the Continuation is not correct');

        // Create a mock response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(mockResponseBody);

        Test.setContinuationResponse(TicketmasterConnector.continuationLabel, response);
        //Test.invokeContinuationMethod(TicketmasterConnector, requests)

        List<String> labels = new List<String>{TicketmasterConnector.continuationLabel};
 
        String result = (String)TicketmasterConnector.renderResponse(labels, TicketmasterConnector.continuationLabel);
        system.debug('result: ' + result);

        System.assertEquals(true, result.contains('_embedded'), 'ticketmaster payload data not found');
 
    }
}


