@isTest
private class GeohashCalloutTest {
     @isTest static void testCalloutInsert() {
        //  mock set in UpdateAccounts.execute method (no discrete callout method to mock)
        
        //get an account
        Account[] accts = TestDataFactory.createAccounts(1);
        Test.startTest();
        insert accts;
        Test.stopTest();

        List<account> insertedAccounts = [SELECT id, geohash__c from Account WHERE id in :accts];
        for(account acco : insertedAccounts){
            System.assert(!String.isBlank(acco.geohash__c), 'geohash__c not updated on account insert');
        }
       
        //bulk max
        //update
    }
    @isTest static void testCalloutUpdate() {
        //  mock set in UpdateAccounts.execute method 
        
        //get an account
        Account[] accts = TestDataFactory.createAccounts(1);
        insert accts;

        List<account> newAccounts = [SELECT id, billinglatitude, billinglongitude, BillingPostalCode, geohash__c from Account WHERE id in :accts];

        for(account acc : newAccounts){
            acc.billingstreet = '5930 W Jefferson Blvd';
            acc.BillingPostalCode = '90016';
            acc.geohash__c = '';
        }

        Test.startTest();
        update newAccounts;
        Test.stopTest();

        List<account> updatedAccounts = [SELECT id, geohash__c from Account WHERE id in :accts];

        for(account acct : updatedAccounts){
            System.assert(!String.isBlank(acct.geohash__c), 'geohash__c not updated on account update');
        }
        
    }

}