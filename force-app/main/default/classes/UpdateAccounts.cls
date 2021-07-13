public class UpdateAccounts implements Queueable, Database.AllowsCallouts {
    private List<Account> accounts;
    public UpdateAccounts(List<Account> records) {
        this.accounts = records;
    }
    public void execute(QueueableContext context) {
        // set<Id> accountIds = new set<Id>();
        list<account> accountsToUpdate = new list<account>();
        list<account> accountsToModify = new list<account>();
        System.debug('queuable accounts list size: ' + accounts.size());
        // workaround for an update in an after update trigger
        accountsToModify = [SELECT ID, Geohash__c, billingLatitude, billingLongitude FROM Account WHERE Id in : accounts];

        if(accountsToModify.size() > 0) {
            if(Test.isRunningTest()){
                // can't make actual callout in test context
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorGeoHash());
            }
            for (Account acc : accountsToModify) {
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                //req.setEndpoint('callout:geohash_world/v1/encode/36.090709,-79.437266?pre=6');
                System.debug('geohash endpoint: ' + 'callout:geohash_world/v1/encode/' + acc.billingLatitude + ',' + acc.billingLongitude + '?pre=6');
                req.setEndpoint('callout:geohash_world/v1/encode/' + acc.billingLatitude + ',' + acc.billingLongitude + '?pre=6');
                // Configure standard headers
                req.setHeader('Accept-Encoding', 'gzip, deflate, br');
                req.setHeader('Accept', '*/*');
                req.setHeader('Connection', 'keep-alive');
                req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                HttpResponse response = h.send(req);
                System.debug('Geohash raw response: ' + response.getBody());
                // Parse JSON response 
                JSONParser parser = JSON.createParser(response.getBody());
                String geoHashString;
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() == 'geohash')) {
                        // Get the value.
                        parser.nextToken();
                        geoHashString = parser.getText();
                    }
                }
                System.debug('Geohash: ' + geoHashString);
            
                if(acc.Geohash__c != geoHashString){
                    acc.Geohash__c = geoHashString;
                    accountsToUpdate.add(acc);
                    System.debug('adding account w/changed Geohash to update list');
                }

            }
        }
        // prevent recursion by only updating if geohash values have changed
        if(accountsToUpdate.size() > 0){
            System.debug('updating accounts');
            update accountsToUpdate;
        }
        
    }
}
