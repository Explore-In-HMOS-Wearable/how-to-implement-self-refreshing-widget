import { WidgetModel } from './WidgetModel';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';

export class MockDataService {
  static async fetchRandomData(): Promise<WidgetModel> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const parameter1 = Number((generateRandom(100) * 3).toFixed(1));
        const parameter2 = Number((generateRandom(100) * 20).toFixed(1));
        const parameter3 = generateRandom(3) > 1 ? 'High' : 'Low';
        resolve(new WidgetModel(parameter1, parameter2, parameter3));
      }, 300); // simulated network delay
    });
  }
}

function generateRandom(maxLimit: number): number {
  let rand = cryptoFramework.createRandom();
  let randOutput = rand.generateRandomSync(1);
  let mappedRandom = Math.floor((randOutput.data[0]) * maxLimit / 256);

  return mappedRandom;
}
