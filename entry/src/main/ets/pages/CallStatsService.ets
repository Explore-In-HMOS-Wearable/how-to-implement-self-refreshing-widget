import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

export interface CallStats {
  count: number;
  nextCallAt: number;
}

const PREFS_NAME = 'widget_stats';
const KEY_COUNT = 'callCount';
const KEY_FIRST_CALL = 'firstCallAt';
const UPDATE_INTERVAL_MS: number = 5 * 60 * 1000;

export class CallStatsService {
  static async recordCall(context: common.Context): Promise<CallStats> {
    const store = await preferences.getPreferences(context, PREFS_NAME);

    const currentCount = await store.get(KEY_COUNT, 0) as number;
    const newCount = currentCount + 1;

    let firstCallAt = await store.get(KEY_FIRST_CALL, 0) as number;
    if (firstCallAt === 0) {
      firstCallAt = Date.now();
      await store.put(KEY_FIRST_CALL, firstCallAt);
    }

    await store.put(KEY_COUNT, newCount);
    await store.flush();

    const nextCallAt = Date.now() + UPDATE_INTERVAL_MS;
    const stats: CallStats = {
      count: newCount,
      nextCallAt: nextCallAt
    };
    return stats;
  }

  static formatNextCall(nextCallAt: number): string {
    const date = new Date(nextCallAt);
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');
    return `${hours}:${minutes}`;
  }
}