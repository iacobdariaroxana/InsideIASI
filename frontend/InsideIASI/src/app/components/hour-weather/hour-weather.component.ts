import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-hour-weather',
  templateUrl: './hour-weather.component.html',
  styleUrls: ['./hour-weather.component.scss'],
})
export class HourWeatherComponent {
  @Input() startHour!: Date;
  @Input() temperature!: number;
  @Input() humidity!: number;
  @Input() precipitation!: number;
}
