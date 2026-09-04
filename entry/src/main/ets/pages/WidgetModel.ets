export class WidgetModel {
  parameter1: number = 0;
  parameter2: number = 0;
  parameter3: string = 'Unknown';

  constructor(parameter1: number = 0, parameter2: number = 0, parameter3: string = 'Unknown') {
    this.parameter1 = parameter1;
    this.parameter2 = parameter2;
    this.parameter3 = parameter3;
  }
}