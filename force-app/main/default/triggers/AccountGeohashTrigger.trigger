trigger AccountGeohashTrigger on Account (after insert, after update) {
    //need after insert and after upcate as geohash relies on updated latitude and longitude
    if (Trigger.isInsert) {
        if(Test.isRunningTest()){
            system.debug('********** in account after insert trigger **********');
        }
        // instantiate Queueable class
        UpdateAccounts updateJob = new UpdateAccounts(trigger.new);
        // enqueue the job for processing
        ID jobID = System.enqueueJob(updateJob);
    }

    if (Trigger.isUpdate) {
        if(Test.isRunningTest()){
            system.debug('********** in account after update trigger **********');
        }
        // requirement necessitates updating records in UpdateAccounts class == recursion risk
        // not using trigger handler for brevity
        GeohashHelper.processAccounts(trigger.new, trigger.oldMap);
    }
}