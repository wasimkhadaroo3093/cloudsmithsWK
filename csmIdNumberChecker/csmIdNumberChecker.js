import { LightningElement, track, api } from 'lwc';
import decodeAndSave from '@salesforce/apex/LTN001_IdNumberChecker.decodeAndSave';
import fetchHolidays from '@salesforce/apex/LTN001_IdNumberChecker.fetchHolidays';

export default class CsmIdNumberChecker extends LightningElement {
  @api title = 'SA ID Holiday Checker';

  @track idNumber = '';
  @track loading = false;
  @track info;
  @track holidays = [];
  @track error;

  // Enable button once 13 digits are entered
  get isButtonDisabled() {
    return this.idNumber.length !== 13 || this.loading;
  }

  handleInput(event) {
    // keep digits only, max 13
    this.idNumber = (event.target.value || '').replace(/\D/g, '').slice(0, 13);
  }

  async handleSearch() {
    this.loading = true;
    this.error = undefined;
    this.info = undefined;
    this.holidays = [];
    try {
      // Decode + Save (DML only)
      const res = await decodeAndSave({ idNumber: this.idNumber });
      if (!res || !res.valid) {
        this.error =
          res?.message || 'The ID number is not valid. Please check and try again.';
        return;
      }
      this.info = res;

      // Fetch Holidays (Callout only) for the decoded birth year
      const year = new Date(res.dateOfBirth).getFullYear();
      const hols = await fetchHolidays({ year });
      this.holidays = Array.isArray(hols) ? hols : [];
    } catch (e) {
      this.error = (e && e.body && e.body.message) || e.message || 'Unexpected error';
    } finally {
      this.loading = false;
    }
  }

  // Precompute keys for list rendering
  get holidaysWithKey() {
    return (this.holidays || []).map((h) => ({
      ...h,
      rowKey: `${h.name || ''}-${h.dateIso || ''}`
    }));
  }
}