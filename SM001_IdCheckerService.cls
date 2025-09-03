/**
 * @author Wasim Khadaroo
 * @date 2025-09-03
 * @group Service Manager
 * @description Decodes + saves SA ID, and (separately) fetches ZA holidays by year.
 */
public inherited sharing class SM001_IdCheckerService {

    // Step 1: Decode and Save/Update (no callouts here)
    public static WRP_Types.IdResult decodeAndSave(String idNumber) {
        WRP_Types.IdResult res = new WRP_Types.IdResult();

        // Decode
        UT001_IdNumberUtil.DecodedId dec = UT001_IdNumberUtil.decode(idNumber);
        res.valid = dec.valid; res.message = dec.message; res.idNumber = idNumber;
        res.dateOfBirth = dec.dateOfBirth; res.gender = dec.gender; res.isCitizen = dec.isCitizen;
        if (!dec.valid) return res;

        // Build + upsert + increment counter
        SAIdRecord__c toUpsert = EM001_SAIdRecord.buildFromDecoded(dec);
        SAIdRecord__c existing = null;
        for (SAIdRecord__c r : DM001_SAIdRecord.byIdNumbers(new Set<String>{ dec.idNumber })) {
            existing = r;
        }
        if (existing != null) {
            toUpsert.Id = existing.Id;
            toUpsert.SearchCount__c = (existing.SearchCount__c == null ? 0 : existing.SearchCount__c) + 1;
        } else {
            toUpsert.SearchCount__c = 1;
        }
        DM001_SAIdRecord.upsertRecords(new List<SAIdRecord__c>{ toUpsert });

        // Holidays intentionally NOT fetched here (separate call/transaction)
        return res;
    }

    // Step 2: Fetch holidays (callout only)
    public static List<WRP_Types.Holiday> fetchZAHolidaysByYear(Integer year) {
        if (year == null) return new List<WRP_Types.Holiday>();
        return WS001_CalendarificService.getZAHolidays(year);
    }
}