/**
 * @author Wasim Khadaroo
 * @date 2025-09-02
 * @group Data Manager
 * @description Handles SOQL and DML for SAIdRecord__c
 */
public with sharing class DM001_SAIdRecord {

    public static List<SAIdRecord__c> byIdNumbers(Set<String> idNumbers) {
        if (idNumbers == null || idNumbers.isEmpty()) return new List<SAIdRecord__c>();
        return [
            SELECT Id, IdNumber__c, DateOfBirth__c, Gender__c, IsCitizen__c, SearchCount__c
            FROM SAIdRecord__c
            WHERE IdNumber__c IN :idNumbers
            WITH SECURITY_ENFORCED
        ];
    }

    public static void upsertRecords(List<SAIdRecord__c> records) {
        if (records == null || records.isEmpty()) return;

        // Enforce FLS on the incoming records
        SObjectAccessDecision dec =
            Security.stripInaccessible(AccessType.UPDATABLE, records);

        // Cast back to a concrete List<SAIdRecord__c> for field-based upsert
        List<SAIdRecord__c> cleaned = new List<SAIdRecord__c>();
        for (SObject sob : dec.getRecords()) {
            cleaned.add((SAIdRecord__c)sob);
        }

        upsert cleaned SAIdRecord__c.IdNumber__c;
    }
}