import { createElement } from 'lwc';
import { registerApexTestWireAdapter   } from '@salesforce/sfdx-lwc-jest';
import LastChanges from 'c/lastChanges';
import getActivityHistory from '@salesforce/apex/LastChangesHelper.getActivityHistory';

const mockGetActivityHistory = require('./data/getActivityHistory.json');
// eslint-disable-next-line no-undef
const getActivityHistoryAdapter = registerApexTestWireAdapter(getActivityHistory);

describe('c-last-changes', () => {
    afterEach(() => {
      while (document.body.firstChild) {
        document.body.removeChild(document.body.firstChild);
      }
      jest.clearAllMocks();
    });
  
    describe('getActivityHistory @wire data', () => {
      it('renders records', () => {
        const element = createElement('c-last-changes', {
          is: LastChanges
        });
        document.body.appendChild(element);
          
        // Emit data from @wire
        getActivityHistoryAdapter.emit(mockGetActivityHistory);
        
        return Promise.resolve().then(() => {
          // Select elements for validation
          const datatable = element.shadowRoot.querySelector('lightning-datatable');
          expect(datatable).toBe(mockGetActivityHistory);
        });
      });
    });
});


    