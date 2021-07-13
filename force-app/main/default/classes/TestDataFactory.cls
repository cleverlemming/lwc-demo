@isTest
public class TestDataFactory {
    public static List<Account> createAccounts(Integer numAccts) {
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i, BillingCity = 'Los Angeles', BillingState = 'CA',
            BillingStreet = '5905 Wilshire Blvd', BillingPostalCode = '90036', BillingCountry = 'USA',
            BillingLatitude = 37.98381, BillingLongitude = 23.727539
            );
            accts.add(a);
        }
       
        //04:23:09:233 USER_DEBUG [46]|DEBUG|Geohash: swbb5f
        
        return accts;
    }
}