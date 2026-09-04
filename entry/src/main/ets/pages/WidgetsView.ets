@Entry
@Component
struct WidgetsView {
  @LocalStorageProp('parameter1') parameter1: number = 0;
  @LocalStorageProp('parameter2') parameter2: number = 0;
  @LocalStorageProp('parameter3') parameter3: string = '';
  @LocalStorageProp('callCount') callCount: number = 0;
  @LocalStorageProp('nextCallLabel') nextCallLabel: string = '--:--';

  build() {
    Column() {
      Column({ space: 8 }) {
        Column({ space: 8 }) {
          Row() {
            Text('parameter1:')
              .fontColor(Color.Gray)
            Text(`${this.parameter1}`)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Text('parameter2:')
              .fontColor(Color.Gray)
            Text(`${this.parameter2}`)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Text('parameter3:')
              .fontColor(Color.Gray)
            Text(`${this.parameter3}`)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }

        Column({ space: 8 }) {
          Row() {
            Text('service calls:')
              .fontColor(Color.Gray)
            Text(`${this.callCount}`)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          Row() {
            Text('next update:')
              .fontColor(Color.Gray)
            Text(`${this.nextCallLabel}`)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
      }
      .width('100%')
      .padding(16)

    }
    .onClick(() => {
      postCardAction(this, {
        action: 'message',
        params: { refreshRequest: 'manual' }
      });
    })
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
  }
}