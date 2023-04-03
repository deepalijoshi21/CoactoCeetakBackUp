/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is used to schedule BatchToCreateTaskForDocument class
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* @version        1.0
* @created        2020-03-31
* @modified       2020-03-31 
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/

global with sharing class BatchToCreateTaskForDocumentSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {        
        database.executebatch(new BatchToCreateTaskForDocument(),1);
     }
}