/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is used to schedule BatchToCreateTaskForContract class
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* @version        1.0
* @created        2020-03-31
* @modified       2020-03-31 
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/

global with sharing class BatchToCreateTaskForContractSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {        
        database.executebatch(new BatchToCreateTaskForContract(),1);
     }
}