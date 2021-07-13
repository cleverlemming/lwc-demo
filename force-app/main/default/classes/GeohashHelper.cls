public class GeohashHelper {

    public static void processAccounts(List<Account> newAccountList, Map<Id,Account> oldAccountMap){
        List<Account> AccountsToUpdate = new List<Account>();
        for(Account a :newAccountList) {
            //process accounts with changed addresses only
            //geohash values are not updated in this step
            if(a.BillingStreet != oldAccountMap.get(a.id).BillingStreet || a.BillingCity!= oldAccountMap.get(a.id).BillingCity
                || a.BillingState!= oldAccountMap.get(a.id).BillingState || a.BillingPostalCode!= oldAccountMap.get(a.id).BillingPostalCode
                || a.BillingCountry!= oldAccountMap.get(a.id).BillingCountry ||  a.BillingLatitude!= oldAccountMap.get(a.id).BillingLatitude
                || a.BillingLongitude!= oldAccountMap.get(a.id).BillingLongitude) {
                AccountsToUpdate.add(a);    
            }
        }
        if(AccountsToUpdate.size() > 0){
            // instantiate a new instance of the Queueable class
            UpdateAccounts updateJob = new UpdateAccounts(AccountsToUpdate);
            // enqueue the job for processing
            ID jobID = System.enqueueJob(updateJob);
        }
    }
           
}
    
        