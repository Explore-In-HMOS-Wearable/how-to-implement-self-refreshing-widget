import { FormExtensionAbility, formBindingData, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { CallStatsService } from '../pages/CallStatsService';
import { MockDataService } from '../pages/MockDataService';

const DOMAIN = 0x0000;
const TAG = 'Widget';
const REFRESH_INTERVAL_MINUTES = 5; // system floor, cannot go lower

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    const formId = want.parameters?.[formInfo.FormParam.IDENTITY_KEY] as string;
    if (formId) {
      this.scheduleNextRefresh(formId);
      this.refreshFormData(formId).catch((err: Error) => {
        hilog.error(0x0000, 'EntryFormAbility', `Initial refresh failed: ${err.message}`);
      });
    }
    return formBindingData.createFormBindingData(this.getDefaults());
  }

  async onFormEvent(formId: string, message: string): Promise<void> {
    hilog.info(DOMAIN, TAG, 'onFormEvent: formId=%{public}s message=%{public}s', formId, message);
    await this.refreshFormData(formId);
  }

  async onUpdateForm(formId: string): Promise<void> {
    hilog.info(DOMAIN, TAG, 'onUpdateForm: triggered for formId=%{public}s', formId);
    await this.refreshFormData(formId);
  }

  private async refreshFormData(formId: string): Promise<void> {
    const data = await MockDataService.fetchRandomData();
    const stats = await CallStatsService.recordCall(this.context);
    const nextCallLabel = CallStatsService.formatNextCall(stats.nextCallAt);

    const payload: Record<string, Object> = {
      'parameter1': data.parameter1,
      'parameter2': data.parameter2,
      'parameter3': data.parameter3,
      'callCount': stats.count,
      'nextCallLabel': nextCallLabel
    };

    const formData = formBindingData.createFormBindingData(payload);
    formProvider.updateForm(formId, formData);

    this.scheduleNextRefresh(formId);
  }

  private scheduleNextRefresh(formId: string): void {
    formProvider.setFormNextRefreshTime(formId, REFRESH_INTERVAL_MINUTES, (err: BusinessError) => {
      if (err) {
        hilog.error(DOMAIN, TAG, 'setFormNextRefreshTime failed: %{public}s', err.message);
        return;
      }
      hilog.info(DOMAIN, TAG, 'next refresh armed in %{public}s min', REFRESH_INTERVAL_MINUTES.toString());
    });
  }

  private getDefaults(): Record<string, Object> {
    return {
      'parameter1': 0,
      'parameter2': 0,
      'parameter3': 'Unknown',
      'callCount': 0,
      'nextCallLabel': '--:--'
    };
  }
}