@Entry
@Component
struct Index {
  private readonly message: string = 'You can test it by adding a widget to the home screen';

  build() {
    Column() {
      Text(this.message)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .width('60%')
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)

    .height('100%')
    .width('100%');
  }
}